foreach(D IN LISTS AMReX_SPACEDIM)
    set(_sources CheckPair.H Constants.H main.cpp  MDParticleContainer.cpp MDParticleContainer.H )

    set(_input_files inputs  )

    setup_test(${D} _sources _input_files)

    unset(_sources)
    unset(_input_files)
endforeach()
