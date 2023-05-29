---
title: PERFECT
tags:
    - x86
    - fullsystem
layout: default
permalink: resources/perfect
shortdoc: >
    Resources to build a disk image with the perfect suite.
license: 
---

This document aims to provide instructions to create a gem5-compatible disk
image containing the custom benchmarks. It also demonstrates how to
simulate these benchmarks using an example configuration script.
Note that the perfect binaries contains gem5 roi begin and end hooks
to annotate roi. (See line18 in install-perfect.sh 
"make INPUT_SIZE=LARGE HOOKS=1")

## Building the Disk Image

The layout of the folder after the scripts are run is as follows,

```
perfect/
  |___ gem5/                                   # gem5 folder
  |
  |___ disk-image/
  |      |___ build.sh                         # the script downloading packer binary and building the disk image
  |      |___ shared/
  |      |___ perfect/
  |             |___ perfect-image/
  |             |      |___ perfect          # the disk image will be generated here
  |             |___ perfect.json            # the Packer script
  |             |___ cpu2017-1.1.0.iso         # SPEC 2017 ISO (add here)
  |
  |___ vmlinux-4.19.83                         # Linux kernel, link to download provided below
  |
  |___ README.md
perfect/
  |
```

First, to build `m5` (required for interactions between gem5 and the system under simuations):

```sh
git clone https://gem5.googlesource.com/public/gem5
cd gem5
cd util/m5
scons build/x86/out/m5
```

We use [Packer](https://www.packer.io/), an open-source automated disk image
creation tool, to build the disk image.
In the root folder,

```sh
cd disk-image
./build.sh          # the script downloading packer binary and building the disk image
```

