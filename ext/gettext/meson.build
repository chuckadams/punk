gettext_arginfo_gen = custom_target(
    'gettext_arginfo',
    input: 'gettext.stub.php',
    output: [ 'gettext_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_gettext_sources = files(
  'gettext.c',
)

# glibc provides libintl in libc, but macOS has it only in homebrew's keg-only
# gettext, which ships no pkg-config file (the darwin configure passes the path
# explicitly as --with-gettext=shared,/opt/homebrew/opt/gettext).
gettext_include = []
gettext_deps = []
if host_machine.system() == 'darwin'
    gettext_include = [include_directories('/opt/homebrew/opt/gettext/include')]
    gettext_deps = [cc.find_library('intl', dirs: ['/opt/homebrew/opt/gettext/lib'])]
endif

shared_module(
    'gettext',
    [ext_gettext_sources, gettext_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'] + gettext_include,
    dependencies: gettext_deps,
    install : true,
)
