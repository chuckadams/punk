# not usable yet

cc = meson.get_compiler('c')
cdata = configuration_data()

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
        cdata.set('HAVE_' + h.underscorify().to_upper(), 1)
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
    ['HAVE_GETGROUPS', 'getgroups', '#include<grp.h>'],
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
    ['HAVE_MAKEDEV', 'makedev', '#include<sys/sysmacros.h>'],
    ['HAVE_MEMMEM', 'memmem', '#include<string.h>'],
    ['HAVE_MEMRCHR', 'memrchr', '#include<string.h>'],
    ['HAVE_MKFIFO', 'mkfifo', '#include<sys/stat.h>'],
    ['HAVE_MKNOD', 'mknod', '#include<unistd.h>'],
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
    ['HAVE_MAKEDEV', 'makedev', '#include<sys/sysmacros.h>'],
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
        cdata.set(f.get(0), 1)
    endif
endforeach

cdata.set('SIZEOF_INT', cc.sizeof('int'))
cdata.set('SIZEOF_LONG', cc.sizeof('long'))
cdata.set('SIZEOF_LONG_LONG', cc.sizeof('long long'))
cdata.set('SIZEOF_OFF_T', cc.sizeof('off_t', prefix : '#include<sys/types.h>'))
cdata.set('SIZEOF_SIZE_T', cc.sizeof('size_t'))

# Adjudicate before the switch: meson's checks find clearenv, clock_gettime,
# ptrace, times, tzname and the tzname declaration, while autoconf left all six
# undefined.  PHP changes behaviour when they are defined (hrtime switches to
# clock_gettime, putenv to clearenv), so they are left out until someone decides
# which answer is right rather than silently changing how punk behaves.

# Declarations have to be defined to 0 when absent -- leaving them undefined is
# not the same as "not declared" for the code that uses these.
cdata.set10('HAVE_DECL_STRERROR_R', cc.has_header_symbol('string.h', 'strerror_r', args : check_args))
cdata.set10('HAVE_DECL_STRPTIME', cc.has_header_symbol('time.h', 'strptime', args : check_args))
cdata.set10('HAVE_DECL_WCONTINUED', cc.has_header_symbol('sys/wait.h', 'WCONTINUED', args : check_args))
cdata.set10('HAVE_DECL_WEXITED', cc.has_header_symbol('sys/wait.h', 'WEXITED', args : check_args))
cdata.set10('HAVE_DECL_WNOWAIT', cc.has_header_symbol('sys/wait.h', 'WNOWAIT', args : check_args))
cdata.set10('HAVE_DECL_WSTOPPED', cc.has_header_symbol('sys/wait.h', 'WSTOPPED', args : check_args))
cdata.set10('HAVE_DECL_P_ALL', cc.has_header_symbol('sys/wait.h', 'P_ALL', args : check_args))
cdata.set10('HAVE_DECL_P_PIDFD', cc.has_header_symbol('sys/wait.h', 'P_PIDFD', args : check_args))
cdata.set10('HAVE_DECL_P_UID', cc.has_header_symbol('sys/wait.h', 'P_UID', args : check_args))
cdata.set10('HAVE_DECL_SYS_PIDFD_OPEN', cc.has_header_symbol('sys/syscall.h', 'SYS_pidfd_open', args : check_args))
cdata.set10('HAVE_DECL_SYS_WAITID', cc.has_header_symbol('sys/syscall.h', 'SYS_waitid', args : check_args))

# iconv is an implementation detail rather than a library, so it is probed here
# and again per-extension (see ext/iconv/meson.build).
cdata.set10('HAVE_ICONV_T_DEF', cc.has_header_symbol('iconv.h', 'iconv_t', args : check_args))

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
        cdata.set(t.get(0), 1)
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
    'openssl': ['HAVE_OPENSSL'],
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
        cdata.set(define, 1)
    endforeach
endforeach

# COMPILE_DL_<name> for everything that becomes a loadable module.  Today that is
# "everything not listed in cli_static_extensions in the root meson.build"; once
# the extension options exist it will follow from those.
foreach name : extension_defines.keys()
    if not cli_static_extensions.contains(name)
        cdata.set('COMPILE_DL_' + name.to_upper(), 1)
    endif
endforeach

# ---- build variants -------------------------------------------------------
# Defaults reproduce the configuration punk has always been built with:
# debug + ZTS, sigchild, ucontext fibers, no JIT, no max-execution-timers.
if get_option('zts')
    cdata.set('ZTS', 1)
endif
if get_option('zend-debug')
    cdata.set('ZEND_DEBUG', 1)
endif
if get_option('sigchild')
    cdata.set('PHP_SIGCHILD', 1)
endif
if not get_option('fiber-asm')
    cdata.set('ZEND_FIBER_UCONTEXT', 1)
endif
# Zend/Zend.m4 defines these by default: signals when sigaction exists, and the
# stack limit check unless --disable-zend-check-stack-limit is given.
cdata.set('ZEND_SIGNALS', 1)
cdata.set('ZEND_CHECK_STACK_LIMIT', 1)

# ---- build information ----------------------------------------------------
uname = run_command('uname', '-a', check : false)
if uname.returncode() == 0
    # Same as autoconf: the *build* machine's uname, so it reports the build host
    # when cross-compiling.
    cdata.set_quoted('PHP_UNAME', uname.stdout().strip())
    cdata.set_quoted('PHP_BUILD_SYSTEM', uname.stdout().strip())
endif
# autoconf reports the OS with a capital letter ("Linux"), and tests compare
# php_uname()/PHP_OS against that spelling.
if host_machine.system() == 'linux'
    cdata.set_quoted('PHP_OS', 'Linux')
else
    cdata.set_quoted('PHP_OS', host_machine.system())
endif
cdata.set('HAVE_BUILD_DEFS_H', 1)
cdata.set_quoted('DEFAULT_SHORT_OPEN_TAG', '1')

# Struct details.  These are what the C library actually exposes rather than
# separate functions, so they are member/symbol probes.
cdata.set10('HAVE_STRUCT_TM_TM_ZONE', cc.has_member('struct tm', 'tm_zone', prefix : '#include<time.h>', args : check_args))
cdata.set10('HAVE_TM_ZONE', cc.has_member('struct tm', 'tm_zone', prefix : '#include<time.h>', args : check_args))
cdata.set10('HAVE_STRUCT_TM_TM_GMTOFF', cc.has_member('struct tm', 'tm_gmtoff', prefix : '#include<time.h>', args : check_args))
cdata.set10('HAVE_STRUCT_STAT_ST_BLKSIZE', cc.has_member('struct stat', 'st_blksize', prefix : '#include<sys/stat.h>', args : check_args))
cdata.set10('HAVE_STRUCT_STAT_ST_BLOCKS', cc.has_member('struct stat', 'st_blocks', prefix : '#include<sys/stat.h>', args : check_args))
cdata.set10('HAVE_STRUCT_STAT_ST_RDEV', cc.has_member('struct stat', 'st_rdev', prefix : '#include<sys/stat.h>', args : check_args))
cdata.set10('HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY', cc.has_member('struct sockaddr_storage', 'ss_family', prefix : '#include<sys/socket.h>', args : check_args))
cdata.set10('HAVE_STRUCT_UTSNAME_DOMAINNAME', cc.has_member('struct utsname', 'domainname', prefix : '#include<sys/utsname.h>', args : check_args))
cdata.set10('GWINSZ_IN_SYS_IOCTL', cc.has_member('struct winsize', 'ws_row', prefix : '#include<sys/ioctl.h>', args : check_args))
cdata.set10('MAJOR_IN_SYSMACROS', cc.has_header_symbol('sys/sysmacros.h', 'major', args : check_args))
cdata.set10('HAVE_DECL_WIFCONTINUED', cc.has_header_symbol('sys/wait.h', 'WIFCONTINUED', args : check_args))

# IPv6 support: what PHP means by HAVE_IPV6 is that the resolver can talk AF_INET6.
cdata.set10('HAVE_IPV6', cc.has_header_symbol('netinet/in.h', 'AF_INET6', args : check_args))

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
        cdata.set(b.get(0), 1)
    endif
endforeach

# The standard extension turns chroot() and fnmatch() into feature defines of
# their own, and date needs to know its config header is there.
if cdata.has('HAVE_CHROOT')
    cdata.set('ENABLE_CHROOT_FUNC', 1)
endif
if cdata.has('HAVE_FNMATCH')
    cdata.set('HAVE_FNMATCH', 1)
endif

configure_file(
    input : 'php_config.h.in',
    output : 'php_config.h',
    configuration : cdata,
)
