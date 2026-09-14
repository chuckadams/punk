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
| `sapi/` | SAPI modules; `cli` and `cgi` have meson builds, the rest are upstream-only so far |
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

Configuration and building are deliberately separate steps: `just configure` performs configuration (today
`buildconf` plus the platform's autotools `configure` — a leftover the switch-over deletes in favour of
`meson setup`), and `just meson` then builds and installs from that state without configuring anything
itself. meson does run its own checks and generates its own config headers; the autotools ones exist for
`just all` and `just test`.

```sh
PLATFORM=aarch64-linux-gnu just configure       # once, and again after `just clean`
PLATFORM=aarch64-linux-gnu just meson           # meson: generate, setup, compile, test, install (wipes build dir + prefix)
PLATFORM=aarch64-linux-gnu just meson-rebuild   # regenerate + rebuild in place (no wipe, no install)
PLATFORM=aarch64-linux-gnu just check-modules   # load every built module, report the ones that fail
PLATFORM=aarch64-linux-gnu just check-install   # php-config + installed headers: build an out-of-tree module against them
PLATFORM=aarch64-linux-gnu just all             # autotools: clean, configure, generate, make, install, test
PLATFORM=aarch64-linux-gnu just test Zend/tests/foo.phpt   # .phpt suite, or one file/directory
PLATFORM=aarch64-linux-gnu just test-installed  # .phpt suite against the installed binaries
PLATFORM=aarch64-linux-gnu just shell           # interactive shell in the platform environment
PLATFORM=aarch64-linux-gnu just build-image     # rebuild the platform's docker image
```

`just --list` shows the public recipes; `_`-prefixed recipes (`_meson-setup`, `_meson-compile`,
`_meson-test`, `_meson-install`, `_wipe-build`, `_wipe-install`) are pieces called by the others, and are all
runnable on their own. `_meson-compile` only works once the generated lexers/parsers exist, which is why
`meson-rebuild` wraps it. `just clean` deletes the autotools output *and* every ignored file under `ext/ main/
sapi/ TSRM/ Zend/ scripts/ tests/` — including the generated sources and config headers, so a rebuild after
`just clean` needs `just configure` (re-creates the headers) and `just meson` (re-creates the sources).

| platform | how it runs |
|---|---|
| `aarch64-linux-gnu` | The only working platform. Runs everything in docker compose: Debian forky image with clang+ccache, meson, just, re2c/bison and every extension's `-dev` library; repo mounted at `/punk`, `/opt/punk` (install prefix) and `/ccache` on named volumes. |
| `aarch64-apple-darwin` | Native macOS (`platform/<plat>/shell` sources `.env` and execs on the host, no docker). Deliberately only far enough to give CLion a meson project model via `platform/aarch64-apple-darwin/.meson-build`; it does **not** produce a working build. |

- `platform/<triple>/.env` is git-ignored — copy `.env.example` on a fresh clone. It supplies `CC`/`CXX`
  (`ccache clang`), `NPROC`, `SKIP_SLOW_TESTS=1` and `TEST_PHP_ARGS` (consumed by `run-tests.php`), and it is
  what the container gets via compose `env_file`. On the host, `PLATFORM` must be passed explicitly (direnv
  with the platform `.envrc` is a convenience); `NPROC` falls back to the host CPU count when running just
  outside the container. `BUILD_SAPI` is vestigial — SAPI selection is hardcoded to CLI for now.
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
- Install layout: `/opt/punk/bin/punk`, `bin/php-config` (generated by `scripts/meson.build` from upstream's
  `php-config.in`), shared modules flat in `/opt/punk/lib/*.so`, headers under
  `/opt/punk/include/php/{main,streams,Zend,TSRM,ext/…}`, and `share/man/man1/php-cgi.1`. `php-config` answers
  in those terms and reports `--php-binary` as `punk`; `php-config.in` gained one placeholder for that, since
  the meson build renames the CLI and the autoconf build does not.
- `just check-install` is the gate on all of that: it checks php-config's answers, compiles a one-file
  out-of-tree extension against `$prefix/include/php` with `cc` and runs it with `$prefix/bin/punk`, and
  verifies that every header of the directories autoconf installed wholesale is installed. That last check is
  not theoretical — it found 57 headers missing (including `main/streams/php_stream_errors.h`, which
  `main/php_streams.h` includes), so the install could not compile anything at all.

Known gaps, in rough priority order:

1. **Meson still depends on autoconf for configuration headers.** `main/php_config.h`, `Zend/zend_config.h`,
   `ext/date/lib/timelib_config.h` and `ext/mbstring/libmbfl/config.h` are produced by `./configure`
   (`build-defs.h` is the one header meson now generates itself; nothing else uses `configure_file()` yet),
   and a compile without them fails on `<zend_config.h>`. So the order today is `just configure` (autotools)
   first, then `just meson`. `build/configure.meson` is the unfinished replacement — it is marked "not usable
   yet" and its `subdir()` call is commented out of `meson.build`; `scripts/dev/ac_converter.py` helps
   translate `config.h.in` checks.
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
- Generated sources are checked in and produced by `build/regenerate` via `just generate`: re2c for the
  scanners, bison for the parsers, and `php Zend/zend_vm_gen.php` for the VM. Run it after touching `*.l`,
  `*.y`, `*.re`, or `Zend/zend_vm_def.h`.
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
matching `php-cgi` for the web tests, and applies the usual `PHP_TEST_SETTINGS`. `test-installed` propagates
the runner's exit status; `_meson-test` ignores it on purpose, so that `just meson` still installs a build
whose tests fail. `PUNK_TEST_INI=<file>` swaps `-n` for an ini.

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
