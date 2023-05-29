#!/bin/sh

# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# This file is the script that runs on the gem5 guest. This reads a file from the host via m5 readfile
# which contains the workload and the size to run. Then it resets the stats before running the workload.
# Finally, it exits the simulation after running the workload, then it copies out the result file to be checked.

cd /home/gem5/spec2017
source shrc
m5 readfile > script.sh
echo "Done reading workloads"
if [ -s script.sh ]; then
    # if the file is not empty, run spec with the parameters
    echo "Workload detected"
    echo "Reset stats"
    m5 exit

    # run the commands
    chmod +x script.sh
    ./script.sh
    # read -r workload size m5filespath < workloads
    # runcpu --size $size --iterations 1 --config myconfig.x86.cfg --define gcc_dir="/usr" --noreportable --nobuild $workload
    
else
    echo "Couldn't find any workload"
    m5 exit
    m5 exit
    m5 exit
fi
# otherwise, drop to the terminal
