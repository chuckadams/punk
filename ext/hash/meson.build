
ext_hash_sources = files(
    'sha3/generic64lc/KeccakP-1600-opt64.c',
    'sha3/generic64lc/KeccakHash.c',
    'sha3/generic64lc/KeccakSponge.c',
    'hash_adler32.c',
    'hash_crc32.c',
    'hash_fnv.c',
    'hash_gost.c',
    'hash_haval.c',
    'hash_joaat.c',
    'hash_md.c',
    'hash_murmur.c',
    'hash_ripemd.c',
    'hash_sha_ni.c',
    'hash_sha_sse2.c',
    'hash_sha.c',
    'hash_sha3.c',
    'hash_snefru.c',
    'hash_tiger.c',
    'hash_whirlpool.c',
    'hash_xxhash.c',
    'hash.c',
    'murmur/PMurHash.c',
    'murmur/PMurHash128.c',
)

ext_hash_objs = static_library(
    'ext_hash_objs',
    ext_hash_sources,
    c_args: ['-DKeccakP200_excluded', '-DKeccakP400_excluded', '-DKeccakP800_excluded'],
    include_directories: [includes, 'sha3/generic64lc'],
    build_by_default: false,
)

shared_module(
    'hash',
    [ext_hash_sources],
    name_prefix: '',
    c_args: ['-DKeccakP200_excluded', '-DKeccakP400_excluded', '-DKeccakP800_excluded'],
    include_directories: [includes, 'sha3/generic64lc'],
)
