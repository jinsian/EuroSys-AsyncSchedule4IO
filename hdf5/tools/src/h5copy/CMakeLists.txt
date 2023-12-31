cmake_minimum_required (VERSION 3.18)
project (HDF5_TOOLS_SRC_H5COPY C)

# --------------------------------------------------------------------
# Add the h5copy and test executables
# --------------------------------------------------------------------
if (BUILD_STATIC_LIBS)
  add_executable (h5copy ${HDF5_TOOLS_SRC_H5COPY_SOURCE_DIR}/h5copy.c)
  target_include_directories (h5copy PRIVATE "${HDF5_TOOLS_DIR}/lib;${HDF5_SRC_INCLUDE_DIRS};${HDF5_SRC_BINARY_DIR};$<$<BOOL:${HDF5_ENABLE_PARALLEL}>:${MPI_C_INCLUDE_DIRS}>")
  target_compile_options(h5copy PRIVATE "${HDF5_CMAKE_C_FLAGS}")
  TARGET_C_PROPERTIES (h5copy STATIC)
  target_link_libraries (h5copy PRIVATE ${HDF5_TOOLS_LIB_TARGET} ${HDF5_LIB_TARGET})
  set_target_properties (h5copy PROPERTIES FOLDER tools)
  set_global_variable (HDF5_UTILS_TO_EXPORT "${HDF5_UTILS_TO_EXPORT};h5copy")

  set (H5_DEP_EXECUTABLES h5copy)
endif ()

if (BUILD_SHARED_LIBS)
  add_executable (h5copy-shared ${HDF5_TOOLS_SRC_H5COPY_SOURCE_DIR}/h5copy.c)
  target_include_directories (h5copy-shared PRIVATE "${HDF5_TOOLS_DIR}/lib;${HDF5_SRC_INCLUDE_DIRS};${HDF5_SRC_BINARY_DIR};$<$<BOOL:${HDF5_ENABLE_PARALLEL}>:${MPI_C_INCLUDE_DIRS}>")
  target_compile_options(h5copy-shared PRIVATE "${HDF5_CMAKE_C_FLAGS}")
  TARGET_C_PROPERTIES (h5copy-shared SHARED)
  target_link_libraries (h5copy-shared PRIVATE ${HDF5_TOOLS_LIBSH_TARGET} ${HDF5_LIBSH_TARGET})
  set_target_properties (h5copy-shared PROPERTIES FOLDER tools)
  set_global_variable (HDF5_UTILS_TO_EXPORT "${HDF5_UTILS_TO_EXPORT};h5copy-shared")

  set (H5_DEP_EXECUTABLES ${H5_DEP_EXECUTABLES} h5copy-shared)
endif ()

#-----------------------------------------------------------------------------
# Add Target to clang-format
#-----------------------------------------------------------------------------
if (HDF5_ENABLE_FORMATTERS)
  if (BUILD_STATIC_LIBS)
    clang_format (HDF5_H5COPY_SRC_FORMAT h5copy)
  else ()
    clang_format (HDF5_H5COPY_SRC_FORMAT h5copy-shared)
  endif ()
endif ()

##############################################################################
##############################################################################
###           I N S T A L L A T I O N                                      ###
##############################################################################
##############################################################################

#-----------------------------------------------------------------------------
# Rules for Installation of tools using make Install target
#-----------------------------------------------------------------------------
if (HDF5_EXPORTED_TARGETS)
  foreach (exec ${H5_DEP_EXECUTABLES})
    INSTALL_PROGRAM_PDB (${exec} ${HDF5_INSTALL_BIN_DIR} toolsapplications)
  endforeach ()

  install (
      TARGETS
          ${H5_DEP_EXECUTABLES}
      EXPORT
          ${HDF5_EXPORTED_TARGETS}
      RUNTIME DESTINATION ${HDF5_INSTALL_BIN_DIR} COMPONENT toolsapplications
  )
endif ()
