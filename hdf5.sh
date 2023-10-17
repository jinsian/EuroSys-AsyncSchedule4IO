export H5_DIR=$TEST_HOME/hdf5
export VOL_DIR=$TEST_HOME/vol-async
export ABT_DIR=$TEST_HOME/vol-async/argobots

cd $H5_DIR
mkdir install
mkdir build
cd build
export HDF5_DIR=$H5_DIR/install
export PATH=/root/cmake-3.27.6-linux-x86_64/bin:$PATH
cmake -DCMAKE_INSTALL_PREFIX=$HDF5_DIR -DHDF5_ENABLE_PARALLEL=ON -DHDF5_ENABLE_THREADSAFE=ON \
  -DALLOW_UNSUPPORTED=ON -DCMAKE_C_COMPILER=mpicc ..
make -j 16 && make install
export TEST_H5_HOME=$TEST_HOME/hdf5/install

cd $VOL_DIR
git clone https://github.com/pmodels/argobots.git
cd $ABT_DIR
./autogen.sh
./configure --prefix=$ABT_DIR/install
make -j 16 && make install

cd $VOL_DIR/src
export ABT_DIR=$TEST_HOME/vol-async/argobots/install
make
export ABT_DIR=$TEST_HOME/vol-async/argobots

export LD_LIBRARY_PATH=$VOL_DIR/src:$H5_DIR/install/lib:$ABT_DIR/install/lib:$LD_LIBRARY_PATH
export HDF5_PLUGIN_PATH="$VOL_DIR/src"
export HDF5_VOL_CONNECTOR="async under_vol=0;under_info={}"
cd $TEST_HOME
