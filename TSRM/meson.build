tsrm_sources = files(
    'TSRM.c'
)

tsrm_objs = static_library(
    'tsrm_objs',
    tsrm_sources,
    c_args : [],
    include_directories : [includes],
    build_by_default : false,
)

install_headers(
    'TSRM.h',
    'tsrm_win32.h',
    subdir: 'TSRM',
)
