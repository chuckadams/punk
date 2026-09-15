zend_sources = files(
    'zend_alloc.c',
    'zend_API.c',
    'zend_ast.c',
    'zend_atomic.c',
    'zend_attributes.c',
    'zend_autoload.c',
    'zend_builtin_functions.c',
    'zend_call_stack.c',
    'zend_closures.c',
    'zend_compile.c',
    'zend_constants.c',
    'zend_cpuinfo.c',
    'zend_default_classes.c',
    'zend_dtrace.c',
    'zend_enum.c',
    'zend_exceptions.c',
    'zend_execute_API.c',
    'zend_execute.c',
    'zend_extensions.c',
    'zend_fibers.c',
    'zend_float.c',
    'zend_frameless_function.c',
    'zend_gc.c',
    'zend_gdb.c',
    'zend_generators.c',
    'zend_hash.c',
    'zend_highlight.c',
    'zend_hrtime.c',
    'zend_inheritance.c',
    'zend_ini.c',
    'zend_interfaces.c',
    'zend_iterators.c',
    'zend_lazy_objects.c',
    'zend_list.c',
    'zend_llist.c',
    'zend_multibyte.c',
    'zend_object_handlers.c',
    'zend_objects_API.c',
    'zend_objects.c',
    'zend_observer.c',
    'zend_opcode.c',
    'zend_operators.c',
    'zend_partial.c',
    'zend_property_hooks.c',
    'zend_ptr_stack.c',
    'zend_signal.c',
    'zend_smart_str.c',
    'zend_sort.c',
    'zend_stack.c',
    'zend_stream.c',
    'zend_string.c',
    'zend_strtod.c',
    'zend_system_id.c',
    'zend_variables.c',
    'zend_virtual_cwd.c',
    'zend_weakrefs.c',
    'zend.c',
    'Optimizer/block_pass.c',
    'Optimizer/compact_literals.c',
    'Optimizer/compact_vars.c',
    'Optimizer/dce.c',
    'Optimizer/dfa_pass.c',
    'Optimizer/escape_analysis.c',
    'Optimizer/nop_removal.c',
    'Optimizer/optimize_func_calls.c',
    'Optimizer/optimize_temp_vars_5.c',
    'Optimizer/pass1.c',
    'Optimizer/pass3.c',
    'Optimizer/sccp.c',
    'Optimizer/scdf.c',
    #    'Optimizer/ssa_integrity.c',
    'Optimizer/zend_call_graph.c',
    'Optimizer/zend_cfg.c',
    'Optimizer/zend_dfg.c',
    'Optimizer/zend_dump.c',
    'Optimizer/zend_func_info.c',
    'Optimizer/zend_inference.c',
    'Optimizer/zend_optimizer.c',
    'Optimizer/zend_ssa.c',

    # works, but is arch and OS specific, so we disable fiber asm for now
    # 'asm/jump_arm64_aapcs_elf_gas.S',
    # 'asm/make_arm64_aapcs_elf_gas.S',

    # broken if compiled while not enabled
    #    'zend_max_execution_timer.c',
)

# zend_config.h used to be an AC_CONFIG_COMMANDS heredoc; it is a one-line shim,
# and generating it into the build directory is what makes its relative include
# resolve to the build's php_config.h.
zend_config_h = configure_file(
    input : 'zend_config.h.in',
    output : 'zend_config.h',
    copy : true,
)

# The scanner and parser sources are generated, and are gitignored rather than
# committed, so meson produces its own copies into the build directory with the
# exact flags build/regenerate uses for autoconf.  re2c and bison are plain
# custom_target invocations; the one post-processing step -- making zendparse
# exported -- is folded into the bison command via perl.
re2c = find_program('re2c')
bison = find_program('bison')

zend_language_scanner_gen = custom_target(
    'zend_language_scanner',
    input : 'zend_language_scanner.l',
    output : ['zend_language_scanner.c', 'zend_language_scanner_defs.h'],
    command : [re2c, '--no-generation-date', '-W', '-g', '--case-inverted',
               '-cbdFt', '@OUTPUT1@', '-o', '@OUTPUT0@', '@INPUT@'],
)

zend_ini_scanner_gen = custom_target(
    'zend_ini_scanner',
    input : 'zend_ini_scanner.l',
    output : ['zend_ini_scanner.c', 'zend_ini_scanner_defs.h'],
    command : [re2c, '--no-generation-date', '-W', '-g', '--case-inverted',
               '-cbdFt', '@OUTPUT1@', '-o', '@OUTPUT0@', '@INPUT@'],
)

zend_language_parser_gen = custom_target(
    'zend_language_parser',
    input : 'zend_language_parser.y',
    output : ['zend_language_parser.c', 'zend_language_parser.h'],
    command : [find_program('sh'), files('../build/gen-language-parser.sh'), '@INPUT@', '@OUTPUT0@', '@OUTPUT1@'],
)

zend_ini_parser_gen = custom_target(
    'zend_ini_parser',
    input : 'zend_ini_parser.y',
    output : ['zend_ini_parser.c', 'zend_ini_parser.h'],
    command : [bison, '-Wall', '-v', '-d', '@INPUT@', '-o', '@OUTPUT0@'],
)

php = find_program('php')

# zend_vm_gen.php writes into its own directory and reads its inputs from there,
# so gen-zend-vm.sh copies the script and its inputs into the build directory
# and runs the copy; the four outputs land in the build tree like the re2c and
# bison outputs.  build/regenerate runs the script in place for autoconf.
#
# install_headers/install_data reject custom_target outputs, so the only way to
# install these is the target's own install kwarg -- which installs every output,
# including the .c.  The headers have to be installed because zend_compile.h
# (reached from php.h via zend_modules.h) includes zend_vm_opcodes.h.  The stray
# .c in the include tree is harmless.
zend_vm_gen = custom_target(
    'zend_vm',
    input : ['zend_vm_def.h', 'zend_vm_execute.skl', 'zend_vm_gen.php'],
    output : ['zend_vm_opcodes.h', 'zend_vm_opcodes.c', 'zend_vm_execute.h', 'zend_vm_handlers.h'],
    command : [find_program('sh'), files('../build/gen-zend-vm.sh'),
               meson.project_source_root() / 'Zend', '@OUTDIR@'],
    install : true,
    install_dir : php_includedir / 'php/Zend',
)

# The arginfo headers are generated from the .stub.php files; they are installed
# here (install_headers rejects custom_target outputs), and zend_objs lists them
# as sources so ninja builds them before the .c files that #include them.
zend_attributes_arginfo_gen = custom_target('zend_attributes_arginfo', input: 'zend_attributes.stub.php', output: 'zend_attributes_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_builtin_functions_arginfo_gen = custom_target('zend_builtin_functions_arginfo', input: 'zend_builtin_functions.stub.php', output: 'zend_builtin_functions_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_closures_arginfo_gen = custom_target('zend_closures_arginfo', input: 'zend_closures.stub.php', output: 'zend_closures_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_constants_arginfo_gen = custom_target('zend_constants_arginfo', input: 'zend_constants.stub.php', output: 'zend_constants_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_enum_arginfo_gen = custom_target('zend_enum_arginfo', input: 'zend_enum.stub.php', output: 'zend_enum_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_exceptions_arginfo_gen = custom_target('zend_exceptions_arginfo', input: 'zend_exceptions.stub.php', output: 'zend_exceptions_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_fibers_arginfo_gen = custom_target('zend_fibers_arginfo', input: 'zend_fibers.stub.php', output: 'zend_fibers_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_generators_arginfo_gen = custom_target('zend_generators_arginfo', input: 'zend_generators.stub.php', output: 'zend_generators_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_interfaces_arginfo_gen = custom_target('zend_interfaces_arginfo', input: 'zend_interfaces.stub.php', output: 'zend_interfaces_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')
zend_weakrefs_arginfo_gen = custom_target('zend_weakrefs_arginfo', input: 'zend_weakrefs.stub.php', output: 'zend_weakrefs_arginfo.h', command: [find_program('sh'), gen_stub_sh, '@INPUT@', '@OUTDIR@', gen_stub_php], install: true, install_dir: php_includedir / 'php/Zend')

zend_objs = static_library(
    'zend_objs',
    zend_sources,
    zend_ini_parser_gen[0],
    zend_ini_scanner_gen[0],
    zend_language_parser_gen[0],
    zend_language_scanner_gen[0],
    # The VM headers are listed (not just the generated .c) so every object in
    # this library is ordered after zend_vm_gen: zend_execute.c and
    # zend_generators.c #include zend_vm_execute.h, and zend_compile.h
    # #includes zend_vm_opcodes.h, so compiling before the generator runs reads
    # a half-written header.
    zend_vm_gen[0], zend_vm_gen[1], zend_vm_gen[2], zend_vm_gen[3],
    zend_attributes_arginfo_gen[0],
    zend_builtin_functions_arginfo_gen[0],
    zend_closures_arginfo_gen[0],
    zend_constants_arginfo_gen[0],
    zend_enum_arginfo_gen[0],
    zend_exceptions_arginfo_gen[0],
    zend_fibers_arginfo_gen[0],
    zend_generators_arginfo_gen[0],
    zend_interfaces_arginfo_gen[0],
    zend_weakrefs_arginfo_gen[0],
    c_args : static_c_args,
    include_directories : [includes],
    build_by_default : false,
)

install_headers(
    'zend.h',
    'zend_API.h',
    'zend_alloc.h',
    'zend_alloc_sizes.h',
    'zend_arena.h',
    'zend_ast.h',
    'zend_atomic.h',
    'zend_attributes.h',
        'zend_autoload.h',
    'zend_bitset.h',
    'zend_build.h',
    'zend_builtin_functions.h',
        'zend_call_stack.h',
    'zend_closures.h',
        'zend_compile.h',
    zend_config_h,
    'zend_config.w32.h',
    'zend_constants.h',
        'zend_cpuinfo.h',
    'zend_dtrace.h',
    'zend_enum.h',
        'zend_errors.h',
    'zend_exceptions.h',
        'zend_execute.h',
    'zend_extensions.h',
    'zend_fibers.h',
        'zend_float.h',
    'zend_frameless_function.h',
    'zend_gc.h',
    'zend_gdb.h',
    'zend_generators.h',
        'zend_globals.h',
    'zend_globals_macros.h',
    'zend_hash.h',
    'zend_highlight.h',
    'zend_hrtime.h',
    'zend_inheritance.h',
    'zend_ini.h',
    'zend_ini_scanner.h',
    'zend_interfaces.h',
        'zend_iterators.h',
    'zend_language_scanner.h',
    'zend_lazy_objects.h',
    'zend_list.h',
    'zend_llist.h',
    'zend_long.h',
    'zend_map_ptr.h',
    'zend_max_execution_timer.h',
    'zend_mmap.h',
    'zend_modules.h',
    'zend_multibyte.h',
    'zend_multiply.h',
    'zend_object_handlers.h',
    'zend_objects.h',
    'zend_objects_API.h',
    'zend_observer.h',
    'zend_operators.h',
    'zend_partial.h',
    'zend_perf_stat.h',
    'zend_portability.h',
    'zend_property_hooks.h',
    'zend_ptr_stack.h',
    'zend_range_check.h',
    'zend_signal.h',
    'zend_simd.h',
    'zend_smart_str.h',
    'zend_smart_str_public.h',
    'zend_smart_string.h',
    'zend_smart_string_public.h',
    'zend_sort.h',
    'zend_stack.h',
    'zend_stream.h',
    'zend_string.h',
    'zend_strtod.h',
    'zend_strtod_int.h',
    'zend_system_id.h',
    'zend_type_info.h',
    'zend_types.h',
    'zend_variables.h',
    'zend_verify_type_inference.h',
    'zend_virtual_cwd.h',
    'zend_vm.h',
    'zend_vm_def.h',
    # zend_vm_execute.h, zend_vm_handlers.h and zend_vm_opcodes.h are generated
    # in the build directory and installed by the zend_vm custom_target above
    # (install_headers rejects custom_target outputs, so they cannot be listed
    # here).
    'zend_vm_trace_handlers.h',
    'zend_vm_trace_lines.h',
    'zend_vm_trace_map.h',
    'zend_weakrefs.h',
        subdir : 'php/Zend',
)

install_headers(
    'Optimizer/zend_call_graph.h',
    'Optimizer/zend_cfg.h',
    'Optimizer/zend_dfg.h',
    'Optimizer/zend_dump.h',
    'Optimizer/zend_func_info.h',
    'Optimizer/zend_inference.h',
    'Optimizer/zend_optimizer.h',
    'Optimizer/zend_ssa.h',
    'Optimizer/zend_worklist.h',
    subdir : 'php/Zend/Optimizer',
)
