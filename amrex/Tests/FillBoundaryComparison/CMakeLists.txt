foreach(D IN LISTS AMReX_SPACEDIM)
    set(_sources     main.cpp)
    set(_input_files ba.max)

    setup_test(${D} _sources _input_files CMDLINE_PARAMS nrounds=1)

    unset(_sources)
    unset(_input_files)
endforeach()
