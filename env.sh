cd /home/cc/EuroSys-AsyncSchedule4IO/
export TEST_HOME=$(pwd)
export OMPI_DIR=/opt/ompi
export OMPI_VERSION=4.1.1
export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$OMPI_VERSION.tar.bz2"
export PATH=$OMPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
export MANPATH=$OMPI_DIR/share/man:$MANPATH
export C_INCLUDE_PATH=/opt/ompi/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/ompi/include:$CPLUS_INCLUDE_PATH
export OMPI_DIR=/opt/ompi 
export OMPI_VERSION=4.1.1
export PATH=$OMPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_DIR/\
lib:$LD_LIBRARY_PATH
export MANPATH=$OMPI_DIR/share/man:$MANPATH
export C_INCLUDE_PATH=/opt/ompi/include\
:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/ompi/\
include:$CPLUS_INCLUDE_PATH
export OMPI_DIR=/opt/ompi 
export OMPI_VERSION=4.1.1
export PATH=$OMPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
export MANPATH=$OMPI_DIR/share/man:$MANPATH
export C_INCLUDE_PATH=/opt/ompi/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/ompi/include:$CPLUS_INCLUDE_PATH
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
export H5_DIR=$TEST_HOME/hdf5
export VOL_DIR=$TEST_HOME/vol-async
export ABT_DIR=$TEST_HOME/vol-async/argobots
export HDF5_DIR=$H5_DIR/install
export PATH=/root/cmake-3.27.6-linux-x86_64/bin:$PATH
export TEST_H5_HOME=$TEST_HOME/hdf5/install
export LD_LIBRARY_PATH=$VOL_DIR/src:$H5_DIR/install/lib:$ABT_DIR/install/lib:$LD_LIBRARY_PATH
export HDF5_PLUGIN_PATH="$VOL_DIR/src"
export HDF5_VOL_CONNECTOR="async under_vol=0;under_info={}"
export SZ3_HOME=$TEST_HOME/SZ3/install
