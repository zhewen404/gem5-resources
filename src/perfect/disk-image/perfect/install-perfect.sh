# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# install build-essential (gcc and g++ included)
echo "12345" | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git python3-dev

echo "checking python3..."
ls /usr/bin/python3

echo "checking gem5 dir"
ls /home/gem5

# * compile perfect-suite
cd /home/gem5/perfect-suite

make clean
echo "making perfect-suite"
make INPUT_SIZE=LARGE SER_ONLY=true HOOKS=1

echo "done make"
