# AGENTS.md

Punk is an experimental fork of [php-src](https://github.com/php/php-src): PHP 8.6.0-dev / Zend Engine
4.6.0-dev (API 20250926), tracking upstream `master`, which is merged in periodically. **No changes to PHP
itself exist yet** — the entire diff against upstream is the build tooling described below. The point of the
fork is to make future language changes fast to iterate on; replacing autoconf with meson is what got there.
What is left of the m4 stack is a payload that `phpize` installs and copies, so third-party extensions still
build the autoconf way while punk itself does not use autoconf at all.

Fork-only C code should be guarded by the `PUNK` / `PUNK_MESON` macros that meson defines project-wide
(today's only use: `Zend/zend_operators.h` disables `memrchr` under `PUNK_MESON`).

## Repo layout

`justfile` and `platform/` are punk's own; everything else is inherited php-src, with punk additions inside
`build/`, `scripts/dev/` and the per-extension `meson.build` files:

| path | contents |
|---|---|
| `justfile` | the only build entry point; dispatches to `platform/$PLATFORM` |
| `platform/` | per-target-triple build environments (`.env`, `shell`, `Dockerfile`, `docker-compose.yml`); the configure flags that used to live here and in a shared `_common/configure-cli` are meson options now |
| `Zend/` | the engine: compiler (`zend_compile.c`, `zend_language_parser.y`), VM (`zend_vm_def.h` → generated `zend_vm_execute.h`), runtime, `Optimizer/`, `zend_vm_gen.php` |
| `main/` | SAPI-independent runtime: request/ini/output/streams, `php.h`, `php_config.h` (generated) |
| `TSRM/` | thread-safety / ZTS layer — punk builds ZTS by default |
| `ext/` | bundled extensions, one dir per extension with a `meson.build` (the build) and a `config.m4` (upstream's, no longer read by anything here but kept as the reference the `meson.build` is checked against); `ext/opcache/Jit/` holds the (currently disabled) JIT |
| `sapi/` | SAPI modules; `cli`, `cgi`, `embed`, `fpm`, `phpdbg` and `fuzzer` have meson builds, the rest are upstream-only so far |
| `tests/`, `ext/*/tests/`, `Zend/tests/` | `.phpt` tests (~22.5k), run by `run-tests.php` |
| `build/` | what `phpize` installs and copies into third-party extensions (`php.m4`, the libtool/pkg/ax macros, `Makefile.global`, `shtool`, `config.guess`/`config.sub`, `gen_stub.php`, the vendored `PHP-Parser-5.6.1`), plus the meson port of `configure.ac` in `build/meson.build`, the tracked header templates (`php_config.h.in`, `build-defs.h.in`) and the generation helpers `gen-stub.sh` / `gen-zend-vm.sh` / `gen-language-parser.sh` |
| `scripts/dev/` | upstream dev helpers plus punk's gates (`check-install`, `check-modules`, `check-phpize`) and `run-phpt-suite`; `scripts/gdb/php_gdb.py` for gdb |
| `docs/`, `docs-old/` | internals documentation: Sphinx sources in `docs/source`, older markdown docs (streams, output API, input filters, parameter parsing, self-contained extensions) in `docs-old/` |
| `win32/`, `pear/`, `benchmark/` | upstream-only paths, not part of any punk workflow yet |

## Building

Every build goes through the root `justfile`, which requires `PLATFORM` to name a directory under
`platform/` and runs each recipe through `platform/$PLATFORM/shell`. **Do not invoke docker, meson, ninja,
make or the platform shell script directly** — if a task has no recipe, add one to the `justfile` instead of
working around it.

There is one configuration, and it is meson's. `just _meson-setup` wipes the build directory and runs
`meson setup`, which does every check and writes every generated header into the build directory:
`main/php_config.h`, `Zend/zend_config.h`, `main/build-defs.h`, `ext/date/lib/timelib_config.h` and
`ext/mbstring/libmbfl/config.h`. Nothing lands in the source tree, so there is no separate configure step to
run and `meson configure` edits the stored options in place. `just meson` runs the whole chain — setup,
compile, the `.phpt` suite, install, then the phpize gate — and `just meson-rebuild` recompiles in place
without wiping or installing.

The autoconf build is gone: no `configure.ac`, no `buildconf`, no tree-side `build/*.m4`, no `Makefile.global`
driving anything here, and no `platform/_common/configure-cli` (the per-platform `configure` wrapper that
sourced it went with it). What survives of the m4 stack is the payload phpize ships to third-party extension
authors — see "phpize and third-party extensions" below.

```sh
PLATFORM=aarch64-linux-gnu just _meson-setup    # meson configuration (owns the build dir)
PLATFORM=aarch64-linux-gnu just meson           # setup, compile, test, install, check-phpize (wipes build dir + prefix)
PLATFORM=aarch64-linux-gnu just meson-rebuild   # rebuild in place (no wipe, no install)
PLATFORM=aarch64-linux-gnu just fuzzer          # the Clang fuzzing SAPI, in a build dir of its own
PLATFORM=aarch64-linux-gnu just check-modules   # load every built module, report the ones that fail
PLATFORM=aarch64-linux-gnu just check-install   # php-config + installed headers: build an out-of-tree module against them
PLATFORM=aarch64-linux-gnu just check-phpize    # phpize + payload: build a third-party extension the autoconf way
PLATFORM=aarch64-linux-gnu just test Zend/tests/foo.phpt   # .phpt suite, or one file/directory
PLATFORM=aarch64-linux-gnu just test-installed  # .phpt suite against the installed binaries
PLATFORM=aarch64-linux-gnu just shell           # interactive shell in the platform environment
PLATFORM=aarch64-linux-gnu just build-image     # rebuild the platform's docker image
```

`just --list` shows the public recipes; `_`-prefixed recipes (`_meson-setup`, `_meson-compile`,
`_meson-install`, `_fuzzer-setup`, `_fuzzer-compile`, `_wipe-build`, `_wipe-fuzzer-build`, `_wipe-install`)
are pieces called by the others, and are all runnable on their own. `just clean` removes build leftovers and
every ignored file under `ext/ main/ sapi/ TSRM/ Zend/ scripts/ tests/`; meson regenerates all of it, so a
rebuild after `just clean` is just `just meson`. The fuzzer's build directory is
`<platform>/.meson-build-fuzzer`, alongside the authoritative `.meson-build`; `_wipe-fuzzer-build` is what
removes it.

| platform | how it runs |
|---|---|
| `aarch64-linux-gnu` | The only working platform. Runs everything in docker compose: Debian forky image with clang+ccache, meson, just, re2c/bison and every extension's `-dev` library; repo mounted at `/punk`, `/opt/punk` (install prefix) and `/ccache` on named volumes. |
| `aarch64-apple-darwin` | Native macOS (`platform/<plat>/shell` sources `.env` and execs on the host, no docker). Builds against homebrew (`ccache` + homebrew LLVM from `/opt/homebrew/opt/llvm/bin`, since Xcode's tools demand an accepted license); `just meson` works end to end — compile, `just test`, install, `check-modules`, `check-install`, `check-phpize`. There is no writable `/opt` on the host, so drive it with `just prefix=/tmp/opt/punk …` (or `PUNK_INSTALL_PREFIX`). |

- `platform/<triple>/.env` is git-ignored — copy `.env.example` on a fresh clone. It supplies `CC`/`CXX`
  (`ccache clang`), `SKIP_SLOW_TESTS=1` and `TEST_PHP_ARGS` (consumed by `run-tests.php`), plus whatever the
  platform needs on `PATH`/`PKG_CONFIG_PATH`, and it is what the container gets via compose `env_file`. On
  the host, `PLATFORM` must be passed explicitly (direnv with the platform `.envrc` is a convenience).
  `NPROC` and `BUILD_SAPI` are left over from the autotools recipes and nothing reads them any more: meson
  builds all five front-ends (cli, cgi, embed, fpm, phpdbg) unconditionally and does its own parallelism.
  The fuzzer SAPI is the exception, off unless `-Dfuzzer=true` and then wanting a build directory of its own
  (see `just fuzzer` below).
- `just shell` opens a shell in the platform environment (the underlying `platform/<triple>/shell` wrapper is
  what `just` runs every recipe through; it execs directly when docker is unavailable, i.e. inside the
  container). Image changes need `just build-image`, which runs on the host — an image cannot be rebuilt from
  inside itself. A `punk-builder` service exists whose entrypoint is `just meson`, for one-shot builds.
- The container image keeps `autoconf`, `autoheader` and `make` even though punk's own build no longer uses
  them: `just check-phpize` needs them, and so does anyone building an extension against the install.
- `/opt/punk` is a docker volume, not a host path — run the installed `punk` binary from `just shell`.

## The meson build

`meson.build` is a per-directory hand port of what `configure.ac` and the `config.m4` files used to do. With
autoconf gone, `meson.build` is the only description of the build; the `config.m4` files stay as the
reference it was ported from. Conventions:

- Each extension declares `ext_<name>_sources = files(...)` and then a `shared_module('name', …,
  name_prefix: '', install: true)` plus `install_headers(..., subdir: 'php/ext/<name>')`. Anything the CLI links
  in also gets an `ext_<name>_objs = static_library(..., build_by_default: false)`. Header lists are explicit
  (meson has no glob) and must match what `config.m4` declared: the install lists name `Zend/ TSRM/ main/
  main/streams/ ext/standard/ ext/mysqlnd/ ext/gd/libgd/` without a file list, so *every* `.h` in those
  directories is installed, while everything else is named file by file.
- The root `meson.build` lists every extension with an explicit `subdir()` call; there is **no feature
  detection** — an extension is built unconditionally and its `dependency()` calls are not optional, so the
  platform image must supply every library.
- Per-extension *defines* from `config.m4` are just as load-bearing as the source lists, and a missing one
  fails silently. `ext/date` is the cautionary example: `timelib.h` tests `HAVE_TIMELIB_CONFIG_H` before
  anything has included `php_config.h`, so `ext/date/meson.build` passes it on the command line; without it
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
- `sapi/phpdbg/meson.build` builds **`phpdbg`**, the interactive debugger. It is the one front-end with a
  command language of its own, so it is also the only one that generates a lexer and a parser: re2c and bison
  run as `custom_target`s, and both are listed as sources of the executable, which is what orders them before
  the generated lexer is compiled against the generated parser header. The flags are the ones the autoconf
  build's Makefile fragment asked re2c for (`-F` for flex syntax, `-i` to leave `#line` out). Its
  `phpdbg.stub.php` produces the arginfo headers for the `phpdbg_*()` functions, and `phpdbg.1.in` is
  configured from meson's `PHP_VERSION`. Of the two symbols `sapi/phpdbg/config.m4` contributes,
  `HAVE_USERFAULTFD_WRITEFAULT` (what its write watchpoints use) is probed from `linux/userfaultfd.h` under
  the ZTS default, while `HAVE_PHPDBG_READLINE` is deliberately left undefined: `--enable-phpdbg-readline`
  defaults to no and upstream's CI passes a bare `--enable-phpdbg`, so phpdbg's prompt reads a line at a time
  in the reference build too. Punk links libedit into every front-end, so turning it on is a one-line change.
- `sapi/fuzzer/meson.build` builds the **fuzzing SAPI** (upstream's `--enable-fuzzer`): `fuzzer-sapi.c`
  plus one `LLVMFuzzerTestOneInput` per fuzzer, each linked into its own binary. It is the only directory the
  root `meson.build` enters conditionally, because it is not a front-end punk ships but a target set that
  cannot share a configuration with the rest of the tree. `just fuzzer` is the recipe: it sets up
  `<platform>/.meson-build-fuzzer` with `-Dfuzzer=true -Dzts=false -Db_sanitize=<fuzz_sanitize>`, then
  `meson compile … fuzzer`, an `alias_target` over the seven binaries, so it builds them rather than the
  front-ends and modules that build directory also describes. Nothing installs. The three reasons for the
  separate directory are in the file's header, and the two that are easy to get wrong are: `config.m4`
  refuses `--enable-fuzzer` with ZTS, so the fuzzer build cannot be the ZTS default; and the root
  `meson.build` adds `-fsanitize=fuzzer-no-link` to every compilation when the option is on, because
  libFuzzer's coverage feedback is the whole mechanism, and it errors if `b_sanitize` names no real sanitizer
  for the runtime those instrumented objects need. The core is built once as a `static_library` and
  `link_whole`d into each fuzzer, since meson compiles per target and the core is 400-odd objects.
  `php-fuzz-exif`, `php-fuzz-mbstring` and `php-fuzz-mbregex` are deliberately not built: they need those
  extensions linked in rather than loaded, which needs an extension-set option this port does not have (see
  the to-do below). One caveat when running one: libFuzzer writes new coverage-increasing inputs into the
  corpus directory it is given, so run it against a copy (`cp -r sapi/fuzzer/corpus/json ./my-corpus`) as
  `sapi/fuzzer/README.md` says, or the in-tree corpus grows.
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
- Install layout: `/opt/punk/bin/punk`, `bin/php-cgi`, `bin/phpdbg`, `bin/php-config` (generated by
  `scripts/meson.build` from upstream's `php-config.in`), `sbin/php-fpm`, the embed library as
  `/opt/punk/lib/libphp.{so,dylib}`, shared modules flat in `/opt/punk/lib/*.so`, headers under
  `/opt/punk/include/php/{main,streams,Zend,TSRM,sapi,ext/…}`, the man pages `share/man/man1/php-cgi.1`,
  `share/man/man1/phpdbg.1` and `share/man/man8/php-fpm.8`, and FPM's configuration under `/opt/punk/etc`
  with its status page in `/opt/punk/share/fpm`. `php-config` answers in those terms, reports `--php-binary`
  as `punk` and names all five SAPIs for `--php-sapis`; `php-config.in` gained one placeholder for the binary
  name, since the meson build renames the CLI and the autoconf build does not.
- `just check-install` is the gate on all of that: it checks php-config's answers, compiles a one-file
  out-of-tree extension against `$prefix/include/php` with `cc` and runs it with `$prefix/bin/punk`, and
  verifies that every header of the directories autoconf installed wholesale is installed. That last check is
  not theoretical — it found 57 headers missing (including `main/streams/php_stream_errors.h`, which
  `main/php_streams.h` includes), so the install could not compile anything at all.

Known gaps, in rough priority order:

1. **`config.m4` and `meson.build` can drift, and nothing checks it.** The `config.m4` files are no longer
   read by anything, so an upstream change to one is invisible until someone compares it by hand. Source
   lists have drifted before: `ext/gd` was ~25 files behind (including the whole newer libgd drawing/path
   API) and `ext/zip` was missing `zip_source.c`. Drift surfaces as undefined symbols at load time rather
   than as build errors, which is what `just check-modules` is for — compare against `config.m4` when
   touching an extension, and when an upstream merge brings one in.
2. `run-tests.php` derives the cgi and phpdbg binaries from the tested binary's name, which does not work for
   a binary called `punk`: `get_binary()` substitutes "php" for the sapi in that name, and `punk` contains no
   "php", so it now refuses to return the tested binary rather than let it pass as its own cgi or phpdbg.
   Those tests therefore skip, and `scripts/dev/run-phpt-suite` exports `TEST_PHP_CGI_EXECUTABLE` and
   `TEST_PHPDBG_EXECUTABLE` to fill the gap — the build tree's layout happens to satisfy `get_binary()`'s
   source-tree probe, an install's does not. That is a fork-only change to an upstream file — worth sending
   upstream, since it affects any renamed build.
3. A few upstream files still describe the autoconf build, and are left alone as upstream files: `README.md`
   and `scripts/dev/makedist` run `./buildconf` and `./configure` (both gone, so `makedist` no longer works
   and the README's build instructions do not apply to this fork — use the recipes above), `ext/ext_skel.php`
   offers `buildconf`/`configure --enable-ext` as the in-tree way to add an extension (the phpize path it
   leads with is the one that still works), `ext/tokenizer/tokenizer_data_gen.php`'s error message names
   `scripts/dev/genfiles`, and the `.github/` and `.circleci/` configs run the old build throughout.

## phpize and third-party extensions

`phpize` is the one piece of the autoconf build that survives, and it survives by being *shipped* rather than
replaced. It is not a build input of this tree any more: `scripts/meson.build` installs the payload into
`$prefix/lib/build` (the destination `phpize.in` derives from `@libdir@`), alongside `bin/phpize`, `bin/php-config`
and their man pages.

The payload is `phpize.m4` plus what autoconf needs to expand a `config.m4`: `php.m4` and the
libtool/pkg/ax macro files, `ltmain.sh`, `Makefile.global`, `shtool`, `config.guess`, `config.sub`,
`gen_stub.php` and `run-tests.php`. PHP-Parser 5.6.1 is vendored in `build/PHP-Parser-5.6.1/` and installed
with them, because `gen_stub.php` downloads it from GitHub when it is not beside itself — the vendored copy is
what makes an out-of-tree `.stub.php` work offline. (That is also why `scripts/phpize.in` copies
`PHP-Parser-*` along with its named file list; it globs, so the version stays pinned in `gen_stub.php` alone.)

`just check-phpize` is the gate. It builds a throwaway extension — one option, one `AC_DEFINE`, one module,
one `.phpt` — through `phpize`, `configure`, `make`, arginfo generation and `make test`, and loads the result
into the installed binary. It is skipped rather than failed when `autoconf`, `autoheader` or `make` is
missing, because punk's own build must not depend on them. `just meson` runs it after installing.

What this does *not* do is make out-of-tree builds autoconf-free: an extension author still needs autoconf,
autoheader, make, a C compiler and `sed`/`awk`, exactly as before. The m4 stack is quarantined, not
eliminated. Two smaller consequences: `run-tests.php` wants `$ext/.github/lsan-suppressions.txt` and
`$ext/scripts/dev/bless_tests.php` for `--bless` and lsan suppressions, neither of which phpize copies, so
those two modes do not work out of tree; and `gen_stub.php` needs the `tokenizer` extension, which punk builds
shared.

## Changing PHP

- A new `.c` file goes into the `meson.build` of its directory. A new extension needs `ext/<name>/meson.build`
  and a `subdir()` line in the root `meson.build`; there is no configure flag to add, because every extension
  in the tree is built unconditionally. Upstream will add the matching `config.m4`, and keeping it in step
  with the `meson.build` is how the next person can tell what the port was meant to say.
- Generated sources are all gitignored build products, owned by meson: a `custom_target` in each directory's
  `meson.build` regenerates them with the exact flags the autoconf build used, so a meson build never needs a
  generation step of its own. re2c and bison write into the build directory directly.  The VM
  (`zend_vm_opcodes.h`/`.c`, `zend_vm_execute.h`, `zend_vm_handlers.h`) writes into its own source directory,
  so `build/gen-zend-vm.sh` copies the script and its inputs into the build directory and runs the copy there.
  The VM headers are installed by that target's `install:` kwarg (install_headers rejects custom_target
  outputs), which also drops a harmless `zend_vm_opcodes.c` into the include tree.  Touching any `*.l`, `*.y`,
  `*.re` or `Zend/zend_vm_def.h` is picked up by the next `just meson`.  (Upstream commits the VM files, so an
  upstream merge that touches them will conflict with punk's deletion; the resolution is to regenerate them.)
- Arginfo headers (`*_arginfo.h`, `*_decl.h`, `*_legacy_arginfo.h`) are generated by `build/gen_stub.php` from the
  `*.stub.php` files, into the build directory via `build/gen-stub.sh` (which copies the stub next to the output
  so the `#include` paths stay relative).  Seven `_decl.h` files are the exception: they are `#include`d by
  committed public headers, so they are transitively public and stay committed — `ext/dom/php_dom_decl.h`,
  `ext/pcntl/pcntl_decl.h`, `ext/random/random_decl.h`, `ext/reflection/php_reflection_decl.h`,
  `ext/standard/basic_functions_decl.h`, `ext/uri/php_uri_decl.h`, and `main/streams/stream_errors_decl.h`.
  Every other generated header is gitignored and regenerated by the meson build.  `ext/intl`'s arginfo is not
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
PLATFORM=aarch64-linux-gnu just test                        # whole suite, on the binaries just built
PLATFORM=aarch64-linux-gnu just test Zend/tests/foo.phpt    # one test file or directory (repeatable)
PLATFORM=aarch64-linux-gnu just test-installed              # the same suite, on the installed binaries
PLATFORM=aarch64-linux-gnu just test-installed ext/curl/tests
PLATFORM=aarch64-linux-gnu just unit-test                   # meson's test() targets: one smoke test per front-end
```

`just test` runs the suite against `$meson_build_dir/sapi/cli/punk` without installing anything — it is a
step of `just meson`, and also usable on its own for iteration. `just test-installed` does the same for
`$prefix/bin/punk` after `just meson`. Both go through `scripts/dev/run-phpt-suite`, which derives the layout
from the binary's path: for a build directory it symlinks the modules scattered under `ext/` into
`<build>/modules` and points `extension_dir` there, and for an install it uses `$prefix/lib`. Either way it
loads every module except `dl_test` and the ones the binary already contains, points `run-tests.php` at the
matching `php-cgi` for the web tests, exports `TEST_FPM_EXTENSION_DIR` for the FPM tests and
`TEST_PHPDBG_EXECUTABLE` for the phpdbg ones, and applies the usual `PHP_TEST_SETTINGS`. `test-installed`
propagates the runner's exit status; `test` ignores it on purpose, so that `just meson` still installs a
build whose tests fail — read the summary line. `PUNK_TEST_INI=<file>` swaps `-n` for an ini.

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
embeds PHP, evaluates a snippet and checks the returned value, `sapi/fpm` runs `php-fpm -n --version` and
`sapi/phpdbg` runs `phpdbg -n -V`. Each of the last two starts the engine, registers the SAPI and tears it
down again, which is the cheapest thing that fails if the front-end is not actually wired up.

Because punk now builds phpdbg, the `--PHPDBG--` tests run too — 75 of them, in `sapi/phpdbg/tests/` and two
under `Zend/tests/stack_limit/`. They were skipping before, and they are worth reaching: they are what covers
the debugger's breakpoints, watchpoints, eval and stepping. `run-phpt-suite` has to pass
`TEST_PHPDBG_EXECUTABLE` for the installed case, because `get_binary()` cannot derive a `phpdbg` from a binary
called `punk` (see below); in a build directory it would find `<build>/sapi/phpdbg/phpdbg` by path anyway.

Either way: extra args come from `TEST_PHP_ARGS` (`-q -j12` here), and `SKIP_SLOW_TESTS=1` / the
default-offline `SKIP_ONLINE_TESTS` prune the suite. The dozen or so that still fail (filesystem/permission
tests, two soap tests, and run-tests' own self-tests) are upstream failures, not port ones.

## Roadmap constraints (keep these in mind, from the justfile)

- To-do: the remaining `*dbm` packages, ODBC (builds, fails many tests), `pdo_dblib` (crashes the suite),
  getting `mysqli`/`mysqlnd` to load when built shared, an option for which extensions are static (so the
  fuzzer build can be minimal and the exif/mbstring/mbregex fuzzers can link), and gcov/valgrind support.
- Never: litespeed and ibm-db2 (proprietary), gdbm, readline, mhash, mm, pear (licensing, deprecation, or
  broken).
- Linux is the only supported target for the foreseeable future; other platforms come later, Windows last.

## Working-tree notes

- `master` mirrors upstream php-src; punk commits sit on top (current branch `yeet_autoconf`). Write normal
  descriptive commit messages — the terse one-line subjects in the log are the maintainer's own habit, not a
  convention to copy.
- The punk `.gitignore` ignores root dotfiles/dirs except a few (so `.idea/`, `.junie/`, `.my-meson/` are
  local-only), `.env`, and `actmp.*`; meson build dirs ignore themselves via the `.gitignore` meson writes.
  `build/PHP-Parser-5.6.1` is the one vendored dependency and is deliberately *not* ignored — the surrounding
  `build/PHP-Parser-*` rule keeps any other version gen_stub.php downloads out of the tree.
- The authoritative meson build dir is `platform/<PLATFORM>/.meson-build`.
- The `.github/workflows` and `.circleci` configs are upstream php-src's and are not adapted to punk.
