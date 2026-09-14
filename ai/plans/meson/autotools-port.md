# Replacing autoconf with meson

Goal: `php_config.h` and every other configure output come from meson, every m4
file is deleted, and logic that lived in m4 moves to meson or to support scripts
in bash/python.

Status: **phases 1-2 done** (meson generates a config header covering 351 of
autoconf's 449 symbols, with no value mismatches and no symbols autoconf does not
have), phases 3-6 planned below.  Five artifacts are still borrowed from
autoconf; they are the finish line.

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
| `main/php_config.h` | `AC_CONFIG_HEADERS` over 693 symbols (449 defined in this configuration) | meson generates it at `$meson_build_dir/build/php_config.h`; not on the include path yet |
| `Zend/zend_config.h` | `AC_CONFIG_COMMANDS`; a 3-line `#include <../main/php_config.h>` shim | todo, trivial |
| `main/internal_functions_cli.c` (+`internal_functions.c`) | `build/genif.sh` over `internal_functions.c.in` with the static-extension list | todo, easy: the list is already `punk_frontend_sources` |
| `ext/date/lib/timelib_config.h` | `ext/date/config0.m4` heredoc | todo, trivial |
| `ext/mbstring/libmbfl/config.h` | `ext/mbstring/config.m4` heredoc | todo, trivial |
| `scripts/php-config`, `scripts/phpize`, 2 man pages | `AC_CONFIG_FILES` | todo, `configure_file` |
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

Measured after phase 2: autoconf 449 defined, meson 351, no value mismatches, no
symbols meson defines that autoconf does not, 99 still to go (64 platform or
extension probes, 9 `HAVE_LIB*`, 8 `HAVE_GD_*`, 9 other, 5 `PHP_*`, 3 computed
`ZEND_MM_*`, 1 declaration that only exists on FreeBSD).

**Phase 3 — libraries.** `dependency()` for the 42 pkg-config sites, symbol
probes for the 61 `PHP_CHECK_LIBRARY` sites, bundled-vs-external as explicit
options (libgd, pcre2), and the gd/pgsql/snmp/tidy/readline/mysqlnd/iconv
behaviour probes. Exit: the `HAVE_LIB*`/`HAVE_GD_*` categories are empty.

**Phase 4 — runtime and struct probes.** Per-platform answer table for the 36
`AC_RUN_IFELSE` checks, `cc.has_member` for the struct details, `cc.compiles` for
the compiler capabilities. Exit: `just compare-config` prints no differences.

**Phase 5 — the remaining generated files.** `Zend/zend_config.h`,
`internal_functions*.c` (from `punk_frontend_*`, no script needed),
`timelib_config.h`, `libmbfl/config.h`, `php-config`, man pages.

**Phase 6 — switch over and delete.** Move the header generation to
`main/meson.build` (so `<build>/main/php_config.h` shadows the source tree),
`just configure` becomes `meson setup`, then delete the 92 tracked m4 files —
`configure.ac`, the 11 in `build/` (including 311 KB of libtool), 69
`ext/*/config*.m4`, 9 `sapi/*/config*.m4`, `Zend/Zend.m4`, `TSRM/threads.m4`,
`scripts/phpize.m4` — plus 9 `Makefile.frag`, `buildconf`, `buildconf.bat`,
`Makefile.global`, `shtool`, `config.guess`/`config.sub`, `main/php_config.h.in`,
and the autoconf step from `platform/_common/configure-cli` (its flags become
meson options or a native file).

**Validation throughout**: `just compare-config` (symbol diff),
`just meson-rebuild` (configures + builds), `just _meson-test` (full suite),
`just check-modules` (every shared module actually loads).

## Open questions and risks

- **phpize/PECL** is the one externally visible contract in the m4 stack; its
  fate decides whether third-party extensions can still be built from the
  installed tree.
- **Extension-level defines dominate the remainder** (154 of 257). Most are
  mechanical, but each needs a feature option and a dependency check, so it is
  volume rather than difficulty.
- **Runtime probes** are where a wrong answer is silent: the per-platform table
  must be small, explicit and reviewed, not inferred.
- **The diff is only a gate once the adjudications are done**: the six symbols
  meson detects but autoconf did not, and the `HAVE_DECL_P_JAILID` style
  non-Linux leftovers, must be either restored or explicitly dropped.
- **`_GNU_SOURCE` and friends** are currently supplied by autoconf's header even
  to meson-compiled sources; phase 6 must not lose them.
- **Cross-compilation** is not solved by this plan beyond keeping `cc.run()`
  behind an `is_cross_build()` check; punk has no cross targets yet.
