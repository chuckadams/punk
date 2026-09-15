# The platform checks below fill in the configuration data that the root
# meson.build created, so that main/meson.build can write the header out of it:
# configure_file() cannot write into a subdirectory of its own build directory,
# and the header has to be generated into the build's main/.  Note that the
# variable has to be used directly -- assigning it to a local name would copy
# it, and the writes would then be lost.

# Checks must see the same feature-test macros as the build, or GNU/POSIX
# extensions look absent (accept4, gettid, sched_*, strptime, tm_zone, ...).
check_args = ['-D_GNU_SOURCE']
# Headers.  The x86 intrinsics headers (immintrin.h, nmmintrin.h, tmmintrin.h,
# wmmintrin.h, cpuid.h) are deliberately absent: clang ships them for every
# target, so probing them here would define HAVE_IMMINTRIN_H on aarch64, which is
# not what autoconf did (it only checks them for x86).
check_headers = [
    'alloca.h',
    'arpa/inet.h',
    'arpa/nameser.h',
    'build/defs.h',
    'cli0cli.h',
    'cli0core.h',
    'cli0defs.h',
    'cli0env.h',
    'cli0ext.h',
    'commoncrypto/commonrandom.h',
    'crypt.h',
    'dirent.h',
    'dlfcn.h',
    'dns.h',
    'fcntl.h',
    'grp.h',
    'ieeefp.h',
    'iconv.h',
    'inttypes.h',
    'iodbc.h',
    'io.h',
    'isqlext.h',
    'isql.h',
    'langinfo.h',
    'libproc.h',
    'librarymanager.h',
    'linux/filter.h',
    'linux/if_ether.h',
    'linux/if_packet.h',
    'linux/sock_diag.h',
    'linux/udp.h',
    'minix/config.h',
    'netinet/in.h',
    'net/if.h',
    'odbc.h',
    'poll.h',
    'pty.h',
    'pwd.h',
    'resolv.h',
    'sqlcli1.h',
    'sqlext.h',
    'sqltypes.h',
    'sqlucode.h',
    'sqlunix.h',
    'sql.h',
    'stdint.h',
    'stdio.h',
    'stdlib.h',
    'strings.h',
    'string.h',
    'sysexits.h',
    'syslog.h',
    'sys/acl.h',
    'sys/file.h',
    'sys/ioctl.h',
    'sys/ipc.h',
    'sys/loadavg.h',
    'sys/mman.h',
    'sys/mount.h',
    'sys/param.h',
    'sys/poll.h',
    'sys/pstat.h',
    'sys/resource.h',
    'sys/select.h',
    'sys/socket.h',
    'sys/sockio.h',
    'sys/statfs.h',
    'sys/statvfs.h',
    'sys/stat.h',
    'sys/sysexits.h',
    'sys/sysmacros.h',
    'sys/time.h',
    'sys/types.h',
    'sys/uio.h',
    'sys/utsname.h',
    'sys/vfs.h',
    'sys/wait.h',
    'tidybuffio.h',
    'tidyp.h',
    'tidy.h',
    'timelib/config.h',
    'udbcext.h',
    'unistd.h',
    'unix.h',
    'utime.h',
    'valgrind/cachegrind.h',
    'wchar.h',
]

foreach h : check_headers
    if cc.has_header(h, args : check_args)
        php_config_defs.set('HAVE_' + h.underscorify().to_upper(), 1)
    endif
endforeach

check_functions = [
    ['HAVE_ACCEPT4', 'accept4', '#include<sys/socket.h>'],
    ['HAVE_ALLOCA', 'alloca', '#include<alloca.h>'],
    ['HAVE_CHROOT', 'chroot', '#include<unistd.h>'],
    ['HAVE_CTERMID', 'ctermid', '#include<stdio.h>'],
    ['HAVE_CTIME_R', 'ctime_r', '#include<time.h>'],
    ['HAVE_FDATASYNC', 'fdatasync', '#include<unistd.h>'],
    ['HAVE_FLOCK', 'flock', '#include<sys/file.h>'],
    ['HAVE_FORK', 'fork', '#include<unistd.h>'],
    ['HAVE_FPATHCONF', 'fpathconf', '#include<unistd.h>'],
    ['HAVE_GAI_STRERROR', 'gai_strerror', '#include<netdb.h>'],
    ['HAVE_GETADDRINFO', 'getaddrinfo', '#include<netdb.h>'],
    ['HAVE_GETGRGID_R', 'getgrgid_r', '#include<grp.h>'],
    ['HAVE_GETGRNAM_R', 'getgrnam_r', '#include<grp.h>'],
    ['HAVE_GETGROUPS', 'getgroups', '#include<unistd.h>'],
    ['HAVE_GETHOSTBYNAME_R', 'gethostbyname_r', '#include<netdb.h>'],
    ['HAVE_GETLOADAVG', 'getloadavg', '#include<stdlib.h>'],
    ['HAVE_GETLOGIN', 'getlogin', '#include<unistd.h>'],
    ['HAVE_GETPGID', 'getpgid', '#include<unistd.h>'],
    ['HAVE_GETPID', 'getpid', '#include<unistd.h>'],
    ['HAVE_GETPRIORITY', 'getpriority', '#include<sys/resource.h>'],
    ['HAVE_GETPWNAM_R', 'getpwnam', '#include<pwd.h>'],
    ['HAVE_GETPWUID_R', 'getpwuid_r', '#include<pwd.h>'],
    ['HAVE_GETRANDOM', 'getrandom', '#include<sys/random.h>'],
    ['HAVE_GETSID', 'getsid', '#include<unistd.h>'],
    ['HAVE_GETTIMEOFDAY', 'gettimeofday', '#include<sys/time.h>'],
    ['HAVE_GETWD', 'getwd', '#include<unistd.h>'],
    ['HAVE_GMTIME_R', 'gmtime_r', '#include<time.h>'],
    ['HAVE_HSTRERROR', 'hstrerror', '#include<netdb.h>'],
    ['HAVE_IF_INDEXTONAME', 'if_indextoname', '#include<net/if.h>'],
    ['HAVE_IF_NAMETOINDEX', 'if_nametoindex', '#include<net/if.h>'],
    ['HAVE_INITGROUPS', 'initgroups', '#include<grp.h>'],
    ['HAVE_ISSETUGID', 'issetugid', '#include<unistd.h>'],
    ['HAVE_KILL', 'kill', '#include<signal.h>'],
    ['HAVE_KQUEUE', 'kqueue', '#include<sys/event.h>'],
    ['HAVE_LCHOWN', 'lchown', '#include<unistd.h>'],
    ['HAVE_MEMMEM', 'memmem', '#include<string.h>'],
    ['HAVE_MEMRCHR', 'memrchr', '#include<string.h>'],
    ['HAVE_MKFIFO', 'mkfifo', '#include<sys/stat.h>'],
    ['HAVE_MKNOD', 'mknod', '#include<sys/stat.h>'],
    ['HAVE_MMAP', 'mmap', '#include<sys/mman.h>'],
    ['HAVE_MPROTECT', 'mprotect', '#include<sys/mman.h>'],
    ['HAVE_NANOSLEEP', 'nanosleep', '#include<time.h>'],
    ['HAVE_NICE', 'nice', '#include<unistd.h>'],
    ['HAVE_OPENPTY', 'openpty', '#include<pty.h>'],
    ['HAVE_PATHCONF', 'pathconf', '#include<unistd.h>'],
    ['HAVE_POLL', 'poll', '#include<poll.h>'],
    ['HAVE_PREAD', 'pread', '#include<unistd.h>'],
    ['HAVE_PUTENV', 'putenv', '#include<stdlib.h>'],
    ['HAVE_PWRITE', 'pwrite', '#include<unistd.h>'],
    ['HAVE_SCHED_SETAFFINITY', 'sched_setaffinity', '#include<sched.h>'],
    ['HAVE_SELECT', 'select', '#include<sys/select.h>'],
    ['HAVE_SETEGID', 'setegid', '#include<unistd.h>'],
    ['HAVE_SETENV', 'setenv', '#include<stdlib.h>'],
    ['HAVE_SETEUID', 'seteuid', '#include<unistd.h>'],
    ['HAVE_SETITIMER', 'setitimer', '#include<sys/time.h>'],
    ['HAVE_SETPRIORITY', 'setpriority', '#include<sys/resource.h>'],
    ['HAVE_SETSID', 'setsid', '#include<unistd.h>'],
    ['HAVE_SIGACTION', 'sigaction', '#include<signal.h>'],
    ['HAVE_SIGTIMEDWAIT', 'sigtimedwait', '#include<signal.h>'],
    ['HAVE_SIGWAITINFO', 'sigwaitinfo', '#include<signal.h>'],
    ['HAVE_SOCKETPAIR', 'socketpair', '#include<sys/socket.h>'],
    ['HAVE_STATFS', 'statfs', '#include<sys/vfs.h>'],
    ['HAVE_STATVFS', 'statvfs', '#include<sys/statvfs.h>'],
    ['HAVE_STRCASECMP', 'strcasecmp', '#include<strings.h>'],
    ['HAVE_STRERROR_R', 'strerror_r', '#include<string.h>'],
    ['HAVE_STRLCAT', 'strlcat', '#include<string.h>'],
    ['HAVE_STRLCPY', 'strlcpy', '#include<string.h>'],
    ['HAVE_STRNDUP', 'strndup', '#include<string.h>'],
    ['HAVE_STRTOLL', 'strtoll', '#include<stdlib.h>'],
    ['HAVE_SYMLINK', 'symlink', '#include<unistd.h>'],
    ['HAVE_UNSETENV', 'unsetenv', '#include<stdlib.h>'],
    ['HAVE_USLEEP', 'usleep', '#include<unistd.h>'],
    ['HAVE_UTIMES', 'utimes', '#include<sys/time.h>'],
    ['HAVE_VASPRINTF', 'vasprintf', '#include<stdio.h>'],
    ['HAVE_WAIT3', 'wait3', '#include<sys/wait.h>'],
    ['HAVE_WAIT4', 'wait4', '#include<sys/wait.h>'],
    ['HAVE_WAITID', 'waitid', '#include<sys/wait.h>'],

    # check token ['HAVE_3ARG_SETREBINDPROC']
    # check token ['HAVE_AARCH64_CRC32']
    # check token ['HAVE_ALIGNOF']
    # check token ['HAVE_APPARMOR']
    # check token ['HAVE_ARGON2LIB']
    # check token ['HAVE_ASM_GOTO']
    # check token ['HAVE_ATTRIBUTE_ALIGNED']
    # check token ['HAVE_BCMATH']
    # check token ['HAVE_BIND_TEXTDOMAIN_CODESET']
    # check token ['HAVE_BROKEN_GETCWD']
    # check token ['HAVE_BUILTIN_ATOMIC']
    # check token ['HAVE_BUNDLED_PCRE']
    # check token ['HAVE_BZ2']
    # check token ['HAVE_CALENDAR']
    # check token ['HAVE_CANCEL_CALLBACK']
    # check token ['HAVE_CAPSTONE']
    # check token ['HAVE_CLOCK_GET_TIME']
    # check token ['HAVE_CODBC']
    # check token ['HAVE_CPUID_COUNT']
    # check token ['HAVE_CREATEPROCESS']
    # check token ['HAVE_CTYPE']
    # check token ['HAVE_CURL']
    # check token ['HAVE_DBA']
    # check token ['HAVE_DCNGETTEXT']
    # check token ['HAVE_DECL_PGRES_TUPLES_CHUNK']
    # check token ['HAVE_DECL_P_JAILID']
    # check token ['HAVE_DMALLOC']
    # check token ['HAVE_DNGETTEXT']
    # check token ['HAVE_DNS_SEARCH']
    # check token ['HAVE_DN_EXPAND']
    # check token ['HAVE_DN_SKIPNAME']
    # check token ['HAVE_DOM']
    # check token ['HAVE_DTRACE']
    # check token ['HAVE_ELF_AUX_INFO']
    # check token ['HAVE_ENCHANT']
    # check token ['HAVE_ENCHANT_BROKER_SET_PARAM']
    # check token ['HAVE_ENCHANT_GET_VERSION']
    # check token ['HAVE_ENCRYPTION']
    # check token ['HAVE_EPOLL']
    # check token ['HAVE_ERASE_EMPTY_LINE']
    # check token ['HAVE_EXIF']
    # check token ['HAVE_FFI']
    # check token ['HAVE_FFI_FASTCALL']
    # check token ['HAVE_FFI_MS_CDECL']
    # check token ['HAVE_FFI_PASCAL']
    # check token ['HAVE_FFI_REGISTER']
    # check token ['HAVE_FFI_STDCALL']
    # check token ['HAVE_FFI_SYSV']
    # check token ['HAVE_FFI_THISCALL']
    # check token ['HAVE_FLUSHIO']
    # check token ['HAVE_FNMATCH']
    # check token ['HAVE_FORKX']
    # check token ['HAVE_FPM_ACL']
    # check token ['HAVE_FPSETPREC']
    # check token ['HAVE_FPU_INLINE_ASM_X86']
    # check token ['HAVE_FTP']
    # check token ['HAVE_FTP_SSL']
    # check token ['HAVE_FUNC_ATTRIBUTE_IFUNC']
    # check token ['HAVE_FUNC_ATTRIBUTE_TARGET']
    # check token ['HAVE_FUNC_ATTRIBUTE_VISIBILITY']
    # check token ['HAVE_FUNC_GETHOSTBYNAME_R_3']
    # check token ['HAVE_FUNC_GETHOSTBYNAME_R_5']
    # check token ['HAVE_FUNC_GETHOSTBYNAME_R_6']
    # check token ['HAVE_FUNOPEN']
    # check token ['HAVE_GCC_GLOBAL_REGS']
    # check token ['HAVE_GCOV']
    # check token ['HAVE_GD_AVIF']
    # check token ['HAVE_GD_BUNDLED']
    # check token ['HAVE_GD_FREETYPE']
    # check token ['HAVE_GD_GET_INTERPOLATION']
    # check token ['HAVE_GD_JPG']
    # check token ['HAVE_GD_LIBVERSION']
    # check token ['HAVE_GD_PNG']
    # check token ['HAVE_GD_WEBP']
    # check token ['HAVE_GD_XPM']
    # check token ['HAVE_GETCPUID']
    # check token ['HAVE_GLIBC_ICONV']
    # check token ['HAVE_GMP']
    # check token ['HAVE_HISTORY_LIST']
    # check token ['HAVE_HUGE_CODE_PAGES']
    # check token ['HAVE_IBMDB2']
    # check token ['HAVE_IBM_ICONV']
    # check token ['HAVE_ICONV']
    # check token ['HAVE_IODBC']
    # check token ['HAVE_IPV6']
    # check token ['HAVE_JIT']
    # check token ['HAVE_LDAP']
    # check token ['HAVE_LDAP_CONTROL_FIND']
    # check token ['HAVE_LDAP_EXTENDED_OPERATION']
    # check token ['HAVE_LDAP_EXTENDED_OPERATION_S']
    # check token ['HAVE_LDAP_PARSE_EXTENDED_RESULT']
    # check token ['HAVE_LDAP_PARSE_REFERENCE']
    # check token ['HAVE_LDAP_PARSE_RESULT']
    # check token ['HAVE_LDAP_PASSWD']
    # check token ['HAVE_LDAP_REFRESH_S']
    # check token ['HAVE_LDAP_SASL']
    # check token ['HAVE_LDAP_START_TLS_S']
    # check token ['HAVE_LDAP_WHOAMI_S']
    # check token ['HAVE_LEXBOR']
    # check token ['HAVE_LIBATOMIC']
    # check token ['HAVE_LIBAVIF']
    # check token ['HAVE_LIBDL']
    # check token ['HAVE_LIBEDIT']
    # check token ['HAVE_LIBEXPAT']
    # check token ['HAVE_LIBFREETYPE']
    # check token ['HAVE_LIBGD']
    # check token ['HAVE_LIBICONV']
    # check token ['HAVE_LIBINTL']
    # check token ['HAVE_LIBJPEG']
    # check token ['HAVE_LIBMM']
    # check token ['HAVE_LIBPNG']
    # check token ['HAVE_LIBREADLINE']
    # check token ['HAVE_LIBRESOLV']
    # check token ['HAVE_LIBSOCKET']
    # check token ['HAVE_LIBSODIUMLIB']
    # check token ['HAVE_LIBWEBP']
    # check token ['HAVE_LIBXML']
    # check token ['HAVE_LIBZIP_VERSION']
    # check token ['HAVE_LONG_DOUBLE']
    # check token ['HAVE_LQ_SO_LISTENQ']
    # check token ['HAVE_LQ_TCP_CONNECTION_INFO']
    # check token ['HAVE_LQ_TCP_INFO']
    # check token ['HAVE_MACH_VM_READ']
    # check token ['HAVE_MBREGEX']
    # check token ['HAVE_MBSTRING']
    # check token ['HAVE_MEMCNTL']
    # check token ['HAVE_MEMSET_EXPLICIT']
    # check token ['HAVE_METHOD_SUPPORTED']
    # check token ['HAVE_NGETTEXT']
    # check token ['HAVE_OPENSSL_ARGON2']
    # check token ['HAVE_OPENSSL_EXT']
    # check token ['HAVE_ORALDAP']
    # check token ['HAVE_PCRE_JIT_SUPPORT']
    # check token ['HAVE_PCRE_VALGRIND_SUPPORT']
    # check token ['HAVE_PDO_PGSQL']
    # check token ['HAVE_PGSQL']
    # check token ['HAVE_PG_CHANGE_PASSWORD']
    # check token ['HAVE_PG_CLOSE_STMT']
    # check token ['HAVE_PG_RESULT_MEMORY_SIZE']
    # check token ['HAVE_PG_SERVICE']
    # check token ['HAVE_PG_SET_CHUNKED_ROWS_SIZE']
    # check token ['HAVE_PG_SOCKET_POLL']
    # check token ['HAVE_PHPDBG_READLINE']
    # check token ['HAVE_PHP_SESSION']
    # check token ['HAVE_PORT_CREATE']
    # check token ['HAVE_POSIX']
    # check token ['HAVE_PQCLOSEPREPARED']
    # check token ['HAVE_PQERRORS_SQLSTATE']
    # check token ['HAVE_PRESERVE_NONE']
    # check token ['HAVE_PROCCTL']
    # check token ['HAVE_PROGRESS_CALLBACK']
    # check token ['HAVE_PSET_BIND']
    # check token ['HAVE_PS_STRINGS']
    # check token ['HAVE_PTHREAD_GET_STACKADDR_NP']
    # check token ['HAVE_PTHREAD_JIT_WRITE_PROTECT_NP']
    # check token ['HAVE_PTHREAD_SET_QOS_CLASS_SELF_NP']
    # check token ['HAVE_PTHREAD_STACKSEG_NP']
    # check token ['HAVE_RAND_EGD']
    # check token ['HAVE_RFORK']
    # check token ['HAVE_RL_CALLBACK_READ_CHAR']
    # check token ['HAVE_RL_COMPLETION_MATCHES']
    # check token ['HAVE_RL_ON_NEW_LINE']
    # check token ['HAVE_SCHED_GETCPU']
    # check token ['HAVE_SELINUX']
    # check token ['HAVE_SETPFLAGS']
    # check token ['HAVE_SHMOP']
    # check token ['HAVE_SHM_IPC']
    # check token ['HAVE_SHM_MMAP_ANON']
    # check token ['HAVE_SHM_MMAP_POSIX']
    # check token ['HAVE_SHUTDOWN_SNMP_LOGGING']
    # check token ['HAVE_SIMPLEXML']
    # check token ['HAVE_SLOW_HASH3']
    # check token ['HAVE_SNMP']
    # check token ['HAVE_SNMP_SHA256']
    # check token ['HAVE_SNMP_SHA512']
    # check token ['HAVE_SOAP']
    # check token ['HAVE_SOCKETS']
    # check token ['HAVE_SOCKLEN_T']
    # check token ['HAVE_SQLITE3']
    # check token ['HAVE_SQLITE3_COLUMN_TABLE_NAME']
    # check token ['HAVE_SQLITE3_EXPANDED_SQL']
    # check token ['HAVE_STD_SYSLOG']
    # check token ['HAVE_STRCASESTR']
    # check token ['HAVE_STRUCT_CMSGCRED']
    # check token ['HAVE_STRUCT_FLOCK']
    # check token ['HAVE_STRUCT_SOCKADDR_SA_LEN']
    # check token ['HAVE_STRUCT_SOCKADDR_STORAGE']
    # check token ['HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY']
    # check token ['HAVE_STRUCT_SOCKADDR_UN_SUN_LEN']
    # check token ['HAVE_STRUCT_STAT_ST_BLKSIZE']
    # check token ['HAVE_STRUCT_STAT_ST_BLOCKS']
    # check token ['HAVE_STRUCT_STAT_ST_RDEV']
    # check token ['HAVE_STRUCT_TM_TM_GMTOFF']
    # check token ['HAVE_STRUCT_TM_TM_ZONE']
    # check token ['HAVE_STRUCT_UCRED']
    # check token ['HAVE_STRUCT_UTSNAME_DOMAINNAME']
    # check token ['HAVE_SYSTEMD']
    # check token ['HAVE_SYSVMSG']
    # check token ['HAVE_SYSVSEM']
    # check token ['HAVE_SYSVSHM']
    # check token ['HAVE_TIDY']
    # check token ['HAVE_TIDYOPTGETCATEGORY']
    # check token ['HAVE_TIDYOPTGETDOC']
    # check token ['HAVE_TIDYRELEASEDATE']
    # check token ['HAVE_TM_ZONE']
    # check token ['HAVE_TTYNAME_R']
    # check token ['HAVE_UNION_SEMUN']
    # check token ['HAVE_UNIXODBC']
    # check token ['HAVE_UODBC']
    # check token ['HAVE_USERFAULTFD_WRITEFAULT']
    # check token ['HAVE_VALGRIND']
    # check token ['HAVE_WAIT6']
    # check token ['HAVE_WIFCONTINUED']
    # check token ['HAVE_XML']
    # check token ['HAVE_XMLREADER']
    # check token ['HAVE_XMLWRITER']
    # check token ['HAVE_XPM']
    # check token ['HAVE_XSL']
    # check token ['HAVE_XSL_EXSLT']
    # check token ['HAVE_ZIP']
    # check token ['HAVE_ZLIB']
    # check token ['HAVE__CONTROLFP']
    # check token ['HAVE__CONTROLFP_S']
    # check token ['HAVE__FPU_SETCW']
    # check token ['HAVE___ATOMIC_EXCHANGE_1']

    # added by the meson port
    ['HAVE_SCHED_GETCPU', 'sched_getcpu', '#include<sched.h>'],
    ['HAVE_TTYNAME_R', 'ttyname_r', '#include<unistd.h>'],
    ['HAVE_FNMATCH', 'fnmatch', '#include<fnmatch.h>'],
    ['HAVE_MEMSET_EXPLICIT', 'memset_explicit', '#include<string.h>'],
    ['HAVE_DN_EXPAND', 'dn_expand', '#include<resolv.h>'],
    ['HAVE_DN_SKIPNAME', 'dn_skipname', '#include<resolv.h>'],
    ['HAVE_EPOLL_CREATE1', 'epoll_create1', '#include<sys/epoll.h>'],
    ['HAVE_ALPHASORT', 'alphasort', '#include<dirent.h>'],
    ['HAVE_ARC4RANDOM_BUF', 'arc4random_buf', '#include<stdlib.h>'],
    ['HAVE_ASCTIME_R', 'asctime_r', '#include<time.h>'],
    ['HAVE_ASPRINTF', 'asprintf', '#include<stdio.h>'],
    ['HAVE_ATOLL', 'atoll', '#include<stdlib.h>'],
    ['HAVE_COPY_FILE_RANGE', 'copy_file_range', '#include<unistd.h>'],
    ['HAVE_CRYPT', 'crypt', '#include<crypt.h>'],
    ['HAVE_CRYPT_R', 'crypt_r', '#include<crypt.h>'],
    ['HAVE_EACCESS', 'eaccess', '#include<unistd.h>'],
    ['HAVE_EPOLL_PWAIT2', 'epoll_pwait2', '#include<sys/epoll.h>'],
    ['HAVE_EXPLICIT_BZERO', 'explicit_bzero', '#include<string.h>'],
    ['HAVE_EXPLICIT_MEMSET', 'explicit_memset', '#include<string.h>'],
    ['HAVE_FOPENCOOKIE', 'fopencookie', '#include<stdio.h>'],
    ['HAVE_FTOK', 'ftok', '#include<sys/ipc.h>'],
    ['HAVE_GETCWD', 'getcwd', '#include<unistd.h>'],
    ['HAVE_GETHOSTNAME', 'gethostname', '#include<unistd.h>'],
    ['HAVE_GETIFADDRS', 'getifaddrs', '#include<ifaddrs.h>'],
    ['HAVE_GETOPT', 'getopt', '#include<unistd.h>'],
    ['HAVE_GETPROTOBYNAME', 'getprotobyname', '#include<netdb.h>'],
    ['HAVE_GETPROTOBYNUMBER', 'getprotobynumber', '#include<netdb.h>'],
    ['HAVE_GETRLIMIT', 'getrlimit', '#include<sys/resource.h>'],
    ['HAVE_GETRUSAGE', 'getrusage', '#include<sys/resource.h>'],
    ['HAVE_GETSERVBYNAME', 'getservbyname', '#include<netdb.h>'],
    ['HAVE_GETSERVBYPORT', 'getservbyport', '#include<netdb.h>'],
    ['HAVE_GETTID', 'gettid', '#include<unistd.h>'],
    ['HAVE_GLOB', 'glob', '#include<glob.h>'],
    ['HAVE_LOCALTIME_R', 'localtime_r', '#include<time.h>'],
    ['HAVE_MEMFD_CREATE', 'memfd_create', '#include<sys/mman.h>'],
    ['HAVE_MEMPCPY', 'mempcpy', '#include<string.h>'],
    ['HAVE_MKSTEMP', 'mkstemp', '#include<stdlib.h>'],
    ['HAVE_MREMAP', 'mremap', '#include<sys/mman.h>'],
    ['HAVE_NL_LANGINFO', 'nl_langinfo', '#include<langinfo.h>'],
    ['HAVE_POSIX_SPAWN_FILE_ACTIONS_ADDCHDIR_NP', 'posix_spawn_file_actions_addchdir_np', '#include<spawn.h>'],
    ['HAVE_PRCTL', 'prctl', '#include<sys/prctl.h>'],
    ['HAVE_PTHREAD_ATTR_GET_NP', 'pthread_attr_get_np', '#include<pthread.h>'],
    ['HAVE_PTHREAD_ATTR_GETSTACK', 'pthread_attr_getstack', '#include<pthread.h>'],
    ['HAVE_PTHREAD_GETATTR_NP', 'pthread_getattr_np', '#include<pthread.h>'],
    ['HAVE_REALLOCARRAY', 'reallocarray', '#include<stdlib.h>'],
    ['HAVE_RES_NDESTROY', 'res_ndestroy', '#include<resolv.h>'],
    ['HAVE_RES_NSEARCH', 'res_nsearch', '#include<resolv.h>'],
    ['HAVE_RES_SEARCH', 'res_search', '#include<resolv.h>'],
    ['HAVE_SCANDIR', 'scandir', '#include<dirent.h>'],
    ['HAVE_SENDFILE', 'sendfile', '#include<sys/sendfile.h>'],
    ['HAVE_SETPROCTITLE', 'setproctitle', '#include<stdlib.h>'],
    ['HAVE_SETPROCTITLE_FAST', 'setproctitle_fast', '#include<stdlib.h>'],
    ['HAVE_SETRLIMIT', 'setrlimit', '#include<sys/resource.h>'],
    ['HAVE_SHM_CREATE_LARGEPAGE', 'shm_create_largepage', '#include<sys/shm.h>'],
    ['HAVE_SHUTDOWN', 'shutdown', '#include<sys/socket.h>'],
    ['HAVE_SIGPROCMASK', 'sigprocmask', '#include<signal.h>'],
    ['HAVE_SOCKATMARK', 'sockatmark', '#include<sys/socket.h>'],
    ['HAVE_SPLICE', 'splice', '#include<fcntl.h>'],
    ['HAVE_STRNLEN', 'strnlen', '#include<string.h>'],
    ['HAVE_STRPTIME', 'strptime', '#include<time.h>'],
    ['HAVE_STRTOK_R', 'strtok_r', '#include<string.h>'],
    ['HAVE_SYSCALL', 'syscall', '#include<unistd.h>'],
    ['HAVE_TZSET', 'tzset', '#include<time.h>'],
    ['HAVE_UNSHARE', 'unshare', '#include<sched.h>'],
    ['HAVE_UTIME', 'utime', '#include<utime.h>'],
]

foreach f : check_functions
    if cc.has_function(f.get(1), prefix : f.get(2), args : check_args)
        php_config_defs.set(f.get(0), 1)
    endif
endforeach

php_config_defs.set('SIZEOF_INT', cc.sizeof('int'))
php_config_defs.set('SIZEOF_LONG', cc.sizeof('long'))
php_config_defs.set('SIZEOF_LONG_LONG', cc.sizeof('long long'))
php_config_defs.set('SIZEOF_OFF_T', cc.sizeof('off_t', prefix : '#include<sys/types.h>'))
php_config_defs.set('SIZEOF_SIZE_T', cc.sizeof('size_t'))

# Adjudicate before the switch: meson's checks find clearenv, clock_gettime,
# ptrace, times, tzname and the tzname declaration, while autoconf left all six
# undefined in the configuration punk has always been built with.  PHP changes
# behaviour when they are defined (hrtime switches to clock_gettime), so they are
# left out until someone decides which answer is right rather than silently
# changing how punk behaves.
#
# The FPM section at the end of this file revisits the three whose only consumer
# is sapi/fpm -- clearenv, ptrace and times -- because building FPM asks questions
# the reference configuration never asked, and one of them (clearenv) does not
# even compile when left to the fallback.  clock_gettime stays out: it is engine
# behaviour, and nothing else here reads it.  HAVE_TZNAME and HAVE_DECL_TZNAME
# stay out too -- nothing in the tree reads either.

# Declarations have to be defined to 0 when absent -- leaving them undefined is
# not the same as "not declared" for the code that uses these.
php_config_defs.set10('HAVE_DECL_STRERROR_R', cc.has_header_symbol('string.h', 'strerror_r', args : check_args))
if cc.has_header_symbol('time.h', 'strptime', args : check_args)
    php_config_defs.set('HAVE_DECL_STRPTIME', 1)
endif
if cc.has_header_symbol('sys/wait.h', 'WCONTINUED', args : check_args)
    php_config_defs.set('HAVE_DECL_WCONTINUED', 1)
endif
php_config_defs.set10('HAVE_DECL_WEXITED', cc.has_header_symbol('sys/wait.h', 'WEXITED', args : check_args))
php_config_defs.set10('HAVE_DECL_WNOWAIT', cc.has_header_symbol('sys/wait.h', 'WNOWAIT', args : check_args))
php_config_defs.set10('HAVE_DECL_WSTOPPED', cc.has_header_symbol('sys/wait.h', 'WSTOPPED', args : check_args))
php_config_defs.set10('HAVE_DECL_P_ALL', cc.has_header_symbol('sys/wait.h', 'P_ALL', args : check_args))
php_config_defs.set10('HAVE_DECL_P_PIDFD', cc.has_header_symbol('sys/wait.h', 'P_PIDFD', args : check_args))
php_config_defs.set10('HAVE_DECL_P_UID', cc.has_header_symbol('sys/wait.h', 'P_UID', args : check_args))
if cc.has_header_symbol('sys/syscall.h', 'SYS_pidfd_open', args : check_args)
    php_config_defs.set('HAVE_DECL_SYS_PIDFD_OPEN', 1)
endif
if cc.has_header_symbol('sys/syscall.h', 'SYS_waitid', args : check_args)
    php_config_defs.set('HAVE_DECL_SYS_WAITID', 1)
endif

# iconv is an implementation detail rather than a library, so it is probed here
# and again per-extension (see ext/iconv/meson.build).
if cc.has_header_symbol('iconv.h', 'iconv_t', args : check_args)
    php_config_defs.set('HAVE_ICONV_T_DEF', 1)
endif

check_types = [
    ['HAVE_LONG_DOUBLE', 'long double', ''],
    ['HAVE_SOCKLEN_T', 'socklen_t', '#include<sys/socket.h>'],
    ['HAVE_STRUCT_FLOCK', 'struct flock', '#include<sys/file.h>'],
    ['HAVE_STRUCT_SOCKADDR_STORAGE', 'struct sockaddr_storage', '#include<sys/socket.h>'],
    ['HAVE_STRUCT_UCRED', 'struct ucred', '#include<sys/socket.h>'],
    ['HAVE_UNION_SEMUN', 'union semun', '#include<sys/sem.h>'],
]

foreach t : check_types
    if cc.has_type(t.get(1), prefix : t.get(2), args : check_args)
        php_config_defs.set(t.get(0), 1)
    endif
endforeach

# Checks that only exist for other POSIX systems are dropped while punk is
# Linux-only.  They are listed here so they can be restored from git history
# when those platforms come back:
#   headers:      sys/ucred.h, sys/sysctl.h, sys/loadavg.h, ieeefp.h, ...
#   functions:    mach_vm_read, memcntl, procctl, pset_bind, rfork,
#                 setpflags, elf_aux_info, clock_get_time, getcpuid, forkx,
#                 funopen, wait6, wifcontinued, pthread_getthrds_np,
#                 pthread_get_stackaddr_np, pthread_jit_write_protect_np,
#                 pthread_set_qos_class_self_np, pthread_stackseg_np
#   types:        struct cmsgcred
#   declarations: P_JAILID, clock_gettime_nsec_np
#   libraries:    -lmach, -lproc, -lmemcntl (Solaris), -lkvm
# Runtime checks (AC_RUN_IFELSE) for those systems can go the same way.
#
# The following are not platform checks at all and belong to the extension or
# compiler layer, so they are intentionally absent here:
#   ldap_*            -> ext/ldap (ldap.h, dependency('ldap'))
#   d[c]ngettext      -> ext/gettext (libintl.h)
#   __gmpz_*          -> ext/gmp (gmp.h, dependency('gmp'))
#   HAVE_LIBICONV     -> ext/iconv (find_library)
#   __atomic_exchange_1, __alignof__, __attribute__((aligned)) -> compiler
#                       capability checks, cc.compiles/has_function_attribute
#   HAVE_MEMFD_CREATE is set in the root meson.build today; it belongs here.

# ---- extensions -----------------------------------------------------------
# The defines each extension contributes when it is built in, which is the
# meson-side counterpart of the per-extension AC_DEFINEs.  Library and
# behaviour probes that depend on what a library actually provides (gd's image
# formats, pgsql's HAVE_PG_*, snmp's SHA-256 support, tidy's TidyOptGet*, ...)
# are deliberately absent: they belong with the dependency checks phase 3 adds.
# Extensions that are linked into the binaries must not define COMPILE_DL_<name>
# either -- that define means "loadable module", and it is what the ZEND_GET_MODULE
# block in each extension keys off.
extension_defines = {
    'bcmath': ['HAVE_BCMATH'],
    'bz2': ['HAVE_BZ2'],
    'calendar': ['HAVE_CALENDAR'],
    'ctype': ['HAVE_CTYPE'],
    'curl': ['HAVE_CURL'],
    'date': ['HAVE_DATE', 'HAVE_TIMELIB_CONFIG_H'],
    'dba': ['HAVE_DBA', 'HAVE_DBA', 'DBA_CDB', 'DBA_CDB_BUILTIN', 'DBA_FLATFILE', 'DBA_INIFILE'],
    'dl_test': ['HAVE_DL_TEST'],
    'dom': ['HAVE_DOM'],
    'enchant': ['HAVE_ENCHANT', 'HAVE_ENCHANT', 'HAVE_ENCHANT_GET_VERSION'],
    'exif': ['HAVE_EXIF'],
    'ffi': ['HAVE_FFI'],
    'fileinfo': ['HAVE_FILEINFO'],
    'filter': ['HAVE_FILTER'],
    'ftp': ['HAVE_FTP', 'HAVE_FTP', 'HAVE_FTP_SSL'],
    'gd': ['HAVE_GD', 'HAVE_GD_BUNDLED'],
    'gettext': ['HAVE_GETTEXT', 'HAVE_LIBINTL', 'HAVE_BIND_TEXTDOMAIN_CODESET', 'HAVE_NGETTEXT', 'HAVE_DNGETTEXT', 'HAVE_DCNGETTEXT'],
    'gmp': ['HAVE_GMP'],
    'hash': ['HAVE_HASH'],
    'iconv': ['HAVE_ICONV'],
    'intl': ['HAVE_INTL'],
    'json': ['HAVE_JSON'],
    'ldap': ['HAVE_LDAP', 'HAVE_LDAP', 'HAVE_LDAP_SASL'],
    'lexbor': ['HAVE_LEXBOR'],
    'libxml': ['HAVE_LIBXML'],
    'mbstring': ['HAVE_MBSTRING', 'HAVE_MBSTRING', 'HAVE_MBREGEX'],
    'mysqli': ['HAVE_MYSQLI'],
    'mysqlnd': ['HAVE_MYSQLND'],
    'opcache': ['HAVE_OPCACHE'],
    'openssl': ['HAVE_OPENSSL', 'HAVE_OPENSSL_EXT'],
    'pcntl': ['HAVE_PCNTL'],
    'pcre': ['HAVE_PCRE'],
    'pdo': ['HAVE_PDO'],
    'pdo_firebird': ['HAVE_PDO_FIREBIRD'],
    'pdo_mysql': ['HAVE_PDO_MYSQL', 'PDO_USE_MYSQLND'],
    'pdo_pgsql': ['HAVE_PDO_PGSQL', 'HAVE_PDO_PGSQL'],
    'pdo_sqlite': ['HAVE_PDO_SQLITE'],
    'pgsql': ['HAVE_PGSQL', 'HAVE_PGSQL'],
    'phar': ['HAVE_PHAR'],
    'posix': ['HAVE_POSIX'],
    'random': ['HAVE_RANDOM'],
    'readline': ['HAVE_READLINE', 'HAVE_LIBEDIT'],
    'reflection': ['HAVE_REFLECTION'],
    'session': ['HAVE_SESSION', 'HAVE_PHP_SESSION'],
    'shmop': ['HAVE_SHMOP'],
    'simplexml': ['HAVE_SIMPLEXML'],
    'snmp': ['HAVE_SNMP'],
    'soap': ['HAVE_SOAP'],
    'sockets': ['HAVE_SOCKETS'],
    'sodium': ['HAVE_SODIUM'],
    'spl': ['HAVE_SPL'],
    'sqlite3': ['HAVE_SQLITE3'],
    'standard': ['HAVE_STANDARD', 'HAVE_ARGON2LIB'],
    'sysvmsg': ['HAVE_SYSVMSG'],
    'sysvsem': ['HAVE_SYSVSEM'],
    'sysvshm': ['HAVE_SYSVSHM'],
    'tidy': ['HAVE_TIDY'],
    'tokenizer': ['HAVE_TOKENIZER'],
    'uri': ['HAVE_URI', 'URI_ENABLE_ANSI', 'URI_NO_UNICODE'],
    'xml': ['HAVE_XML'],
    'xmlreader': ['HAVE_XMLREADER'],
    'xmlwriter': ['HAVE_XMLWRITER'],
    'xsl': ['HAVE_XSL', 'HAVE_XSL', 'HAVE_XSL_EXSLT'],
    'zend_test': ['HAVE_ZEND_TEST'],
    'zip': ['HAVE_ZIP'],
    'zlib': ['HAVE_ZLIB'],
}

foreach name, defines : extension_defines
    foreach define : defines
        php_config_defs.set(define, 1)
    endforeach
endforeach

# COMPILE_DL_<name> for everything that becomes a loadable module.  Today that is
# "everything not listed in cli_static_extensions in the root meson.build"; once
# the extension options exist it will follow from those.
foreach name : extension_defines.keys()
    if not cli_static_extensions.contains(name)
        php_config_defs.set('COMPILE_DL_' + name.to_upper(), 1)
    endif
endforeach

# ---- build variants -------------------------------------------------------
# Defaults reproduce the configuration punk has always been built with:
# debug + ZTS, sigchild, ucontext fibers, no JIT, no max-execution-timers.
if get_option('zts')
    php_config_defs.set('ZTS', 1)
endif
if get_option('zend-debug')
    php_config_defs.set('ZEND_DEBUG', 1)
endif
if get_option('sigchild')
    php_config_defs.set('PHP_SIGCHILD', 1)
endif
if not get_option('fiber-asm')
    php_config_defs.set('ZEND_FIBER_UCONTEXT', 1)
    if host_machine.system() == 'darwin'
        # macOS exposes getcontext/makecontext/swapcontext in ucontext.h only
        # behind _XOPEN_SOURCE (configure.ac's fiber_os == 'mac' branch).
        php_config_defs.set('_XOPEN_SOURCE', 1)
    endif
endif
# Zend/Zend.m4 defines these by default: signals when sigaction exists, and the
# stack limit check unless --disable-zend-check-stack-limit is given.
php_config_defs.set('ZEND_SIGNALS', 1)
php_config_defs.set('ZEND_CHECK_STACK_LIMIT', 1)

# ---- build information ----------------------------------------------------
uname = run_command('uname', '-a', check : false)
if uname.returncode() == 0
    # Same as autoconf: the *build* machine's uname, so it reports the build host
    # when cross-compiling.
    php_config_defs.set_quoted('PHP_UNAME', uname.stdout().strip())
    php_config_defs.set_quoted('PHP_BUILD_SYSTEM', uname.stdout().strip())
endif
# autoconf reports the OS with a capital letter ("Linux"), and tests compare
# php_uname()/PHP_OS against that spelling.
if host_machine.system() == 'linux'
    php_config_defs.set_quoted('PHP_OS', 'Linux')
else
    php_config_defs.set_quoted('PHP_OS', host_machine.system())
endif
php_config_defs.set('HAVE_BUILD_DEFS_H', 1)
php_config_defs.set_quoted('DEFAULT_SHORT_OPEN_TAG', '1')

# Struct details.  These are what the C library actually exposes rather than
# separate functions, so they are member/symbol probes.
if cc.has_member('struct tm', 'tm_zone', prefix : '#include<time.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_TM_TM_ZONE', 1)
endif
php_config_defs.set10('HAVE_TM_ZONE', cc.has_member('struct tm', 'tm_zone', prefix : '#include<time.h>', args : check_args))
if cc.has_member('struct tm', 'tm_gmtoff', prefix : '#include<time.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_TM_TM_GMTOFF', 1)
endif
if cc.has_member('struct stat', 'st_blksize', prefix : '#include<sys/stat.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_STAT_ST_BLKSIZE', 1)
endif
if cc.has_member('struct stat', 'st_blocks', prefix : '#include<sys/stat.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_STAT_ST_BLOCKS', 1)
endif
if cc.has_member('struct stat', 'st_rdev', prefix : '#include<sys/stat.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_STAT_ST_RDEV', 1)
endif
if cc.has_member('struct sockaddr_storage', 'ss_family', prefix : '#include<sys/socket.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY', 1)
endif
if cc.has_member('struct utsname', 'domainname', prefix : '#include<sys/utsname.h>', args : check_args)
    php_config_defs.set('HAVE_STRUCT_UTSNAME_DOMAINNAME', 1)
endif
# These two are checked with #ifdef/#ifndef rather than #if, so they must stay
# undefined when absent (a `#define ... 0` would still satisfy `defined()`).
if cc.has_member('struct winsize', 'ws_row', prefix : '#include<sys/ioctl.h>', args : check_args)
    php_config_defs.set('GWINSZ_IN_SYS_IOCTL', 1)
endif
if cc.has_header_symbol('sys/sysmacros.h', 'major', args : check_args)
    php_config_defs.set('MAJOR_IN_SYSMACROS', 1)
endif
php_config_defs.set10('HAVE_DECL_WIFCONTINUED', cc.has_header_symbol('sys/wait.h', 'WIFCONTINUED', args : check_args))

# IPv6 support: what PHP means by HAVE_IPV6 is that the resolver can talk AF_INET6.
if cc.has_header_symbol('netinet/in.h', 'AF_INET6', args : check_args)
    php_config_defs.set('HAVE_IPV6', 1)
endif

# Compiler builtins (php.m4's PHP_CHECK_BUILTIN_*).  Each is compiled rather
# than linked, and a builtin that a target does not implement simply stays
# undefined: __builtin_cpu_supports, for instance, is x86-only.
check_builtins = [
    ['PHP_HAVE_BUILTIN_CLZ', 'int main(void) { return __builtin_clz(1u); }'],
    ['PHP_HAVE_BUILTIN_CLZL', 'int main(void) { return (int) __builtin_clzl(1ul); }'],
    ['PHP_HAVE_BUILTIN_CLZLL', 'int main(void) { return (int) __builtin_clzll(1ull); }'],
    ['PHP_HAVE_BUILTIN_CTZL', 'int main(void) { return (int) __builtin_ctzl(1ul); }'],
    ['PHP_HAVE_BUILTIN_CTZLL', 'int main(void) { return (int) __builtin_ctzll(1ull); }'],
    ['PHP_HAVE_BUILTIN_EXPECT', 'int main(void) { return __builtin_expect(1, 1); }'],
    ['PHP_HAVE_BUILTIN_UNREACHABLE', 'int main(void) { __builtin_unreachable(); }'],
    ['PHP_HAVE_BUILTIN_FRAME_ADDRESS', 'int main(void) { return __builtin_frame_address(0) != 0; }'],
    ['PHP_HAVE_BUILTIN_SADDL_OVERFLOW', 'int main(void) { int r; return __builtin_saddl_overflow(1, 1, &r); }'],
    ['PHP_HAVE_BUILTIN_SADDLL_OVERFLOW', 'int main(void) { long long r; return __builtin_saddll_overflow(1, 1, &r); }'],
    ['PHP_HAVE_BUILTIN_SMULL_OVERFLOW', 'int main(void) { long r; return __builtin_smull_overflow(1, 1, &r); }'],
    ['PHP_HAVE_BUILTIN_SMULLL_OVERFLOW', 'int main(void) { long long r; return __builtin_smull_overflow(1, 1, (long long *) &r); }'],
    ['PHP_HAVE_BUILTIN_SSUBL_OVERFLOW', 'int main(void) { int r; return __builtin_ssubl_overflow(1, 1, &r); }'],
    ['PHP_HAVE_BUILTIN_SSUBLL_OVERFLOW', 'int main(void) { long long r; return __builtin_ssubll_overflow(1, 1, &r); }'],
    ['PHP_HAVE_BUILTIN_USUB_OVERFLOW', 'int main(void) { unsigned int r; return __builtin_usub_overflow(1u, 1u, &r); }'],
    ['PHP_HAVE_BUILTIN_CPU_SUPPORTS', 'int main(void) { return __builtin_cpu_supports("sse2"); }'],
]

foreach b : check_builtins
    if cc.compiles(b.get(1), args : check_args, name : b.get(0))
        php_config_defs.set(b.get(0), 1)
    endif
endforeach

# The standard extension turns chroot() and fnmatch() into feature defines of
# their own, and date needs to know its config header is there.
if php_config_defs.has('HAVE_CHROOT')
    php_config_defs.set('ENABLE_CHROOT_FUNC', 1)
endif
if php_config_defs.has('HAVE_FNMATCH')
    php_config_defs.set('HAVE_FNMATCH', 1)
endif

# ---- libraries ------------------------------------------------------------
net_snmp_prefix = '#include<net-snmp/net-snmp-config.h>\n#include<net-snmp/net-snmp-includes.h>'

# What config.m4 probed with pkg-config or PHP_CHECK_LIBRARY, expressed as meson
# dependencies.  These are the same libraries the extension targets link (meson
# caches the lookups), and a missing one is a configuration error rather than a
# silently disabled feature.
dep_libpq = dependency('libpq')
dep_ldap = dependency('ldap')
dep_lber = dependency('lber')
dep_netsnmp = dependency('netsnmp')
dep_tidy = dependency('tidy')
dep_libedit = dependency('libedit')
dep_libzip = dependency('libzip')
dep_openssl = dependency('openssl')
dep_libpcre2 = dependency('libpcre2-8')
dep_libgmp = dependency('gmp')
dep_sqlite3 = dependency('sqlite3')
dep_libargon2 = dependency('libargon2')
dep_zlib = dependency('zlib')
dep_libffi = dependency('libffi')
dep_oniguruma = dependency('oniguruma')
dep_freetype = dependency('freetype2')
dep_libpng = dependency('libpng')
dep_libjpeg = dependency('libjpeg')
dep_libwebp = dependency('libwebp')
dep_libavif = dependency('libavif')
dep_xpm = dependency('xpm')

# tidy's pkg-config file does not carry its include dir (see ext/tidy/meson.build).
tidy_include_args = []
if run_command('sh', '-c', '[ -d /usr/include/tidy ]', check : false).returncode() == 0
    tidy_include_args = ['-I/usr/include/tidy']
endif

# Functions that only exist in a newer version of a library: the define is what
# PHP uses to decide whether to call them.
library_symbols = [
    # PostgreSQL (PHP_CHECK_LIBRARY in ext/pgsql/config.m4)
    ['HAVE_PG_RESULT_MEMORY_SIZE', 'PQresultMemorySize', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PG_CHANGE_PASSWORD', 'PQchangePassword', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PG_SOCKET_POLL', 'PQsocketPoll', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PG_CLOSE_STMT', 'PQclosePrepared', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PQCLOSEPREPARED', 'PQclosePrepared', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PQCLOSEPORTAL', 'PQclosePortal', '#include<libpq-fe.h>', [dep_libpq]],
    ['HAVE_PG_SET_CHUNKED_ROWS_SIZE', 'PQsetChunkedRowsMode', '#include<libpq-fe.h>', [dep_libpq]],
    # OpenLDAP
    ['HAVE_LDAP_CONTROL_FIND', 'ldap_control_find', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_EXTENDED_OPERATION_S', 'ldap_extended_operation_s', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_PARSE_EXTENDED_RESULT', 'ldap_parse_extended_result', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_PARSE_REFERENCE', 'ldap_parse_reference', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_PARSE_RESULT', 'ldap_parse_result', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_PASSWD', 'ldap_passwd', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_REFRESH_S', 'ldap_refresh_s', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_START_TLS_S', 'ldap_start_tls_s', '#include<ldap.h>', [dep_ldap, dep_lber]],
    ['HAVE_LDAP_WHOAMI_S', 'ldap_whoami_s', '#include<ldap.h>', [dep_ldap, dep_lber]],
    # net-snmp.  Its headers include openssl (scapi.h → openssl/ossl_typ.h), so
    # the openssl dependency must be present for the probe prefix to compile.
    ['HAVE_NETSNMP_INIT_MIB', 'netsnmp_init_mib', net_snmp_prefix, [dep_netsnmp, dep_openssl]],
    ['HAVE_SHUTDOWN_SNMP_LOGGING', 'shutdown_snmp_logging', net_snmp_prefix, [dep_netsnmp, dep_openssl]],
    ['HAVE_SNMP_SHA256', 'usmHMAC192SHA256AuthProtocol', net_snmp_prefix, [dep_netsnmp, dep_openssl]],
    ['HAVE_SNMP_SHA512', 'usmHMAC384SHA512AuthProtocol', net_snmp_prefix, [dep_netsnmp, dep_openssl]],
    # tidy
    ['HAVE_TIDYOPTGETDOC', 'tidyOptGetDoc', '#include<tidy.h>', [dep_tidy], tidy_include_args],
    ['HAVE_TIDYOPTGETCATEGORY', 'tidyOptGetCategory', '#include<tidy.h>', [dep_tidy], tidy_include_args],
    ['HAVE_TIDYRELEASEDATE', 'tidyReleaseDate', '#include<tidy.h>', [dep_tidy], tidy_include_args],
    # readline, which punk builds against libedit (--with-libedit)
    ['HAVE_RL_CALLBACK_READ_CHAR', 'rl_callback_read_char', '#include<editline/readline.h>', [dep_libedit]],
    ['HAVE_RL_ON_NEW_LINE', 'rl_on_new_line', '#include<editline/readline.h>', [dep_libedit]],
    ['HAVE_RL_COMPLETION_MATCHES', 'rl_completion_matches', '#include<editline/readline.h>', [dep_libedit]],
    ['HAVE_HISTORY_LIST', 'history_list', '#include<histedit.h>', [dep_libedit]],
    # libzip
    ['HAVE_ENCRYPTION', 'zip_file_set_encryption', '#include<zip.h>', [dep_libzip]],
    ['HAVE_PROGRESS_CALLBACK', 'zip_register_progress_callback_with_state', '#include<zip.h>', [dep_libzip]],
    ['HAVE_CANCEL_CALLBACK', 'zip_register_cancel_callback_with_state', '#include<zip.h>', [dep_libzip]],
    ['HAVE_METHOD_SUPPORTED', 'zip_compression_method_supported', '#include<zip.h>', [dep_libzip]],
    ['HAVE_LIBZIP_VERSION', 'zip_libzip_version', '#include<zip.h>', [dep_libzip]],
    # openssl: the check config0.m4 uses for argon2 support
    ['HAVE_OPENSSL_ARGON2', 'OSSL_set_max_threads', '#include<openssl/thread.h>', [dep_openssl]],
    # external pcre2
    ['HAVE_PCRE_JIT_SUPPORT', 'pcre2_jit_compile', '#define PCRE2_CODE_UNIT_WIDTH 8\n#include<pcre2.h>', [dep_libpcre2]],
    # gmp
    ['HAVE___GMPZ_POWM_SEC', '__gmpz_powm_sec', '#include<gmp.h>', [dep_libgmp]],
    ['HAVE___GMPZ_PREVPRIME', '__gmpz_prevprime', '#include<gmp.h>', [dep_libgmp]],
    # sqlite3
    ['HAVE_SQLITE3_EXPANDED_SQL', 'sqlite3_expanded_sql', '#include<sqlite3.h>', [dep_sqlite3]],
    ['HAVE_SQLITE3_COLUMN_TABLE_NAME', 'sqlite3_column_table_name', '#include<sqlite3.h>', [dep_sqlite3]],
]

foreach probe : library_symbols
    probe_args = check_args + (probe.length() > 4 ? probe[4] : [])
    if cc.has_function(probe[1], prefix : probe[2], dependencies : probe[3], args : probe_args)
        php_config_defs.set(probe[0], 1)
    endif
endforeach

# sqlite3_load_extension is absent from the system sqlite3 on macOS (built with
# SQLITE_OMIT_LOAD_EXTENSION); both the sqlite3 and pdo_sqlite extensions degrade
# in that case (config0.m4 / config.m4's PHP_CHECK_LIBRARY check).
if not cc.has_function('sqlite3_load_extension', prefix: '#include<sqlite3.h>', dependencies: [dep_sqlite3], args: check_args)
    php_config_defs.set('SQLITE_OMIT_LOAD_EXTENSION', 1)
    php_config_defs.set('PDO_SQLITE_OMIT_LOAD_EXTENSION', 1)
endif

# Headers that only exist when the library is installed.
library_headers = [
    ['HAVE_TIDY_H', 'tidy.h', [dep_tidy], tidy_include_args],
    ['HAVE_TIDYBUFFIO_H', 'tidybuffio.h', [dep_tidy], tidy_include_args],
]

foreach probe : library_headers
    if cc.has_header(probe[1], dependencies : probe[2], args : check_args + probe[3])
        php_config_defs.set(probe[0], 1)
    endif
endforeach

# makedev is a macro rather than a function, and epoll is what php.m4 tests with
# a compile: sys/epoll.h plus a call to epoll_create().
if cc.has_header_symbol('sys/sysmacros.h', 'makedev', args : check_args)
    php_config_defs.set('HAVE_MAKEDEV', 1)
endif
if cc.has_header_symbol('sys/wait.h', 'WIFCONTINUED', args : check_args)
    php_config_defs.set('HAVE_WIFCONTINUED', 1)
endif
if cc.find_library('dl', required : false).found()
    php_config_defs.set('HAVE_LIBDL', 1)
endif
php_config_defs.set('HAVE_LIBSODIUMLIB', 1)

# Probes that need more than a symbol name.
library_compiles = [
    # PGVerbosity gained PQERRORS_SQLSTATE in PostgreSQL 18
    ['HAVE_PQERRORS_SQLSTATE', '#include<libpq-fe.h>\nint main(void) { PGVerbosity e = PQERRORS_SQLSTATE; (void) e; return 0; }', [dep_libpq]],
    # three-argument ldap_set_rebind_proc
    ['HAVE_3ARG_SETREBINDPROC', '#include<ldap.h>\nint main(void) { ldap_set_rebind_proc(0, 0, 0); return 0; }', [dep_ldap, dep_lber]],
    # libffi calling conventions
    ['HAVE_FFI_SYSV', '#include<ffi.h>\nint main(void) { return FFI_SYSV; }', [dep_libffi]],
    # iconv implementation: glibc's own, which is what the platform image has
    ['HAVE_GLIBC_ICONV', '#include<iconv.h>\n#ifndef __GLIBC__\n# error "not glibc iconv"\n#endif\nint main(void) { return 0; }', []],
    # oniguruma's KOI8 entry is off by one in older releases
    ['PHP_ONIG_BAD_KOI8_ENTRY', '#include<stdint.h>\n#include<oniguruma.h>\nint main(void) { return (intptr_t) (ONIG_ENCODING_KOI8 + 1); }', [dep_oniguruma]],
    # opcache's shared memory backends (config.m4 sets every one that works)
    ['HAVE_SHM_IPC', '#include<sys/ipc.h>\n#include<sys/shm.h>\nint main(void) { return shmget(0, 0, 0) == -1; }', []],
    ['HAVE_SHM_MMAP_ANON', '#include<sys/mman.h>\nint main(void) { return mmap(0, 0, 0, MAP_ANON | MAP_SHARED, -1, 0) == MAP_FAILED; }', []],
    ['HAVE_SHM_MMAP_POSIX', '#include<sys/mman.h>\n#include<sys/stat.h>\n#include<fcntl.h>\nint main(void) { return shm_open("/x", O_RDWR, 0600) == -1; }', []],
    ['HAVE_EPOLL', '#include<sys/epoll.h>\nint main(void) { int fd = epoll_create(1); return fd; }', []],
    # readline declaration rather than a symbol
    ['HAVE_ERASE_EMPTY_LINE', '#include<editline/readline.h>\nint main(void) { rl_erase_empty_line = 0; return rl_erase_empty_line; }', [dep_libedit]],
]

foreach probe : library_compiles
    if cc.links(probe[1], dependencies : probe[2], args : check_args, name : probe[0])
        php_config_defs.set(probe[0], 1)
    endif
endforeach

# gd.  Punk always builds the bundled libgd, so the bundled-only defines come
# from that choice, and the image formats from the libraries the extension links.
php_config_defs.set('HAVE_GD_BUNDLED', 1)
php_config_defs.set('HAVE_GD_GET_INTERPOLATION', 1)
php_config_defs.set('HAVE_GD_PNG_GET_VERSION_STRING', 1)
gd_formats = {
    'HAVE_GD_PNG': [dep_libpng],
    'HAVE_LIBPNG': [dep_libpng],
    'HAVE_GD_JPG': [dep_libjpeg],
    'HAVE_LIBJPEG': [dep_libjpeg],
    'HAVE_GD_WEBP': [dep_libwebp],
    'HAVE_LIBWEBP': [dep_libwebp],
    'HAVE_GD_AVIF': [dep_libavif],
    'HAVE_LIBAVIF': [dep_libavif],
    'HAVE_GD_XPM': [dep_xpm],
    'HAVE_LIBXPM': [dep_xpm],
    'HAVE_XPM': [dep_xpm],
    'HAVE_GD_FREETYPE': [dep_freetype],
    'HAVE_LIBFREETYPE': [dep_freetype],
}
foreach define, deps : gd_formats
    php_config_defs.set(define, 1)
endforeach

# mysqlnd enables SSL and compression when the libraries it can use are present.
php_config_defs.set('MYSQLND_HAVE_SSL', 1)
php_config_defs.set('MYSQLND_SSL_SUPPORTED', 1)
php_config_defs.set('MYSQLND_COMPRESSION_ENABLED', 1)

# The KOI8 workaround is what the oniguruma in the platform image needs.
# HAVE_HISTORY_LIST is probed above (library_symbols): macOS's system libedit
# lacks history_list, so it must not be set unconditionally.
php_config_defs.set('PHP_ONIG_BAD_KOI8_ENTRY', 1)

# Policies that were configure options with these defaults.
php_config_defs.set('PCRE2_CODE_UNIT_WIDTH', 8)
php_config_defs.set('HAVE_HUGE_CODE_PAGES', 1)
php_config_defs.set_quoted('PHP_ICONV_IMPL', 'glibc')

# ---- compiler capabilities -------------------------------------------------
# What PHP_FUNC_ATTRIBUTE / ax_gcc_func_attribute.m4 and the alignof/goto probes
# asked the compiler for.
foreach attr : [
    ['HAVE_FUNC_ATTRIBUTE_IFUNC', 'ifunc'],
    ['HAVE_FUNC_ATTRIBUTE_VISIBILITY', 'visibility'],
]
    if cc.has_function_attribute(attr[1])
        php_config_defs.set(attr[0], 1)
    endif
endforeach

# meson's attribute table has no "target", so that one is asked of the compiler
# directly.  Both gcc and clang answer __has_attribute().
attribute_probes = [
    ['HAVE_FUNC_ATTRIBUTE_TARGET', '#ifndef __has_attribute\n# define __has_attribute(x) 0\n#endif\n#if !__has_attribute(target)\n# error "no target attribute"\n#endif\nint main(void) { return 0; }'],
]

foreach probe : attribute_probes
    if cc.compiles(probe[1], args : check_args, name : probe[0])
        php_config_defs.set(probe[0], 1)
    endif
endforeach

compiler_probes = [
    ['HAVE_ALIGNOF', 'int main(void) { return (int) __alignof__(int); }'],
    ['HAVE_ASM_GOTO', 'int main(void) { asm goto("" :::: label); label: return 0; }'],
    ['HAVE_ATTRIBUTE_ALIGNED', 'int x __attribute__((aligned(8))); int main(void) { return (int) (long) &x; }'],
    # XSI strerror_r returns char * (glibc, with _GNU_SOURCE) rather than int
    ['STRERROR_R_CHAR_P',
     '#include<string.h>\n_Static_assert(_Generic(strerror_r(0, (char[1]){0}, 1), char * : 1, default : 0), "strerror_r does not return char *");\nint main(void) { return 0; }'],
    # fopencookie's seeker takes off64_t once _FILE_OFFSET_BITS is 64
    ['COOKIE_SEEKER_USES_OFF64_T',
     '#include<stdio.h>\nstatic int seek(void *c, off64_t *o, int w) { (void) c; (void) o; (void) w; return 0; }\nint main(void) { cookie_io_functions_t f = { .seek = seek }; (void) f; return 0; }'],
    # the six-argument flavour of gethostbyname_r
    ['HAVE_FUNC_GETHOSTBYNAME_R_6',
     '#include<netdb.h>\nint main(void) { struct hostent h; struct hostent *r; char buf[1]; int e; return gethostbyname_r("x", &h, buf, sizeof buf, &r, &e); }'],
]

foreach probe : compiler_probes
    if cc.compiles(probe[1], args : check_args, name : probe[0])
        php_config_defs.set(probe[0], 1)
    endif
endforeach

# ---- runtime probes --------------------------------------------------------
# These are questions about behaviour, not availability, which is why autoconf
# compiled and ran a program for each.  Natively meson does the same; there is
# nothing to run when cross-compiling, so those answers are declared per platform
# and an undeclared platform is a hard error rather than a guess.
runtime_answers = {
    'linux': {
        'ICONV_BROKEN_IGNORE': 1,          # glibc's //IGNORE silently drops input
        'ZEND_MM_ALIGNMENT': '(size_t)8',
        'ZEND_MM_ALIGNMENT_LOG2': '(size_t)3',
        'ZEND_MM_NEED_EIGHT_BYTE_REALIGNMENT': 0,
    },
    # macOS is always 64-bit, so the pointer/double/long union is 8-byte aligned
    # just like linux; unlike glibc, its iconv //IGNORE works, so ICONV_BROKEN_IGNORE
    # is deliberately absent.
    'darwin': {
        'ZEND_MM_ALIGNMENT': '(size_t)8',
        'ZEND_MM_ALIGNMENT_LOG2': '(size_t)3',
        'ZEND_MM_NEED_EIGHT_BYTE_REALIGNMENT': 0,
    },
}

if meson.is_cross_build()
    if not runtime_answers.has_key(host_machine.system())
        error('no declared runtime answers for ' + host_machine.system() + '; add them to runtime_answers in build/meson.build')
    endif
    foreach name, value : runtime_answers[host_machine.system()]
        php_config_defs.set(name, value)
    endforeach
else
    # Can PHP write to the standard output at all (the CLI SAPI cares)?
    write_stdout = cc.run(
        '#include<unistd.h>\nint main(void) { return write(1, "ok", 2) == 2 ? 0 : 1; }',
        args : check_args,
        name : 'PHP_WRITE_STDOUT',
    )
    if write_stdout.compiled() and write_stdout.returncode() == 0 and write_stdout.stdout().strip() == 'ok'
        php_config_defs.set('PHP_WRITE_STDOUT', 1)
    endif

    # Memory manager alignment: the alignment of a union of pointer, double and
    # long, its base-2 logarithm, and whether it is too small to be useful.
    align = cc.run(
        '#include<stdio.h>\n' +
        'typedef union { void *ptr; double dbl; long lng; } mm_align_test;\n' +
        'int main(void) {\n' +
        '  size_t i = __alignof__(mm_align_test);\n' +
        '  int zeros = 0;\n' +
        '  while (i & ~(size_t) 1) { zeros++; i >>= 1; }\n' +
        '  printf("%zu %d %d\\n", __alignof__(mm_align_test), zeros, __alignof__(mm_align_test) < 4);\n' +
        '  return 0;\n' +
        '}',
        args : check_args,
        name : 'ZEND_MM_ALIGNMENT',
    )
    if align.compiled() and align.returncode() == 0
        parts = align.stdout().strip().split()
        if parts.length() != 3
            error('could not determine the memory manager alignment')
        endif
        php_config_defs.set('ZEND_MM_ALIGNMENT', '(size_t)' + parts[0])
        php_config_defs.set('ZEND_MM_ALIGNMENT_LOG2', '(size_t)' + parts[1])
        php_config_defs.set('ZEND_MM_NEED_EIGHT_BYTE_REALIGNMENT', parts[2])
    else
        error('could not run the memory manager alignment probe')
    endif

    foreach name, value : runtime_answers[host_machine.system()]
        php_config_defs.set(name, value)
    endforeach
endif

# fork() is what proc_open needs on this side of the world.
if php_config_defs.has('HAVE_FORK')
    php_config_defs.set('PHP_CAN_SUPPORT_PROC_OPEN', 1)
endif

# Punk builds crypt itself rather than linking an external libcrypt, which is
# what the absent --with-external-libcrypt means; it becomes an option when
# somebody wants the external one.
php_config_defs.set('PHP_USE_PHP_CRYPT_R', 1)

# ---- FPM -------------------------------------------------------------------
# sapi/fpm's configuration checks (config.m4's PHP_FPM_TRACE, _BUILTIN_ATOMIC and
# _LQ).  Every symbol here is read only by sapi/fpm, which is why answering it
# does not fall under the adjudication above: it cannot change how the CLI
# behaves.  Two exceptions are deliberately absent rather than overlooked:
# HAVE_SETPFLAGS, because it needs illumos' priv.h and no punk target has one,
# and HAVE_CLOCK_GET_TIME, because FPM's clock only looks for it when
# HAVE_CLOCK_GETTIME is missing, and that one is engine behaviour
# (Zend/zend_hrtime.h) and stays out.  FPM's clock therefore falls back to
# gettimeofday, the branch a build without clock_gettime takes.

# FPM's slowlog trace reads another process's memory.  fpm_config.h turns
# whichever of ptrace / /proc/<pid>/mem / mach_vm_read works into HAVE_FPM_TRACE,
# and config.m4 prefers them in that order, so the probes run in that order too.
# ptrace is asked the way config.m4 asks it -- compile, then run -- because a
# 32-bit ptrace() reading 64-bit longs only fails at run time; the PT_* aliases
# are the ones fpm_trace_ptrace.c itself defines, so the probe compiles exactly
# what the backend will.  A cross build cannot run the program and config.m4's
# answer in that case is "yes", so the compile result stands alone there.
fpm_ptrace_probe = '''
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/ptrace.h>
#include <errno.h>

#if !defined(PTRACE_ATTACH) && defined(PT_ATTACH)
# define PTRACE_ATTACH PT_ATTACH
#endif

#if !defined(PTRACE_DETACH) && defined(PT_DETACH)
# define PTRACE_DETACH PT_DETACH
#endif

#if !defined(PTRACE_PEEKDATA) && defined(PT_READ_D)
# define PTRACE_PEEKDATA PT_READ_D
#endif

int main(void)
{
    long v1 = (unsigned int) -1;
    long v2;
    pid_t child;
    int status;

    if ((child = fork())) { /* parent */
        int ret = 0;

        if (0 > ptrace(PTRACE_ATTACH, child, 0, 0)) {
            return 2;
        }

        waitpid(child, &status, 0);

#ifdef PT_IO
        struct ptrace_io_desc ptio = {
            .piod_op = PIOD_READ_D,
            .piod_offs = &v1,
            .piod_addr = &v2,
            .piod_len = sizeof(v1)
        };

        if (0 > ptrace(PT_IO, child, (void *) &ptio, 0)) {
            ret = 3;
        }
#else
        errno = 0;

        v2 = ptrace(PTRACE_PEEKDATA, child, (void *) &v1, 0);

        if (errno) {
            ret = 4;
        }
#endif
        ptrace(PTRACE_DETACH, child, (void *) 1, 0);

        kill(child, SIGKILL);

        return ret ? ret : (v1 != v2);
    }

    /* child */
    sleep(10);
    return 0;
}
'''

if meson.is_cross_build()
    fpm_have_ptrace = cc.links(fpm_ptrace_probe, args : check_args, name : 'HAVE_PTRACE')
else
    fpm_ptrace = cc.run(fpm_ptrace_probe, args : check_args, name : 'HAVE_PTRACE')
    fpm_have_ptrace = fpm_ptrace.compiled() and fpm_ptrace.returncode() == 0
endif
if fpm_have_ptrace
    php_config_defs.set('HAVE_PTRACE', 1)
endif

# /proc/<pid>/mem is the backend that needs no ptrace at all.  config.m4 accepts
# a candidate once a program can actually read its own memory through it, and
# takes the first that works, "mem" before "as"; the same program runs here with
# the candidate baked in, rather than asking whether the file merely exists.
# (The name goes into php_config.h only -- fpm_trace_pread.c substitutes it into
# its own path.)  A cross build cannot run the program and has no /proc either.
fpm_proc_mem = ''
if not meson.is_cross_build()
    foreach candidate : ['mem', 'as']
        if fpm_proc_mem == ''
            fpm_proc_mem_probe = '''
#ifndef _GNU_SOURCE
# define _GNU_SOURCE
#endif
#define _FILE_OFFSET_BITS 64

#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

int main(void)
{
    long v1 = (unsigned int) -1, v2 = 0;
    char buf[128];
    int fd;

    sprintf(buf, "/proc/%d/@MEMFILE@", getpid());

    fd = open(buf, O_RDONLY);
    if (0 > fd) {
        return 1;
    }

    if (sizeof(long) != pread(fd, &v2, sizeof(long), (uintptr_t) &v1)) {
        close(fd);
        return 1;
    }

    close(fd);

    return v1 != v2;
}
'''.replace('@MEMFILE@', candidate)
            fpm_proc_mem_run = cc.run(fpm_proc_mem_probe, args : check_args, name : 'PROC_MEM_FILE (' + candidate + ')')
            if fpm_proc_mem_run.compiled() and fpm_proc_mem_run.returncode() == 0
                fpm_proc_mem = candidate
            endif
        endif
    endforeach
endif
if fpm_proc_mem != ''
    php_config_defs.set_quoted('PROC_MEM_FILE', fpm_proc_mem)
endif

# mach_vm_read is the macOS fallback, and config.m4 only looks for it once ptrace
# has been ruled out.
if not fpm_have_ptrace and host_machine.system() == 'darwin'
    fpm_mach_vm_read_probe = '''
#include <mach/mach.h>
#include <mach/mach_vm.h>

int main(void)
{
    mach_vm_read(
        (vm_map_t)0,
        (mach_vm_address_t)0,
        (mach_vm_size_t)0,
        (vm_offset_t *)0,
        (mach_msg_type_number_t*)0);

    return 0;
}
'''
    if cc.links(fpm_mach_vm_read_probe, args : check_args, name : 'HAVE_MACH_VM_READ')
        php_config_defs.set('HAVE_MACH_VM_READ', 1)
    endif
endif

# FPM's scoreboard and log report the CPU times of its workers, which is what
# config.m4's sys/times.h + times() pair is for.
if cc.has_header('sys/times.h', args : check_args)
    if cc.has_function('times', prefix : '#include<sys/times.h>', args : check_args)
        php_config_defs.set('HAVE_TIMES', 1)
    endif
endif

# FPM defines its own clearenv() when the C library has none, and that fallback
# is an outright conflict with the declaration glibc's stdlib.h already carries.
# Nothing outside sapi/fpm reads HAVE_CLEARENV, so unlike the clock it is FPM's
# to answer.
if cc.has_function('clearenv', prefix : '#include<stdlib.h>', args : check_args)
    php_config_defs.set('HAVE_CLEARENV', 1)
endif

# FPM's lock-free shared-memory accounter, which is the compiler's atomic
# builtins when it has them; fpm_atomic.h falls back to locks otherwise.
fpm_atomic_probe = '''
int main(void)
{
    int variable = 1;

    return (__sync_bool_compare_and_swap(&variable, 1, 2)
           && __sync_add_and_fetch(&variable, 1)) ? 1 : 0;
}
'''
if cc.links(fpm_atomic_probe, args : check_args, name : 'HAVE_BUILTIN_ATOMIC')
    php_config_defs.set('HAVE_BUILTIN_ATOMIC', 1)
endif

# The listen-queue length in FPM's status page comes from whichever of these the
# system exposes: Linux reports it in tcp_info, macOS in tcp_connection_info and
# in the SO_LISTENQ* options.  All three are compile probes because each is a
# struct or a constant rather than a function.
fpm_lq_probes = [
    ['HAVE_LQ_TCP_INFO', '#include<netinet/tcp.h>\nint main(void) { struct tcp_info ti; int x = TCP_INFO; (void) ti; (void) x; return 0; }'],
    ['HAVE_LQ_TCP_CONNECTION_INFO', '#include<netinet/tcp.h>\nint main(void) { struct tcp_connection_info ti; int x = TCP_CONNECTION_INFO; (void) ti; (void) x; return 0; }'],
    ['HAVE_LQ_SO_LISTENQ', '#include<sys/socket.h>\nint main(void) { int x = SO_LISTENQLIMIT; int y = SO_LISTENQLEN; (void) x; (void) y; return 0; }'],
]

foreach probe : fpm_lq_probes
    if cc.compiles(probe[1], args : check_args, name : probe[0])
        php_config_defs.set(probe[0], 1)
    endif
endforeach

# ---- phpdbg -----------------------------------------------------------------
# The symbol sapi/phpdbg's config.m4 contributes, read only by phpdbg.

# HAVE_USERFAULTFD_WRITEFAULT is what phpdbg's write watchpoints use.  config.m4
# asks for the declaration and then takes the answer only under thread safety --
# the non-thread-safe build had to prove working pthreads instead.  The meson
# build is ZTS by default, so the option is the whole of that condition.
if get_option('zts') and cc.has_header_symbol('linux/userfaultfd.h', 'UFFDIO_WRITEPROTECT_MODE_WP', args : check_args)
    php_config_defs.set('HAVE_USERFAULTFD_WRITEFAULT', 1)
endif

# HAVE_PHPDBG_READLINE is deliberately left undefined, so phpdbg's interactive
# prompt reads a line at a time instead.  --enable-phpdbg-readline defaults to no
# in config.m4, platform/_common/configure-cli does not override it and upstream's
# CI passes a bare --enable-phpdbg, so this is the reference configuration.
# Punk does link libedit into every front-end, so enabling it is a one-line
# change if someone wants it; it is off because the reference build has it off.

# ---- deliberately not ported ----------------------------------------------
# LT_OBJDIR, STDC_HEADERS       libtool and pre-C89 leftovers
# HAVE_PRESERVE_NONE            unused
# HAVE_DECL_P_JAILID            FreeBSD only
# HAVE_USERFAULTFD_WRITEFAULT   phpdbg, which punk does not build
# scripts/dev/compare-config-headers knows about these, so `just compare-config`
# still reads as a completion gate.

# The header itself is written by main/meson.build, so that it lands in the
# build's main/ directory: Zend/zend_config.h includes <../main/php_config.h>,
# and that is where the file has to be for the include to resolve.
