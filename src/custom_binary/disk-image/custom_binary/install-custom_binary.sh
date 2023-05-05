# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# install build-essential (gcc and g++ included) and gfortran
echo "12345" | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gfortran git python3-dev

echo "checking python3..."
ls /usr/bin/python3

echo "checking gem5 dir"
ls /home/gem5

# * compile microbench
cd /home/gem5/microbench
sed -i "s/GEM5_HOME=\/home\/zhewen\/repo\/gem5-dev\/gem5/GEM5_HOME=\/home\/gem5/g" /home/gem5/microbench/make.rules
sed -i "s/LDFLAGS1=-L\$(GEM5_HOME)\/util\/m5\/build\/x86\/out -lm5/LDFLAGS1=-L\$(GEM5_HOME) -lm5/g" /home/gem5/microbench/make.rules
sed -i "s/GEM5_HOME=\/home\/zhewen\/repo\/gem5-dev\/gem5/GEM5_HOME=\/home\/gem5/g" /home/gem5/microbench/MGS/Makefile
sed -i "s/LDFLAGS1=-L\$(GEM5_HOME)\/util\/m5\/build\/x86\/out -lm5/LDFLAGS1=-L\$(GEM5_HOME) -lm5/g" /home/gem5/microbench/MGS/Makefile
sed -i "s/GEM5_HOME=\/home\/zhewen\/repo\/gem5-dev\/gem5/GEM5_HOME=\/home\/gem5/g" /home/gem5/microbench/MGSL/Makefile
sed -i "s/LDFLAGS1=-L\$(GEM5_HOME)\/util\/m5\/build\/x86\/out -lm5/LDFLAGS1=-L\$(GEM5_HOME) -lm5/g" /home/gem5/microbench/MGSL/Makefile
sed -i "s/GEM5_HOME=\/home\/zhewen\/repo\/gem5-dev\/gem5/GEM5_HOME=\/home\/gem5/g" /home/gem5/microbench/MGSM/Makefile
sed -i "s/LDFLAGS1=-L\$(GEM5_HOME)\/util\/m5\/build\/x86\/out -lm5/LDFLAGS1=-L\$(GEM5_HOME) -lm5/g" /home/gem5/microbench/MGSM/Makefile

make clean
echo "making gem5 bench"
make GEM5

echo "done make"
