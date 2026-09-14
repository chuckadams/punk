# Replacing autoconf with meson

Goal: `php_config.h` and every other configure output come from meson, every m4
file is deleted, and logic that lived in m4 moves to meson or to support scripts
in bash/python.

Status: **phases 1-5 done.**  Meson generates the config header (`just
compare-config` reports no differences; 445 symbols here against autoconf's 449,
the difference being five deliberate omissions the comparison tool records) and
four of the five other artifacts autoconf used to produce.  What is left is
`scripts/php-config` and the man pages, then the switch-over and the deletion
(phase 6).

## Where configuration belongs in meson

There is no separate configure phase to hook into. `meson setup` creates a build
directory and evaluates the build description; `meson configure` edits stored
option values and re-evaluates the same description. Both run all checks.
Consequences:

- **Do not gate configuration behind an option.** The `configure` boolean in
  `meson.options` is gone; `subdir('build')` now runs unconditionally, and its
  checks execute at setup and whenever the build description or options change.
- **`configure_file()` is `AC_CONFIG_HEADERS`.** Checks write into a
  `configuration_data()` and the header is generated during (re)configuration.
- **`--with/--enable` become meson options.** `option('curl', type: 'feature')`
  gives `-Dcurl=enabled|disabled|auto`; path options become `type: 'string'`.
  `=shared` is not an option value, it selects `shared_module()` vs
  `static_library()`.
- **`summary()` replaces the end-of-configure report**, `error()`/`warning()`
  replace `AC_MSG_ERROR`/`AC_MSG_WARN`.

Two gotchas found the hard way, both now encoded in `build/meson.build`:

- meson substitutes **`#mesondefine NAME`**, not autoconf's bare `#undef NAME`
  (`build/php_config.h.in` is autoheader's template with that one substitution;
  meson rewrites it to `#define NAME value`, or `/* #undef NAME */` when unset).
- autoconf's `AC_USE_SYSTEM_EXTENSIONS` puts a guarded `_GNU_SOURCE` into
  `php_config.h`, and PHP's checks rely on it. Without it, `accept4`, `gettid`,
  `sched_*`, `strptime`, `tm_zone` and friends read as absent. The template now
  carries the guarded define and the checks pass `args: ['-D_GNU_SOURCE']`.
  Today the meson build only sees `_GNU_SOURCE` because it includes autoconf's
  header — a hidden dependency that disappears with the port.

## What autoconf produces that meson must own

| artifact | how autoconf makes it | status |
|---|---|---|
| `main/php_config.h` | `AC_CONFIG_HEADERS` over 693 symbols (449 defined in this configuration) | done: `main/meson.build` generates `$meson_build_dir/main/php_config.h` from the data `build/meson.build` fills |
| `Zend/zend_config.h` | `AC_CONFIG_COMMANDS`; a 3-line `#include <../main/php_config.h>` shim | done: generated into the build's `Zend/` and installed from that file |
| `main/internal_functions_cli.c` (+`internal_functions.c`) | `build/genif.sh` over `internal_functions.c.in` with the static-extension list | done, byte-identical to autoconf's |
| `ext/date/lib/timelib_config.h` | `ext/date/config0.m4` heredoc | done: template in `ext/date/lib/`, `ext/date/lib` on the shared include path |
| `ext/mbstring/libmbfl/config.h` | `ext/mbstring/config.m4` heredoc | done: template in `ext/mbstring/libmbfl/` |
| `scripts/php-config`, `scripts/phpize`, 2 man pages | `AC_CONFIG_FILES` | `php-config` and `php-cgi.1` done; `phpize` deferred with the m4 stack |
| Makefiles, libtool | libtool.m4 (311 KB) + Makefile.global | already replaced by meson targets |

## The define surface

693 symbols in `php_config.h` (449 defined, 244 `#undef`), from 684 autoheader
entries. By check type:

**Trivial (~303, 44%)** — direct meson builtins: 176 `cc.has_function`, 101
`cc.has_header`/`check_header`, 14 `cc.has_header_symbol` (declarations), 7
`cc.has_type`, 5 `cc.sizeof` (plus `cc.has_member` for the struct details listed
under hard). 239 of these are implemented in `build/meson.build` today (92
headers, 147 functions); the rest are either extension/library checks or were
deliberately dropped as non-Linux.

**Intermediate (~195, 28%)**

- `COMPILE_DL_*` + `HAVE_<EXT>` (154): one feature option per extension plus the
  static/shared decision. Meson must generate `COMPILE_DL_<NAME>` itself; today
  it is borrowed, and its absence is what produced entry-point-less modules.
- Libraries: 42 `PKG_CHECK_MODULES` sites → `dependency()`; 61
  `PHP_CHECK_LIBRARY` sites → `cc.find_library()` +
  `cc.has_function(..., dependencies:)`.
- Compiler capabilities (26): `cc.compiles`, `cc.get_supported_arguments`,
  `cc.has_function_attribute` (`ax_gcc_func_attribute.m4`,
  `php_cxx_compile_stdcxx.m4` die here).
- DBA handler selection (`DBA_CDB`, `*_INCLUDE_FILE`, …) — bundled-vs-library
  policy per handler.

**Hard (~188, 27%)**

1. **Runtime probes** (36 `AC_RUN_IFELSE` sites): `ac_cv_crypt_{blowfish,des,
   ext_des,md5,sha256,sha512}`, `php_cv_iconv_{const,errno,ignore}`,
   `php_cv_func_{getaddrinfo,sched_getcpu,ttyname_r}`,
   `php_cv_have_{flush_io,write_stdout}`, `ac_cv_func_fopencookie`,
   `php_cv_shm_ipc`, endianness/EBCDIC, `php_cv_have_pcre2_jit`, page sizes,
   `php_cv_have_shadow_stack_syscall`. Decision: declared answers per platform,
   `cc.run()` only on native builds, and a missing answer is a hard error.
2. **Struct/type detail**: `tm_zone`/`tm_gmtoff`, `sa_len`, `ss_family`,
   `sun_len`, `st_blksize`/`st_blocks`/`st_rdev`, `utsname.domainname`,
   `GWINSZ_IN_SYS_IOCTL`, `MAJOR_IN_SYSMACROS`, `TM_IN_SYS_TIME`,
   `union semun`, `struct cmsgcred`, `socklen_t`, `uid_t`/`gid_t`/`size_t`
   fallbacks. Mostly `cc.has_member`, some need `_GNU_SOURCE`-style preludes.
3. **Per-library behaviour probes**: gd (bundled libgd vs external, plus
   jpeg/png/webp/avif/heif/jxl/tiff/uhdr/xpm/imagequant/freetype), pcre2
   (`PCRE2_CODE_UNIT_WIDTH`, bundled-vs-external), pgsql (`HAVE_PG_*`,
   `HAVE_PQ*`), snmp (`HAVE_SNMP_SHA*`, `HAVE_NETSNMP_INIT_MIB`), sqlite3
   (`HAVE_SQLITE3_EXPANDED_SQL`, `HAVE_SQLITE3_COLUMN_TABLE_NAME`), tidy
   (`HAVE_TIDYOPTGET*`), readline (`HAVE_RL_*`), openssl
   (`HAVE_OPENSSL_ARGON2`, `LOAD_OPENSSL_LEGACY_PROVIDER`,
   `USE_OPENSSL_SYSTEM_CIPHERS`), mysqlnd, ldap flavour, iconv implementation
   (`PHP_ICONV_IMPL`, `HAVE_GLIBC_ICONV`, …), `PDO_ODBC_TYPE`.
4. **Build info** (easy but must be written): `PHP_BUILD_{ARCH,SYSTEM,PROVIDER}`,
   `PHP_UNAME`, `PHP_OS`, `PHP_SYSTEM_GLOB`, `PROC_MEM_FILE`,
   `DEFAULT_SHORT_OPEN_TAG`, `HAVE_BUILD_DEFS_H`, `ZEND_{DEBUG,MM_ALIGNMENT,
   SIGNALS,ZTS,MAX_EXECUTION_TIMERS,FIBER_UCONTEXT,CHECK_STACK_LIMIT}`.
5. **Autoconf-isms to delete, not port**: `LT_OBJDIR`, `C_ALLOCA`,
   `STDC_HEADERS`, `DLSYM_NEEDS_UNDERSCORE`, `MISSING_*_DECL`,
   `PHP_{HPUX,IRIX}_TIME_R`, `HAVE_GCC_GLOBAL_REGS`, `HAVE_PRESERVE_NONE`,
   `HAVE_FPU_INLINE_ASM_X86`, `__MUSL__`, `CRYPT_R_*` variants.

## Non-define surface that also has to move

- **151 configure options** (83 `PHP_ARG_WITH`, 68 `PHP_ARG_ENABLE`) → a small
  option set: per-extension `feature` options plus the few path/implementation
  options the supported platforms need.
- **Static/shared machinery** (`php.m4` 943/957/959): `PHP_ADD_SOURCES`,
  `-DZEND_ENABLE_STATIC_TSRMLS_CACHE`, `-DZEND_COMPILE_DL_EXT`, `COMPILE_DL_*`.
  The target side exists; the defines side is phase 2.
- **`PHP_ADD_EXTENSION_DEP` (43 sites)** — configure-time consistency plus
  runtime load order; needs one authoritative dependency table.
- **SAPI selection** (9 `sapi/*/config*.m4`) — `BUILD_SAPI` in the platform
  `.env` finally becomes a real option (cli/cgi now, phpdbg/embed/fpm later).
- **Custom build steps**: 9 `Makefile.frag` files (parser regeneration already in
  `build/regenerate`; note `ext/tokenizer/tokenizer_data.c` and phar's rules are
  not), `ext/fileinfo`'s data file, `scripts/Makefile.frag`.
- **phpize**: copies `php.m4`, `libtool.m4`, `pkg.m4`, `ax_*.m4`,
  `config.guess`, `config.sub`, `ltmain.sh`, `Makefile.global` into third-party
  extensions and runs autoconf on their `config.m4`. It is the only piece with
  an external contract, and it cannot survive the m4 deletion unchanged.

## Decisions

| question | decision |
|---|---|
| platforms | **Linux only** for now (aarch64 in the container, x86_64 next); leave comments where other POSIX systems would be affected, to be restored later |
| phpize | drop `config.m4` support now, decide phpize's fate after the port |
| migration style | parallel: meson generates alongside autoconf, verified by a symbol diff; autoconf goes when the diff is empty |
| option surface | small, explicit set (per-extension enable/disable + needed paths), not full autoconf fidelity |
| runtime probes | declared per-platform answers, `cc.run()` only when native, hard error when an answer is missing |
| build variants | ZTS/debug/JIT/ZEND_* become options defaulting to today's values (debug+ZTS on, JIT off) |
| just workflow | `just configure` becomes the setup step, `just meson` stays compile+test+install |

## Plan

**Phase 0 — decisions.** Done (table above).

**Phase 1 — platform layer + measurement.** Done:
- `build/configure.meson` → `build/meson.build`, wired in with `subdir('build')`.
- `build/php_config.h.in`: tracked template replacing autoheader's output.
- 239 header/function/declaration/type/sizeof checks; the scaffold's commented
  inventory shrank from ~300 to 225 tokens as entries were implemented.
- `scripts/dev/compare-config-headers` + `just compare-config`: diffs the two
  headers symbol by symbol, treats the inherently per-run `uname` strings as
  volatile, and exits non-zero while they differ.

Measured after phase 1: autoconf 449 defined, meson 204.

**Phase 2 — per-extension defines and build variants.** Done:
- `extension_defines` gives every built extension its `HAVE_<EXT>` (plus the
  sub-features that follow from the build rather than from probing: dba handlers,
  `URI_*`, `PDO_USE_MYSQLND`, `HAVE_TIMELIB_CONFIG_H`, ...), and `COMPILE_DL_<NAME>`
  is derived from `cli_static_extensions`, so the 50 shared modules and the 50
  `COMPILE_DL_*` defines line up exactly with autoconf's.
- Build variants are real options — `-Dzts`, `-Dzend-debug`, `-Dsigchild`,
  `-Dfiber-asm` — defaulting to the configuration punk has always used.
  (`debug` is a reserved meson option name, hence `zend-debug`.)
- Build information: `PHP_OS`, `PHP_UNAME`/`PHP_BUILD_SYSTEM` from `uname -a`,
  `HAVE_BUILD_DEFS_H`, `DEFAULT_SHORT_OPEN_TAG`, `PHP_SIGCHILD`,
  `ZEND_SIGNALS`, `ZEND_FIBER_UCONTEXT`, `ZEND_CHECK_STACK_LIMIT`, the
  `MAJOR_IN_SYSMACROS`/`GWINSZ_IN_SYS_IOCTL` probes and the 16
  `PHP_HAVE_BUILTIN_*` compiler-builtin checks.
- Two mistakes in the inherited scaffold were fixed on the way: the x86
  intrinsics headers (`immintrin.h` and friends) are shipped by clang for every
  target, so probing them would define `HAVE_IMMINTRIN_H` on aarch64, which is not
  what autoconf did; and `linux/if/ether.h`/`linux/if/packet.h`/`linux/sock/diag.h`
  were spelled with slashes where the headers use underscores.
- Six symbols meson detects and autoconf did not (`clearenv`, `clock_gettime`,
  `ptrace`, `times`, `tzname`, and the `tzname` declaration) are deliberately left
  undefined for now: PHP changes behaviour when they are defined, so they need an
  explicit decision rather than a silent divergence.

Measured after phase 2: autoconf 449 defined, meson 351.

**Phase 3 — libraries.** Done:
- The library probes became meson dependencies: `dependency('libpq')`,
  `libldap`/`lber`, `netsnmp`, `tidy`, `libedit`, `libzip`, `openssl`,
  `libpcre2-8`, `gmp`, `sqlite3`, `libargon2`, `zlib`, `libffi`, `oniguruma`,
  and the image libraries gd uses.  A missing library is now a configuration
  error rather than a silently disabled feature.
- Three tables drive the rest: `library_symbols` (a symbol in a library, with the
  header that declares it, which is what `PHP_CHECK_LIBRARY` did),
  `library_headers`, and `library_compiles` for probes that need a body
  (`PGVerbosity`/`PQERRORS_SQLSTATE`, three-argument `ldap_set_rebind_proc`,
  `FFI_SYSV`, glibc iconv, oniguruma's KOI8 entry, opcache's three shared-memory
  backends, `rl_erase_empty_line`).
- gd's image formats follow from the libraries it links, and the bundled-libgd
  defines from the fact that punk always builds the bundled one.
- Probes that autoconf answered with a link test rather than a declaration needed
  care: `has_function` adds `-Werror=implicit-function-declaration`, so each probe
  carries the header that declares its symbol (this is why five of them failed
  first time round — `getgroups` is in unistd.h, `mknod` in sys/stat.h,
  `makedev` is a macro that needs a symbol check, `pcre2.h` needs
  `PCRE2_CODE_UNIT_WIDTH` defined before it is included, and OpenSSL declares
  `OSSL_set_max_threads` in openssl/thread.h, not crypto.h).
- tidy keeps its headers in `/usr/include/tidy` and its `.pc` omits that path, so
  the checks pass it explicitly, matching what ext/tidy/meson.build already does.

Measured after phase 3: autoconf 449 defined, meson 429.

**Phase 4 — runtime probes, compiler capabilities, computed values.** Done:
- Compiler capabilities: `HAVE_FUNC_ATTRIBUTE_IFUNC`/`_VISIBILITY` come from
  meson's own attribute checks, `_TARGET` (which meson's table does not know) from
  asking the compiler with `__has_attribute`, and `HAVE_ALIGNOF`,
  `HAVE_ASM_GOTO` and `HAVE_ATTRIBUTE_ALIGNED` from small compile probes.
- The probes that autoconf answered by compiling *and running* a program are
  compile-time where the answer is a property of the declarations --
  `STRERROR_R_CHAR_P` via `_Generic`, `COOKIE_SEEKER_USES_OFF64_T` via
  `cookie_io_functions_t`, `HAVE_FUNC_GETHOSTBYNAME_R_6` via the six-argument
  call -- and genuinely run only for `PHP_WRITE_STDOUT` and the memory manager
  alignment, which prints its three values for meson to parse.
- The runtime answers a cross build cannot obtain are declared per platform in
  `runtime_answers`, with an undeclared platform a hard error rather than a guess.
- `PHP_USE_PHP_CRYPT_R` turns out not to be a runtime question at all: it follows
  from not passing `--with-external-libcrypt`, and `PHP_CAN_SUPPORT_PROC_OPEN`
  from `fork` being present.

Measured after phase 4: **no differences**.  The gate is green.

**Phase 5 — the remaining generated files.** Done:
- `Zend/zend_config.h` is generated from a tracked `Zend/zend_config.h.in`; being
  a build-directory file is what makes its relative include resolve to the
  build's `php_config.h` rather than the source tree's.
- `main/internal_functions_cli.c` is generated from the existing
  `internal_functions.c.in` with two explicit lists (the includes and the module
  pointers).  Both orders matter -- the include order follows the extension list,
  the pointer order is the registration order that `build/order_by_dep.awk`
  sorted by dependency -- so they are recorded rather than derived, and the result
  is byte-identical to what autoconf's `genif.sh` produced.  The CLI and CGI
  front-ends share one file, since they link the same extensions; autoconf's
  second variant existed for SAPIs with a different built-in set.
- `ext/date/lib/timelib_config.h` and `ext/mbstring/libmbfl/config.h` were
  heredocs in their `config.m4` files and are now templates in those directories,
  generated into the matching build directory so the sources find them the same
  way.  `ext/date` gained `lib/` on its include path and both extensions install
  the generated file rather than the source-tree one.

Verified: the generated `internal_functions_cli.c` is byte-identical to
autoconf's, and the extension/date/mbstring test directories pass against a build
that now compiles meson's copy of it (7008 passing, 0 failing).

**Phase 5 tail — `scripts/php-config`, the header layout and the man pages.** Done:
- `scripts/meson.build` generates `php-config` from the upstream
  `php-config.in`: version and version id are read out of `main/php_version.h`,
  the paths come from meson's prefix/libdir/includedir, `--sapis` from the SAPI
  list, `--libs` from the libraries the front-ends link, and
  `--configure-options` is rendered as the equivalent `meson setup -D…` line.
  `--includes` is `$prefix/include/php` plus its five subdirectories.
- One placeholder was added to `php-config.in`: `@PHP_CLI_BINARY_NAME@`.  The
  meson build installs the CLI as `punk`, so the hardcoded `php` would have made
  `--php-binary` point at a binary that does not exist; the autoconf build sets
  the same variable to `php` and behaves exactly as before.
- Headers install under `include/php/…` instead of straight into `include/`,
  which is upstream's own layout and what `--include-dir` has always reported.
- Of the man pages only `php-cgi.1` is installed: upstream's `php.1` describes a
  binary this fork does not ship under that name, and phpize is not built, so
  `phpize.1` has nothing to document.  `php-config.1` is a candidate to add back
  — we install the tool, just not its man page.
- `just check-install` is the gate for all of it: it asserts php-config's
  answers, compiles a minimal out-of-tree extension against the installed
  headers with `cc` and runs it with the installed `punk`, and checks that every
  header of the directories autoconf installed wholesale is installed.  That
  last check found they were not: 57 headers were missing, including
  `main/streams/php_stream_errors.h`, which `main/php_streams.h` includes — no
  out-of-tree build could compile at all.  `Zend/` (4), `main/` (4),
  `main/streams/` (3), `ext/standard/` (2), `ext/random/` (1), `ext/gd/libgd/`
  (35, a whole subdirectory), and `ext/lexbor`, `ext/opcache` and `ext/uri`
  (which had no `install_headers()` call whatsoever) were completed against the
  autoconf set.  `ext/phar/php_phar.h` stays installed although autoconf did not
  install it: a superset is harmless, dropping it would only break users.

Verified end to end: `just check-install` green, `just compare-config` "no
differences", `just check-modules` loads all 50 modules, and Zend + `ext/date` +
`ext/mbstring` pass 6625/0.

**Phase 6 — meson stands alone; the m4 stack stays.** The deletion half of the
phase is deferred: the autoconf chain has to keep working until phpize/PECL is
dealt with. What remained of the phase — making meson genuinely independent — is
done:

- `php_config.h` is generated by `main/meson.build` into the build's `main/`,
  which is where `Zend/zend_config.h`'s `#include <../main/php_config.h>`
  resolves. The platform checks still live in `build/meson.build`, but the
  configuration data is created in the root `meson.build` and filled in place
  there. The in-place part matters more than it should: meson copies a
  `configuration_data()` object when it is assigned to a local name, so the
  subdirectory must call methods on the root variable directly — an alias
  silently drops every `set()`.
- Two other borrows showed up once the source tree could no longer satisfy them.
  `Zend/meson.build` installed the source tree's `zend_config.h` (a plain string)
  instead of its own generated file, and `timelib_config.h` was only on
  `ext/date`'s own include path while `php_date.h` pulls it into five other
  extensions. The header is now installed from its `configure_file` output, and
  `ext/date/lib` is on the shared include path.
- `just configure` stays autotools and `just _meson-setup` is the meson
  configuration step. Interop is watched two ways: `just compare-config`, and a
  warning at meson setup time when the source tree's `main/php_config.h` (which
  wins for the sources in `main/` — a quoted include looks in the including
  file's own directory first) disagrees with the generated one.

Verified by building with the five autoconf-generated headers physically removed
from the tree: `just _meson-setup` + `just meson-rebuild` + `just _meson-install`
+ `just check-install` are all green, and the installed `php_config.h` is
meson's own. `just configure` + `just make` still produce a working autotools
binary in the same tree.

Left for later, once phpize has a meson equivalent: delete the 92 tracked m4
files, the 9 `Makefile.frag`, `buildconf`, `Makefile.global`, `shtool`,
`config.guess`/`config.sub`, `main/php_config.h.in`, and the autoconf step in
`platform/_common/configure-cli` (its flags become meson options or a native
file).

**Validation throughout**: `just compare-config` (symbol diff),
`just meson-rebuild` (configures + builds), `just _meson-test` (full suite),
`just check-modules` (every shared module actually loads), `just check-install`
(the install is usable from the outside).

## Open questions and risks

- **phpize/PECL** is the one externally visible contract left in the m4 stack, and
  the reason the autoconf chain is retained: until there is a meson equivalent,
  third-party extensions cannot be built from the installed tree with meson
  alone. Deleting the m4 files is blocked on this, deliberately.
- **The two installs overlap.** autoconf and meson both install `bin/php-config`,
  the `include/php/**` headers and `share/man/man1/php-cgi.1` into the same
  `/opt/punk` prefix, so installing one build after the other silently overwrites
  those files. The CLIs differ (`php` vs `punk`) and the shared modules land in
  different directories, so a mixed prefix is mostly harmless but not coherent.
- **`main/` sources take autoconf's header when it exists.** A quoted include
  searches the including file's own directory first, so as long as
  `just configure` has run, the sources in `main/` compile against the
  source-tree `php_config.h` rather than meson's. `just compare-config` and the
  setup-time warning are the guard; true shadowing only happens once the m4
  stack is gone.
- **Cross-compilation** is not solved by this plan beyond keeping `cc.run()`
  behind an `is_cross_build()` check; punk has no cross targets yet.
