cd SZ3
mkdir install
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=$TEST_HOME/SZ3/install -DBUILD_H5Z_FILTER=ON ..
export SZ3_HOME=$TEST_HOME/SZ3/install
make -j 8
make install 

echo export SZ3_HOME=$TEST_HOME/SZ3/install >> ~/.bashrc
cd $TEST_HOME