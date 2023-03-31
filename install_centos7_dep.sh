#!/bin/sh
yum install -y git gcc g++ python3-all-dev bison make  ninja-build wget clang gcc-c++ unzip

wget http://www.cmake.org/files/v3.8/cmake-3.8.2.tar.gz
tar -zxvf cmake-3.8.2.tar.gz && \
cd cmake-3.8.2 && \
./bootstrap && \
make -j`nproc` && make install

mkdir -p $HOME/ninja
cd $HOME/ninja
wget https://github.com/martine/ninja/releases/download/v1.6.0/ninja-linux.zip
unzip ninja-linux.zip
exportline="export PATH=$HOME/ninja:\$PATH"
if grep -Fxq "$exportline" ~/.profile; then echo nothing to do ; else echo $exportline >> ~/.profile; fi
. ~/.profile


yum install -y centos-release-scl llvm-toolset-7
scl enable llvm-toolset-7 bash
