import numpy as np
import sys

if len(sys.argv) < 4:
    print("Usage: python script_name.py <file_name_1> <file_name_2> <file_name_3> <file_name_4>")
    sys.exit(1)

file_name_1 = sys.argv[1]
file_name_2 = sys.argv[2]
file_name_3 = sys.argv[3]
file_name_4 = sys.argv[4]

with open(file_name_1, 'r') as file:
    data = file.readlines()

for line in data:
    if line.startswith("Total Time "):
        time_1 = float(line.split(":")[1].strip().split(" ")[0])

with open(file_name_2, 'r') as file:
    data = file.readlines()

for line in data:
    if line.startswith("Total Time "):
        time_2 = float(line.split(":")[1].strip().split(" ")[0])

with open(file_name_3, 'r') as file:
    data = file.readlines()

for line in data:
    if line.startswith("Total Time "):
        time_3 = float(line.split(":")[1].strip().split(" ")[0])

with open(file_name_4, 'r') as file:
    data = file.readlines()

for line in data:
    if line.startswith("Total Time "):
        time_4 = float(line.split(":")[1].strip().split(" ")[0])

perc_1 = 100*(time_1-time_4)/time_4
perc_2 = 100*(time_2-time_4)/time_4
perc_3 = 100*(time_3-time_4)/time_4

improve = perc_2/perc_3

print (f"Sample from 10 iterations.")
print (f"-------------------- Baseline --------------------")
print (f"Baseline: no compression, no asynchronous write.")
print (f"WarpX simulation with Baseline solution time: {time_1:.2f} seconds")
print (f"Baseline overhead compared to computation only: {perc_1:.1f} %")
print (f"-------------------- Previous --------------------")
print (f"Baseline: no compression, no asynchronous write.")
print (f"WarpX simulation with Previous solution time: {time_2:.2f} seconds")
print (f"Previous overhead compared to computation only: {perc_2:.1f} %")
print (f"---------------------- Ours ----------------------")
print (f"Baseline: no compression, no asynchronous write.")
print (f"WarpX simulation with Our solution time: {time_3:.2f} seconds")
print (f"Ours overhead compared to computation only: {perc_3:.1f} %")
print (f"------------------- Improvement ------------------")
print (f"Our improvement compared to previous: {improve:.2f} times")
print (f"----------------------- End ----------------------")
