cd $TEST_HOME/WarpX/

echo "WarpX: Running baseline ..."
cp ./inputs.ori ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./baseline ./inputs > test1.txt
rm -rf ./diags/*

echo "WarpX: Running previous ..."
cp ./inputs.ori ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./previous ./inputs > test2.txt
rm -rf ./diags/*

echo "WarpX: Running ours ..."
cp ./inputs.ori ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./ours ./inputs > test3.txt
rm -rf ./diags/*

echo "WarpX: Running noplt ..."
cp ./inputs.noplt ./inputs
sudo /opt/ompi/bin/mpirun -np 16 --allow-run-as-root ./baseline ./inputs > test4.txt
rm -rf ./diags/*

cd $TEST_HOME