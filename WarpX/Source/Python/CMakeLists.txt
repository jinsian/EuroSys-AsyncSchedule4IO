###############################################################################
# These are the files equivalent to the primary C++ implementation - but here
# we define how they will appear in our Python module (aka Python bindings).
#
foreach(D IN LISTS WarpX_DIMS)
    warpx_set_suffix_dims(SD ${D})
    target_sources(lib_${SD}
      PRIVATE
        # callback hooks
        WarpX_py.cpp

        # legacy C wrapper APIs
        WarpXWrappers.cpp
    )
    if(WarpX_PYTHON)
        target_sources(pyWarpX_${SD}
          PRIVATE
            # pybind11
            WarpX.cpp
        )
    endif()
endforeach()

add_subdirectory(Particles)
