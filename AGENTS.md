# AGENTS.md

Punk is an experimental fork of [php-src](https://github.com/php/php-src): PHP 8.6.0-dev / Zend Engine
4.6.0-dev (API 20250926), tracking upstream `master`, which is merged in periodically. **No changes to PHP
itself exist yet** — the entire diff against upstream is the build tooling described below. The point of the
fork is to make future language changes fast to iterate on, and the current work is replacing autoconf with
meson to get there.

Fork-only C code should be guarded by the `PUNK` / `PUNK_MESON` macros that meson defines project-wide
(today's only use: `Zend/zend_operators.h` disables `memrchr` under `PUNK_MESON`).

## Repo layout

`justfile` and `platform/` are punk's own; everything else is inherited php-src, with punk additions inside
`build/`, `scripts/dev/` and the per-extension `meson.build` files:

| path | contents |
|---|---|
| `justfile` | the only build entry point; dispatches to `platform/$PLATFORM` |
| `platform/` | per-target-triple build environments (`.env`, `shell`, `Dockerfile`, `docker-compose.yml`, `configure`) plus shared `_common/configure-cli` autotools flags |
| `Zend/` | the engine: compiler (`zend_compile.c`, `zend_language_parser.y`), VM (`zend_vm_def.h` → generated `zend_vm_execute.h`), runtime, `Optimizer/`, `zend_vm_gen.php` |
| `main/` | SAPI-independent runtime: request/ini/output/streams, `php.h`, `php_config.h` (generated) |
| `TSRM/` | thread-safety / ZTS layer — punk builds ZTS by default |
| `ext/` | bundled extensions, one dir per extension with `config.m4` *and* `meson.build`; `ext/opcache/Jit/` holds the (currently disabled) JIT |
| `sapi/` | SAPI modules; `cli`, `cgi`, `embed` and `fpm` have meson builds, the rest are upstream-only so far |
| `tests/`, `ext/*/tests/`, `Zend/tests/` | `.phpt` tests (~22.5k), run by `run-tests.php` |
| `build/` | autotools m4 macros, `buildconf`, `gen_stub.php`, `Makefile.global`; `build/regenerate` regenerates lexers/parsers/VM; `build/configure.meson` is the WIP meson port of `configure.ac` |
| `scripts/dev/` | upstream dev helpers plus `ac_converter.py` (WIP autoconf→meson converter); `scripts/gdb/php_gdb.py` for gdb |
| `docs/`, `docs-old/` | internals documentation: Sphinx sources in `docs/source`, older markdown docs (streams, output API, input filters, parameter parsing, self-contained extensions) in `docs-old/` |
| `win32/`, `pear/`, `benchmark/` | upstream-only paths, not part of any punk workflow yet |

## Building

Every build goes through the root `justfile`, which requires `PLATFORM` to name a directory under
`platform/` and runs each recipe through `platform/$PLATFORM/shell`. **Do not invoke docker, meson, ninja,
make or the platform shell script directly** — if a task has no recipe, add one to the `justfile` instead of
working around it.

Configuration and building are deliberately separate steps, and there are two independent configurations:

- `just configure` is the autotools one (`buildconf` plus the platform's `configure`). It writes the config
  headers into the source tree and produces the `Makefile`s `just make`/`just test`/`just all` use.
- `just _meson-setup` is the meson one (wipe the build directory, then `meson setup`); it runs its own checks
  and generates its own copies of every config header into the build directory, so it borrows nothing from
  autoconf. `just meson` builds and installs from that state, `just meson-rebuild` rebuilds in place.

The autoconf chain stays until phpize has been dealt with, so the two have to keep working side by side;
`just compare-config` (and a warning at meson setup time) reports it if their configuration headers ever stop
agreeing.

```sh
PLATFORM=aarch64-linux-gnu just configure       # autotools configuration (writes the source-tree config headers)
PLATFORM=aarch64-linux-gnu just _meson-setup    # meson configuration (owns the build dir; no autoconf needed)
PLATFORM=aarch64-linux-gnu just meson           # meson: setup, compile, test, install (wipes build dir + prefix)
PLATFORM=aarch64-linux-gnu just meson-rebuild   # rebuild in place (no wipe, no install)
PLATFORM=aarch64-linux-gnu just check-modules   # load every built module, report the ones that fail
PLATFORM=aarch64-linux-gnu just check-install   # php-config + installed headers: build an out-of-tree module against them
PLATFORM=aarch64-linux-gnu just compare-config  # diff autoconf's php_config.h against meson's
PLATFORM=aarch64-linux-gnu just all             # autotools: clean, configure, generate, make, install, test
PLATFORM=aarch64-linux-gnu just test Zend/tests/foo.phpt   # .phpt suite, or one file/directory
PLATFORM=aarch64-linux-gnu just test-installed  # .phpt suite against the installed binaries
PLATFORM=aarch64-linux-gnu just shell           # interactive shell in the platform environment
PLATFORM=aarch64-linux-gnu just build-image     # rebuild the platform's docker image
```

`just --list` shows the public recipes; `_`-prefixed recipes (`_meson-setup`, `_meson-compile`,
`_meson-test`, `_meson-install`, `_wipe-build`, `_wipe-install`) are pieces called by the others, and are all
runnable on their own. `just clean` deletes the autotools output *and* every ignored file under `ext/ main/
sapi/ TSRM/ Zend/ scripts/ tests/` — including the generated sources and config headers, so a rebuild after
`just clean` needs `just configure` (re-creates the headers) and `just meson` (re-creates the sources). A
meson-only tree needs neither `just configure` nor `just generate`: re2c, bison and the VM all run inside the
build, and the config headers are generated by meson.

| platform | how it runs |
|---|---|
| `aarch64-linux-gnu` | The only working platform. Runs everything in docker compose: Debian forky image with clang+ccache, meson, just, re2c/bison and every extension's `-dev` library; repo mounted at `/punk`, `/opt/punk` (install prefix) and `/ccache` on named volumes. |
| `aarch64-apple-darwin` | Native macOS (`platform/<plat>/shell` sources `.env` and execs on the host, no docker). Builds against homebrew (`ccache` + homebrew LLVM from `/opt/homebrew/opt/llvm/bin`, since Xcode's tools demand an accepted license); `just meson` works end to end — compile, `_meson-test`, install, `check-modules`, `check-install`. There is no writable `/opt` on the host, so drive it with `just prefix=/tmp/opt/punk …` (or `PUNK_INSTALL_PREFIX`). |

- `platform/<triple>/.env` is git-ignored — copy `.env.example` on a fresh clone. It supplies `CC`/`CXX`
  (`ccache clang`), `NPROC`, `SKIP_SLOW_TESTS=1` and `TEST_PHP_ARGS` (consumed by `run-tests.php`), and it is
  what the container gets via compose `env_file`. On the host, `PLATFORM` must be passed explicitly (direnv
  with the platform `.envrc` is a convenience); `NPROC` falls back to the host CPU count when running just
  outside the container. `BUILD_SAPI` is vestigial: the `justfile` reads it into an unused variable, and
  neither build consults it — the autotools flags in `platform/_common/configure-cli` pick the SAPIs, and the
  meson build builds all four front-ends (cli, cgi, embed, fpm) unconditionally.
- `just shell` opens a shell in the platform environment (the underlying `platform/<triple>/shell` wrapper is
  what `just` runs every recipe through; it execs directly when docker is unavailable, i.e. inside the
  container). Image changes need `just build-image`, which runs on the host — an image cannot be rebuilt from
  inside itself. A `punk-builder` service exists whose entrypoint is `just all`, for one-shot builds.
- `/opt/punk` is a docker volume, not a host path — run the installed `punk` binary from `just shell`. The two
  build paths install over each other in that same prefix.

## The meson port (the active work)

`meson.build` is a per-directory hand port of `configure.ac` + the `config.m4` files. Conventions:

- Each extension declares `ext_<name>_sources = files(...)` and then a `shared_module('name', …,
  name_prefix: '', install: true)` plus `install_headers(..., subdir: 'php/ext/<name>')`. Anything the CLI links
  in also gets an `ext_<name>_objs = static_library(..., build_by_default: false)`. Header lists are explicit
  (meson has no glob) and must match what `config.m4` declared: `configure.ac` names `Zend/ TSRM/ main/
  main/streams/ ext/standard/ ext/mysqlnd/ ext/gd/libgd/` without a file list, so *every* `.h` in those
  directories is installed, while everything else is named file by file.
- The root `meson.build` lists every extension with an explicit `subdir()` call; there is **no feature
  detection** — an extension is built unconditionally and its `dependency()` calls are not optional, so the
  platform image must supply every library.
- Per-extension *defines* from `config.m4` are just as load-bearing as the source lists, and a missing one
  fails silently. `ext/date` is the cautionary example: `timelib.h` tests `HAVE_TIMELIB_CONFIG_H` before
  anything has included `php_config.h`, so config0.m4 passes it on the command line; without it
  `timelib_config.h` is skipped, timelib allocates with `malloc` while PHP frees with `efree`, and every
  interval/`DateTime` code path corrupts the heap.
- `sapi/cli/meson.build` builds the executable **`punk`** and `sapi/cgi/meson.build` builds **`php-cgi`**;
  both link the same core, held in `punk_frontend_sources` / `punk_frontend_dependencies` /
  `punk_frontend_link_whole` at the end of the root `meson.build`. Adding an extension to the binaries means
  adding it there (and to `cli_static_extensions` above). php-cgi is not optional packaging: `run-tests.php`
  drives every `--POST--`/`--GET--`/`--COOKIE--`/`--CGI--` test through it.
- `sapi/embed/meson.build` builds **`libphp`** (`--enable-embed=shared`), the embeddable PHP a host program
  links against. It carries the same core plus the CLI's non-`main` objects (`sapi_cli_shared_sources`,
  because `php_embed` reuses `do_php_cli`), installs the library into `libdir`, and installs `php_embed.h`
  under `include/php/sapi/embed`, so a host includes it as `<sapi/embed/php_embed.h>`.
- `sapi/fpm/meson.build` builds **`php-fpm`**, the process manager. Like the other front-ends it is one
  executable carrying the whole core, plus FPM's own master/worker machinery (one `fpm/events/*.c` per event
  loop, the scoreboard, sockets, logging). It keeps upstream's name — the init script, the man page, the
  systemd unit and the tests all spell `php-fpm` — and installs into `sbindir` rather than `bindir`.
  `fpm/fpm_main.c` has its own `main()`, so it shares no objects with the CLI, but it does generate its own
  arginfo (`fpm/fpm_main.stub.php`). Its configuration files and man page come from the same templates
  autoconf filled in, substituted from meson's directory options, and are installed the way upstream's
  `install-fpm` target does: `etc/php-fpm.conf.default`, `etc/php-fpm.d/www.conf.default`, the status page
  under `share/fpm/`, and `share/man/man8/php-fpm.8`. `init.d.php-fpm` and `php-fpm.service` are generated for
  packagers but not installed, again matching upstream.
- FPM's platform probes live in `build/meson.build` (see its FPM section), and only `sapi/fpm` reads their
  symbols. That is why they are answered even though the note above about adjudicated feature macros applies:
  `HAVE_CLEARENV`, `HAVE_PTRACE` and `HAVE_TIMES` are FPM's, and leaving `HAVE_CLEARENV` out does not even
  compile (FPM's own `clearenv()` collides with glibc's declaration). `HAVE_CLOCK_GETTIME` is the exception —
  `Zend/zend_hrtime.h` reads it — so FPM's clock uses `gettimeofday`; the slowlog-trace backend is picked from
  whichever of ptrace / `/proc/<pid>/mem` / `mach_vm_read` was found, in that order.
- A subdirectory must not rebind `php_config_defs`. It is the one `configuration_data` holding the generated
  C header, and `main/meson.build` writes it out before the SAPI directories run; a later `subdir()` that
  assigns its own object of that name leaves everything after it reading the wrong one.
  `scripts/meson.build` calls its php-config substitutions `php_config_substitutions` for exactly that reason.
- Every `shared_module()` must declare the external libraries it links, in `dependencies:`. A module with
  unresolved symbols still links fine on Linux and only fails when it is loaded, so `just check-modules` runs
  the CLI with every built module loaded and `LD_BIND_NOW=1` — eager binding catches symbols that would
  otherwise only blow up when a code path first calls them. Modules are loaded in one process in
  alphabetical order, which is also how the inter-extension dependencies resolve (`pdo` before the pdo
  drivers, `dom` before `xmlreader`/`xsl`).
- `main/meson.build` generates `main/build-defs.h` from the tracked `build-defs.h.in`, so the compiled-in
  install paths are meson's own. It sets `PHP_EXTENSION_DIR` to meson's `libdir` (`/opt/punk/lib`), which is
  where `shared_module()` installs, unlike autotools' oldstyle
  `$prefix/lib/php/extensions/<debug>-zts-<api>`.
- Install layout: `/opt/punk/bin/punk`, `bin/php-cgi`, `bin/php-config` (generated by `scripts/meson.build`
  from upstream's `php-config.in`), `sbin/php-fpm`, the embed library as `/opt/punk/lib/libphp.{so,dylib}`,
  shared modules flat in `/opt/punk/lib/*.so`, headers under
  `/opt/punk/include/php/{main,streams,Zend,TSRM,sapi,ext/…}`, the man pages `share/man/man1/php-cgi.1` and
  `share/man/man8/php-fpm.8`, and FPM's configuration under `/opt/punk/etc` with its status page in
  `/opt/punk/share/fpm`. `php-config` answers in those terms, reports `--php-binary` as `punk` and names all
  four SAPIs for `--php-sapis`; `php-config.in` gained one placeholder for the binary name, since the meson
  build renames the CLI and the autoconf build does not.
- `just check-install` is the gate on all of that: it checks php-config's answers, compiles a one-file
  out-of-tree extension against `$prefix/include/php` with `cc` and runs it with `$prefix/bin/punk`, and
  verifies that every header of the directories autoconf installed wholesale is installed. That last check is
  not theoretical — it found 57 headers missing (including `main/streams/php_stream_errors.h`, which
  `main/php_streams.h` includes), so the install could not compile anything at all.

Known gaps, in rough priority order:

1. **The m4 stack is still there, for phpize.** meson no longer borrows anything from autoconf — it generates
   every config header and every re2c/bison/VM source itself — but `just configure`/`make`/`test`/`all`
   remain as the autotools path, and `config.m4` + `phpize` have no meson equivalent yet. Deleting
   `configure.ac`, the `build/*.m4` files, `buildconf` and `Makefile.global` waits on that.
2. Source lists in `meson.build` are hand-copied from `config.m4` and drift: `ext/gd` was ~25 files behind
   (including the whole newer libgd drawing/path API) and `ext/zip` was missing `zip_source.c`. Both surface
   as undefined symbols at load time rather than as build errors, which is what `just check-modules` is for —
   compare against `config.m4` when touching an extension.
3. `run-tests.php` derives the cgi and phpdbg binaries from the tested binary's name, which does not work for
   a binary called `punk`; `get_binary()` now refuses to return the tested binary itself, so a build without
   phpdbg skips those tests instead of running them against the CLI. That is a fork-only change to an upstream
   file — worth sending upstream, since it affects any renamed build.

The autotools path (`just all`, flags in `platform/_common/configure-cli`) is still the reference: debug, ZTS,
CLI SAPI, external pcre, JIT and fiber asm disabled, most extensions `=shared`, and `make test` works. Keep
`config.m4` and `meson.build` in sync while both exist.

## Changing PHP

- A new `.c` file must be listed in the `meson.build` of its directory *and* in the corresponding
  `config.m4`. A new extension needs `ext/<name>/meson.build`, a `subdir()` line in the root `meson.build`,
  and (for autotools) an `--enable-…` flag in `platform/_common/configure-cli`.
- Generated sources are all gitignored build products, owned by meson: a `custom_target` in each directory's
  `meson.build` regenerates them with the exact flags `build/regenerate` uses (so the result matches
  autoconf's byte for byte apart from `#line` source paths), and a meson build never needs `just generate`.
  re2c and bison write into the build directory directly.  The VM (`zend_vm_opcodes.h`/`.c`,
  `zend_vm_execute.h`, `zend_vm_handlers.h`) writes into its own source directory, so
  `build/gen-zend-vm.sh` copies the script and its inputs into the build directory and runs the copy there.
  The VM headers are installed by that target's `install:` kwarg (install_headers rejects custom_target
  outputs), which also drops a harmless `zend_vm_opcodes.c` into the include tree.  `build/regenerate` (via
  `just generate`) stays for autoconf, which still needs the source-tree copies; touching any `*.l`, `*.y`,
  `*.re` or `Zend/zend_vm_def.h` is picked up by the next `just meson`.  (Upstream commits the VM files, so an
  upstream merge that touches them will conflict with punk's deletion; the resolution is to regenerate them.)
- Arginfo headers (`*_arginfo.h`, `*_decl.h`, `*_legacy_arginfo.h`) are generated by `build/gen_stub.php` from the
  `*.stub.php` files, into the build directory via `build/gen-stub.sh` (which copies the stub next to the output
  so the `#include` paths stay relative).  Seven `_decl.h` files are the exception: they are `#include`d by
  committed public headers, so they are transitively public and stay committed — `ext/dom/php_dom_decl.h`,
  `ext/pcntl/pcntl_decl.h`, `ext/random/random_decl.h`, `ext/reflection/php_reflection_decl.h`,
  `ext/standard/basic_functions_decl.h`, `ext/uri/php_uri_decl.h`, and `main/streams/stream_errors_decl.h`.
  Every other generated header is gitignored; the meson build regenerates it, and `just generate` (via
  `build/regenerate`) still refreshes the source-tree copies autoconf needs.  `ext/intl`'s arginfo is not
  converted yet and stays committed.
- Style: `CODING_STANDARDS.md` and `.editorconfig`; `clang-format`/`clang-tidy` are in the container. Language
  semantics changes should be reflected in `UPGRADING` / `UPGRADING.INTERNALS`; `EXTENSIONS` lists maintainers.
- Tests for engine changes belong in `Zend/tests/` or `ext/<name>/tests/`; the root `tests/` tree holds
  language-level tests (`lang/`, `classes/`, `func/`, …). Note `tests/.gitignore` ignores everything under it,
  so new files there need `git add -f`.
- Debugging: `.gdbinit` plus `scripts/gdb/php_gdb.py` (`scripts/gdb/debug_gdb_scripts_gen.php` regenerates the
  script list).

## Testing

```sh
PLATFORM=aarch64-linux-gnu just test                        # whole suite, autotools build tree
PLATFORM=aarch64-linux-gnu just test Zend/tests/foo.phpt    # one test file or directory (repeatable)
PLATFORM=aarch64-linux-gnu just _meson-test                 # the same suite, on the binaries just built
PLATFORM=aarch64-linux-gnu just test-installed              # the same suite, on the installed binaries
PLATFORM=aarch64-linux-gnu just test-installed ext/curl/tests
PLATFORM=aarch64-linux-gnu just unit-test                   # meson's test() targets: CLI + embed + FPM smoke tests
```

`just test` needs an autotools build tree (`just configure` + `just make`): `make test` runs the autotools
CLI with `-n`, a generated `tmp-php.ini` and `extension_dir=<build>/modules/`, and it deliberately ignores
the exit status, so read the summary line.

`just _meson-test` runs the suite against `$meson_build_dir/sapi/cli/punk` without installing anything — it
is a step of `just meson`, and also usable on its own for iteration. `just test-installed` does the same for
`$prefix/bin/punk` after `just meson`. Both go through `scripts/dev/run-phpt-suite`, which derives the layout
from the binary's path: for a build directory it symlinks the modules scattered under `ext/` into
`<build>/modules` and points `extension_dir` there, and for an install it uses `$prefix/lib`. Either way it
loads every module except `dl_test` and the ones the binary already contains, points `run-tests.php` at the
matching `php-cgi` for the web tests, exports `TEST_FPM_EXTENSION_DIR` for the FPM tests, and applies the
usual `PHP_TEST_SETTINGS`. `test-installed` propagates the runner's exit status; `_meson-test` ignores it on
purpose, so that `just meson` still installs a build whose tests fail. `PUNK_TEST_INI=<file>` swaps `-n` for
an ini.

`run-tests.php` discovers `sapi/fpm/tests` along with `Zend`, `tests` and `ext`, so those ~143 tests are part
of the ordinary suite once a `php-fpm` exists for them to find: `FPM\Tester::findExecutable()` walks two
directories up from the tested binary, which lands on `<build>/sapi/fpm/php-fpm` for a build directory and on
`$prefix/sbin/php-fpm` for an install. They start their own php-fpm, so they need `TEST_FPM_EXTENSION_DIR`
(to load `session`, `zend_test`, ... the way upstream's build does statically) and they are skipped when the
tests run as root. One of them, `socket-uds-too-long-filename-start.phpt`, cannot pass when the checkout is a
macOS bind mount: `AF_UNIX` paths there are capped well below the 107 characters the test deliberately
overflows the limit with, so the truncated path it expects to bind never binds. On a native Linux checkout it
passes.

`just unit-test` runs meson's own `test()` targets instead, which are smoke tests of the built artefacts
rather than `.phpt` files: `sapi/cli` runs the `punk` binary, `sapi/embed` builds and runs a host program that
embeds PHP, evaluates a snippet and checks the returned value, and `sapi/fpm` runs `php-fpm -n --version`,
which exercises SAPI registration and a whole request startup and shutdown without needing a pool to connect
to.

Either way: extra args come from `TEST_PHP_ARGS` (`-q -j12` here), and `SKIP_SLOW_TESTS=1` / the
default-offline `SKIP_ONLINE_TESTS` prune the suite. Both targets reach every test that the autotools build
does except the `phpdbg` ones, which skip because punk does not build phpdbg; the dozen or so that still fail
(filesystem/permission tests, two soap tests, and run-tests' own self-tests) fail the same way under
`make test`.

## Roadmap constraints (keep these in mind, from the justfile)

- To-do: the remaining `*dbm` packages, ODBC (builds, fails many tests), `pdo_dblib` (crashes the suite),
  getting `mysqli`/`mysqlnd` to load when built shared, the fuzzer SAPI, and gcov/valgrind support.
- Never: `--enable-litespeed` and `--with-ibm-db2` (proprietary), `--with-gdbm`, `--with-readline`, `--with-mhash`,
  `--with-mm`, `--with-pear` (licensing, deprecation, or broken).
- Linux is the only supported target for the foreseeable future; other platforms come later, Windows last.

## Working-tree notes

- `master` mirrors upstream php-src; punk commits sit on top (current branch `branch_naming_is_hard`). Write
  normal descriptive commit messages — the terse one-line subjects in the log are the maintainer's own habit,
  not a convention to copy.
- The punk `.gitignore` ignores root dotfiles/dirs except a few (so `.idea/`, `.junie/`, `.my-meson/` are
  local-only), `.env`, and `actmp.*`; meson build dirs ignore themselves via the `.gitignore` meson writes.
- The authoritative meson build dir is `platform/<PLATFORM>/.meson-build`.
- The `.github/workflows` and `.circleci` configs are upstream php-src's and are not adapted to punk.
