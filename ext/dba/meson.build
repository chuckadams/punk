ext_dba_sources = files(
  'dba.c',
  'dba_cdb.c',
  'dba_db1.c',
  'dba_db2.c',
  'dba_db3.c',
  'dba_db4.c',
  'dba_dbm.c',
  'dba_flatfile.c',
  'dba_gdbm.c',
  'dba_inifile.c',
  'dba_lmdb.c',
  'dba_ndbm.c',
  'dba_qdbm.c',
  'dba_tcadb.c',
  'libcdb/cdb.c',
  'libcdb/cdb_make.c',
  'libcdb/uint32.c',
  'libflatfile/flatfile.c',
  'libinifile/inifile.c',
)

shared_module(
    'dba',
    [ext_dba_sources],
    name_prefix: '',
    c_args : [],
    include_directories : [includes],
)
