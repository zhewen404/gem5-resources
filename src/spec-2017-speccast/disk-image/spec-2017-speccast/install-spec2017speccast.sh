# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# install build-essential (gcc and g++ included) and gfortran
echo "12345" | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential gfortran git

# mount the SPEC2017 ISO file and install SPEC to the disk image
mkdir /home/gem5/mnt
mount -o loop -t iso9660 /home/gem5/cpu2017-1.1.0.iso /home/gem5/mnt
mkdir /home/gem5/spec2017
echo "y" | /home/gem5/mnt/install.sh -d /home/gem5/spec2017 -u linux-x86_64
cd /home/gem5/spec2017
. /home/gem5/mnt/shrc
umount /home/gem5/mnt
rm -f /home/gem5/cpu2017-1.1.0.iso

# * install papi on disk image
cd /home/gem5/papi/src
./configure
make
make install
echo "installed papi"

# * apply patch
cd /home/gem5/SPECcast
cp SPEC17.patch /home/gem5/spec2017/
cd /home/gem5/spec2017
git apply SPEC17.patch
echo "applied speccast patch"

# * compile speccast binary
cd /home/gem5/SPECcast
sed -i "s/M5_OUT=\\/home\\/zhewen\\/repo\\/gem5-stable\\/gem5\\/util\\/m5\\/build\\/x86\\/out/M5_OUT=\\/home\\/gem5/g" \
    /home/gem5/SPECcast/Makefile
make clean GEM5=true
make GEM5=true
echo "make speccast complete, coppying executable and python scripts..."
cp spec_cast_gem5 /home/gem5/spec2017/
cp *.py /home/gem5/spec2017/

# * modify makefile spec
sed -i "s/#FPPFLAGS+= -DGEM5/FPPFLAGS+= -DGEM5/g" /home/gem5/spec2017/benchspec/Makefile.defaults
sed -i "s/#FPPFLAGS+= -DSPECCAST/FPPFLAGS+= -DSPECCAST/g" /home/gem5/spec2017/benchspec/Makefile.defaults
sed -i "s/#FINAL_CFLAGS   += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/FINAL_CFLAGS   += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/g" /home/gem5/spec2017/benchspec/Makefile.defaults
sed -i "s/#FINAL_CXXFLAGS += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/FINAL_CXXFLAGS += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/g" /home/gem5/spec2017/benchspec/Makefile.defaults
sed -i "s/#RAW_FFLAGS     += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/RAW_FFLAGS     += -DGEM5 -DM5OP_ADDR=0xFFFF0000 -DM5OP_PIC/g" /home/gem5/spec2017/benchspec/Makefile.defaults
echo "modified makefile.default"

# use the example config as the template
cp /home/gem5/spec2017/config/Example-gcc-linux-x86.cfg /home/gem5/spec2017/config/myconfig.x86.cfg

# use sed command to remove the march=native flag when compiling
# this is necessary as the packer script runs in kvm mode, so the details of the CPU will be that of the host CPU
# the -march=native flag is removed to avoid compiling instructions that gem5 does not support
# finetuning flags should be manually added
sed -i "s/-march=native//g" /home/gem5/spec2017/config/myconfig.x86.cfg

# prevent runcpu from calling sysinfo
# https://www.spec.org/cpu2017/Docs/config.html#sysinfo-program
# this is necessary as the sysinfo program queries the details of the system's CPU
# the query causes gem5 runtime error
sed -i "s/command_add_redirect = 1/sysinfo_program =\ncommand_add_redirect = 1/g" /home/gem5/spec2017/config/myconfig.x86.cfg

# * label and gcc dir
echo "modifying config..."
sed -i "s/%define label mytest/%define label myspeccast/g" /home/gem5/spec2017/config/myconfig.x86.cfg
sed -i "s/%   define  gcc_dir        \\/SW\\/compilers\\/GCC\\/Linux\\/x86_64\\/gcc-6.3.0/%   define  gcc_dir        \\/usr/g" /home/gem5/spec2017/config/myconfig.x86.cfg
sed -i "s/%   define  build_ncpus 8/%   define  build_ncpus 64/g" /home/gem5/spec2017/config/myconfig.x86.cfg
echo "ready to run setup spec"

# build all SPEC workloads
# build_ncpus: number of cpus to build the workloads
# gcc_dir: where to find the compilers (gcc, g++, gfortran)
runcpu --config=myconfig.x86.cfg --action=runsetup specrate

# echo "testing spec_cast********************************"
# cd /home/gem5/spec2017
# ./spec_cast -w -c myspeccast -p 8 -l 2 --mcf --bwaves 2

# cat /home/gem5/*out.txt

# the above building process will produce a large log file
# this command removes the log files to avoid copying out large files unnecessarily
rm -f /home/gem5/spec2017/result/*
echo "removed large log file"
