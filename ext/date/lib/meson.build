# timelib's config header.  It lives in this subdirectory because that is where
# timelib's sources look for it, so the generated copy has to land in the
# matching build directory; the root meson.build puts it on the include path,
# since php_date.h reaches it from other extensions too.
timelib_config_h = configure_file(
    input : 'timelib_config.h.in',
    output : 'timelib_config.h',
    copy : true,
)
