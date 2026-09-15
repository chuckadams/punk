ldap_arginfo_gen = custom_target(
    'ldap_arginfo',
    input: 'ldap.stub.php',
    output: [ 'ldap_arginfo.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

ext_ldap_sources = files(
  'ldap.c',
)

shared_module(
    'ldap',
    [ext_ldap_sources, ldap_arginfo_gen[0]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('ldap'), dependency('lber')],
    install : true,
)
