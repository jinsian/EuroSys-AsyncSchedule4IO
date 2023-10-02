# Concealing Compression-accelerated I/O for HPC Applications through In Situ Task Scheduling

[![DOI](https://zenodo.org/badge/698428132.svg)](https://zenodo.org/badge/latestdoi/698428132)

Lossy compression and asynchronous I/O are two of the most effective solutions for reducing storage overhead and enhancing I/O performance in large-scale high-performance computing (HPC) applications. However, current approaches have limitations that prevent them from fully leveraging lossy compression, and they may also result in task collisions, which restrict the overall performance of HPC applications. 

To address these issues, we propose an optimization approach for the task scheduling problem that encompasses computation, compression, and I/O. experimental results with up to 16 nodes and 64 GPUs from ORNL Summit, as well as real-world HPC applications, demonstrate that our solution reduces I/O overhead by up to 3.8× and 2.6× compared to non-compression and asynchronous I/O solutions, respectively.

Within this artifact, we offer a comparative analysis, benchmarking our solution against two alternative approaches: (1) the previous method employing asynchronous writes without data compression, and (2) the baseline solution uses synchronous data writes without compression. This alignment with our paper underscores the performance enhancements our solution delivers.

Furthermore, we conducted our artifact implementation on Chameleon Cloud, utilizing a Singularity container to ensure optimal applicability across various computing environments. The test node on Chameleon Cloud is equipped with two Intel Xeon E5-2660 CPUs and 128 GB of memory, specifically configured with gpu.model=P100. We strongly recommend to use Chameleon Cloud platform for assessments with consistency and reproducibility.

## Method 1: Use Singularity Image (Highly Recommended)
The entire workflow takes approximately 15 minutes to execute, including downloading container image and preparing environment (4 mins), running WarpX simulation (5 mins), running Nyx simulation (5 mins), and evaluating performance (1 min).

### Minimum system requirements
OS: Ubuntu (20.04 is recommended)

GPU: Nvidia GPUs with CUDA >= 12.2

Memory: >= 16 GB RAM

Processor: >= 16 cores

Storage: >= 32 GBs

### Step 1: Install Singularity
Install [Singularity](https://singularity-tutorial.github.io/01-installation/)

### Step 2: Download, Build, and run the image file (need root privilege) with singularity
You can download, build, and run the image file that encompasses all the necessary components.
```
sudo pip3 install gdown
gdown  https://drive.google.com/uc?id=1o0AumoDJgnZKcLXv-ZH7b5lGhKzP4_6A
sudo singularity build --sandbox artiAsync AsyncSchedule.sif
sudo singularity shell --writable artiAsync
```
Now, you are running inside of the container.

### Step 4: Set up environmental variables
```
export OMPI_DIR=/opt/ompi 
export OMPI_VERSION=4.1.1
export PATH=$OMPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
export MANPATH=$OMPI_DIR/share/man:$MANPATH
export C_INCLUDE_PATH=/opt/ompi/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/ompi/include:$CPLUS_INCLUDE_PATH
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
```

### Step 5: Run Nyx simulation with (1) baseline, (2) previous, and (3) ours
```
cd /home/EuroSys-AsyncSchedule/
bash ./runnyx.sh
```

### Step 6: Run WarpX simulation with (1) baseline, (2) previous, and (3) ours
```
cd /home/EuroSys-AsyncSchedule/
bash ./runwarpx.sh
```

### Step 7 (Optional): We retaine log files for all runs, and now you can check them out
```
head -n 200 ./Nyx/Exec/LyA/test1.txt
head -n 100 ./WarpX/test1.txt
```
### The expected results for Nyx’s log are:
```
Nyx::est_time_step at level 0:  estdt = 1.365270159e-07
Integrating a from time 1.345051497e-07 by dt = 1.365270159e-07
Old / new A time      1.345051497e-07 2.710321656e-07
Old / new A           0.00631247703 0.0063755786
Old / new z           157.416418 155.8485094
Re-integrating a from time 1.345051497e-07 by dt = 1.365270159e-07
Old / new A time         1.345051497e-07 2.710321656e-07
Old / new A              0.00631247703 0.0063755786
Old / new z              157.416418 155.8485094
[Level 0 step 2] ADVANCE at time 1.345051497e-07 with dt = 1.365270159e-07
Gravity ... multilevel solve for old phi at base level 0 to finest level 0
ParticleContainer::AssignCellDensitySingleLevel) time: 0.070188051
 ... subtracting average density 3.760710576e+10 from RHS at each level 
 ... subtracting -2.861022949e-06 to ensure solvability 
MLMG: Initial rhs               = 103869.8512
MLMG: Initial residual (resid0) = 103869.8512
MLMG: Final Iter. 10 resid, resid/bnorm = 2.480104285e-06, 2.387703705e-11
MLMG: Timers: Solve = 1.333416157 Iter = 1.276759186 Bottom = 0.001101284
moveKickDrift ... updating particle positions and velocity
Gravity ... single level solve for new phi at level 0
ParticleContainer::AssignCellDensitySingleLevel) time: 0.074792854
 ... solve for phi at level 0
 ... subtracting average density from RHS in solve ... 3.760710576e+10
 ... subtracting 3.531575203e-06 to ensure solvability 
MLMG: Initial rhs               = 101952.6971
MLMG: Initial residual (resid0) = 6501.955658
MLMG: Final Iter. 7 resid, resid/bnorm = 2.565720933e-06, 2.516579753e-11
MLMG: Timers: Solve = 0.940721187 Iter = 0.901259195 Bottom = 0.000870347
```
### The expected results for WarpX’s log are:
```
STEP 3 starts ...
--- INFO    : Writing plotfile diags/plt000003
STEP 3 ends. TIME = 3.25787071e-16 DT = 1.085956903e-16
Evolve time = 10.47966713 s; This step = 3.457123984 s; Avg. per step = 3.493222377 s

STEP 4 starts ...
```

### Step 8: Evaluate Nyx's perormance between (1) baseline, (2) previous, and (3) ours
```
cd ./Nyx/Exec/LyA
python3 ./readresults.py test1.txt test2.txt test3.txt test4.txt
```

### Step 9: Evaluate WarpX's perormance between (1) baseline, (2) previous, and (3) ours
```
cd $TEST_HOME/WarpX/
python3 ./readresults.py test1.txt test2.txt test3.txt test4.txt
```
### The expected results for Nyx’s performance comparison are:
```
Sample from 10 iterations.
-------------------- Baseline --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Baseline solution time: 47.08 seconds
Baseline overhead compared to computation only: 37.2 %
-------------------- Previous --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Previous solution time: 47.04 seconds
Previous overhead compared to computation only: 37.1 %
---------------------- Ours ----------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Our solution time: 37.12 seconds
Ours overhead compared to computation only: 8.2 %
------------------- Improvement ------------------
Our improvement compared to previous: 4.53 times
----------------------- End ----------------------
```
### The expected results for Nyx’s performance comparison are:
```
Sample from 10 iterations.
-------------------- Baseline --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Baseline solution time: 38.74 seconds
Baseline overhead compared to computation only: 121.9 %
-------------------- Previous --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Previous solution time: 38.52 seconds
Previous overhead compared to computation only: 120.6 %
---------------------- Ours ----------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Our solution time: 23.87 seconds
Ours overhead compared to computation only: 36.7 %
------------------- Improvement ------------------
Our improvement compared to previous: 3.29 times
----------------------- End ----------------------
```
Please note that the performance may vary on different machines and environments. Nevertheless, you should be able to discern the performance improvements our solution offers compared to previous approaches. These results are consistent with our paper's findings. Please be aware that the runtime may vary, particularly when resources are limited. We highly recommend running steps 5, 6, 8, and 9 multiple times to observe consistent results.


## Method 2: Build From Source
### Minimum system & software libraries requirements
OS: Linux (Ubuntu is recommended)

GPU: Nvidia GPUs with CUDA >= 12.2

Memory: >= 16 GB RAM

Processor: >= 8 cores

gcc/9.4.0 (or 9.3.0)

cmake (>= 3.23)

OpenMPI/4.1.1 (install scripts provided, or spectrum-mpi)

python/3.8

hdf5/1.12.2 (install scripts provided)


### Step 1: Download our code and set up environmental variables (2 mins)
```
git clone https://github.com/jinsian/EuroSys-AsyncSchedule4IO.git
cd EuroSys-AsyncSchedule
export TEST_HOME=$(pwd)
export TEST_HOME=$(pwd) >> ~/.bashrc
```
### Step 2: Load or install CMake and numpy. For example, in Ubuntu
```
pip3 install numpy
sudo snap install cmake --classic
```
### Step 3: Load or install OpenMPI. For example, in Ubuntu (7 mins)
```
cd $TEST_HOME
sudo bash openmpi.sh 
```
### Step 4: Download and install the HDF5 library (4 mins)
```
sudo bash hdf5.sh
```
### Step 5: Install optimized SZ3 compressor (5 mins)
```
sudo bash sz.sh
```
### Step 6: Install AMReX and Nyx with our solution (8 mins)
```
sudo bash nyx.sh
```
### Step 7: Install WarpX with our solution (9 mins)
```
sudo bash warpx.sh
```
### Step 8: Run Nyx simulation with (1) baseline, (2) previous, and (3) ours
```
sudo bash ./runnyx.sh
```
### Step 9: Run WarpX simulation with (1) baseline, (2) previous, and (3) ours
```
sudo bash ./runwarpx.sh
```
### Step 10 (Optional): We retaine log files for all runs, and now you can check them out
```
head -n 200 ./Nyx/Exec/LyA/test1.txt
head -n 100 ./WarpX/test1.txt
```
### The expected results for Nyx’s log are:
```
Nyx::est_time_step at level 0:  estdt = 1.365270159e-07
Integrating a from time 1.345051497e-07 by dt = 1.365270159e-07
Old / new A time      1.345051497e-07 2.710321656e-07
Old / new A           0.00631247703 0.0063755786
Old / new z           157.416418 155.8485094
Re-integrating a from time 1.345051497e-07 by dt = 1.365270159e-07
Old / new A time         1.345051497e-07 2.710321656e-07
Old / new A              0.00631247703 0.0063755786
Old / new z              157.416418 155.8485094
[Level 0 step 2] ADVANCE at time 1.345051497e-07 with dt = 1.365270159e-07
Gravity ... multilevel solve for old phi at base level 0 to finest level 0
ParticleContainer::AssignCellDensitySingleLevel) time: 0.070188051
 ... subtracting average density 3.760710576e+10 from RHS at each level 
 ... subtracting -2.861022949e-06 to ensure solvability 
MLMG: Initial rhs               = 103869.8512
MLMG: Initial residual (resid0) = 103869.8512
MLMG: Final Iter. 10 resid, resid/bnorm = 2.480104285e-06, 2.387703705e-11
MLMG: Timers: Solve = 1.333416157 Iter = 1.276759186 Bottom = 0.001101284
moveKickDrift ... updating particle positions and velocity
Gravity ... single level solve for new phi at level 0
ParticleContainer::AssignCellDensitySingleLevel) time: 0.074792854
 ... solve for phi at level 0
 ... subtracting average density from RHS in solve ... 3.760710576e+10
 ... subtracting 3.531575203e-06 to ensure solvability 
MLMG: Initial rhs               = 101952.6971
MLMG: Initial residual (resid0) = 6501.955658
MLMG: Final Iter. 7 resid, resid/bnorm = 2.565720933e-06, 2.516579753e-11
MLMG: Timers: Solve = 0.940721187 Iter = 0.901259195 Bottom = 0.000870347
```
### The expected results for WarpX’s log are:
```
STEP 3 starts ...
--- INFO    : Writing plotfile diags/plt000003
STEP 3 ends. TIME = 3.25787071e-16 DT = 1.085956903e-16
Evolve time = 10.47966713 s; This step = 3.457123984 s; Avg. per step = 3.493222377 s

STEP 4 starts ...
```
### Step 11: Evaluate Nyx's perormance between (1) baseline, (2) previous, and (3) ours
```
cd ./Nyx/Exec/LyA
python3 ./readresults.py test1.txt test2.txt test3.txt test4.txt
```
### Step 12: Evaluate WarpX's perormance between (1) baseline, (2) previous, and (3) ours
```
cd $TEST_HOME/WarpX/
python3 ./readresults.py test1.txt test2.txt test3.txt test4.txt
```
### The expected results for Nyx’s performance comparison are:
```
Sample from 10 iterations.
-------------------- Baseline --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Baseline solution time: 47.08 seconds
Baseline overhead compared to computation only: 37.2 %
-------------------- Previous --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Previous solution time: 47.04 seconds
Previous overhead compared to computation only: 37.1 %
---------------------- Ours ----------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Our solution time: 37.12 seconds
Ours overhead compared to computation only: 8.2 %
------------------- Improvement ------------------
Our improvement compared to previous: 4.53 times
----------------------- End ----------------------
```
### The expected results for Nyx’s performance comparison are:
```
Sample from 10 iterations.
-------------------- Baseline --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Baseline solution time: 38.74 seconds
Baseline overhead compared to computation only: 121.9 %
-------------------- Previous --------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Previous solution time: 38.52 seconds
Previous overhead compared to computation only: 120.6 %
---------------------- Ours ----------------------
Baseline: no compression, no asynchronous write.
Nyx simulation with Our solution time: 23.87 seconds
Ours overhead compared to computation only: 36.7 %
------------------- Improvement ------------------
Our improvement compared to previous: 3.29 times
----------------------- End ----------------------
```
Please note that the performance may vary on different machines and environments. Nevertheless, you should be able to discern the performance improvements our solution offers compared to previous approaches. These results are consistent with our paper's findings. Please be aware that the runtime may vary, particularly when resources are limited. We highly recommend running steps 8, 9, 11, and 12 multiple times to observe consistent results.
