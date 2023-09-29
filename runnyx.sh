cd $TEST_HOME/Nyx/Exec/LyA

echo "Nyx: Running baseline ..."
cp ./inputs.baseline ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./baseline ./inputs > test1.txt
rm -rf ./run/*

echo "Nyx: Running previous ..."
cp ./inputs.previous ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./previous ./inputs > test2.txt
rm -rf ./run/*

echo "Nyx: Running ours ..."
cp ./inputs.ours ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./ours ./inputs > test3.txt
rm -rf ./run/*

echo "Nyx: Running noplt ..."
cp ./inputs.noplt ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./baseline ./inputs > test4.txt
rm -rf ./run/*

cd $TEST_HOME