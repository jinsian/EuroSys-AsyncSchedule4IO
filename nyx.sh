cd $TEST_HOME

cd Nyx/subprojects
set -e
git clone https://github.com/LLNL/sundials
cd sundials
mkdir builddir instdir
INSTALL_PREFIX=$(pwd)/instdir
cd builddir
cmake \
-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}  \
-DCMAKE_INSTALL_LIBDIR=lib \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_C_COMPILER=$(which gcc)  \
-DCMAKE_CXX_COMPILER=$(which g++)   \
-DCMAKE_CUDA_HOST_COMPILER=$(which g++)    \
-DEXAMPLES_INSTALL_PATH=${INSTALL_PREFIX}/examples \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CUDA_FLAGS="-DSUNDIALS_DEBUG_CUDA_LASTERROR" \
-DSUNDIALS_BUILD_PACKAGE_FUSED_KERNELS=ON \
-DCMAKE_C_FLAGS_RELEASE="-O3 -DNDEBUG" \
-DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG"  \
-DCUDA_ENABLE=ON  \
-DMPI_ENABLE=OFF  \
-DOPENMP_ENABLE=ON   \
-DF2003_INTERFACE_ENABLE=OFF   \
-DSUNDIALS_INDEX_SIZE:INT=32 ../
make -j 16
make install

cd $TEST_HOME/Nyx/Exec/LyA
wget https://portal.nersc.gov/project/nyx/ICs/256sss_20mpc.nyx
make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.baseline $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.baseline ./GNUmakefile
make -j 16
mv Nyx3d* baseline

make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.previous $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.previous ./GNUmakefile
make -j 16
mv Nyx3d* previous

make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.ours $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.ours ./GNUmakefile
make -j 16
mv Nyx3d* ours

cd $TEST_HOME
