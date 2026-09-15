ext_snmp_sources = files(
  'snmp.c',
)

snmp_arginfo_gen = custom_target(
    'snmp_arginfo',
    input: 'snmp.stub.php',
    output: [ 'snmp_arginfo.h', 'snmp_decl.h' ],
    command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php],
)

shared_module(
    'snmp',
    [ext_snmp_sources, snmp_arginfo_gen[0], snmp_arginfo_gen[1]],
    name_prefix: '',
    name_suffix: 'so',
    c_args : [],
    include_directories : [includes, '.'],
    dependencies: [dependency('netsnmp'), dependency('openssl')],
    install : true,
)
