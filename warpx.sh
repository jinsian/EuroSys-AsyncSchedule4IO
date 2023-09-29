cd $TEST_HOME
git clone https://github.com/ECP-WarpX/picsar.git
git clone https://github.com/ECP-WarpX/warpx-data.git

cd ./WarpX
rm -rf tmp_build_dir/s/*
make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.baseline $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.baseline ./GNUmakefile
make -j 16
mv main3d* baseline

rm -rf tmp_build_dir/s/*
make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.previous $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.previous ./GNUmakefile
make -j 16
mv main3d* previous

rm -rf tmp_build_dir/s/*
make clean
cp $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.ours $TEST_HOME/amrex/Src/Extern/HDF5/AMReX_PlotFileUtilHDF5.cpp
cp ./GNUmakefile.ours ./GNUmakefile
make -j 16
mv main3d* ours

cd $TEST_HOME