#!/bin/bash

#get LLVM
if [ ! -d llvm ]; then
wget --retry-connrefused --tries=100 releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz
tar -xf llvm-9.0.0.src.tar.xz
mv llvm-9.0.0.src llvm
rm llvm-9.0.0.src.tar.xz

pushd llvm/tools
ln -s ../../clang .
popd
fi

#get Clang
if [ ! -d clang ]; then
wget --retry-connrefused --tries=100. releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz
tar -xf cfe-9.0.0.src.tar.xz
mv cfe-9.0.0.src clang
rm cfe-9.0.0.src.tar.xz
fi

#get compiler-rt
if [ ! -d compiler-rt ]; then
wget --retry-connrefused --tries=100 releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz
tar -xf compiler-rt-9.0.0.src.tar.xz
mv compiler-rt-9.0.0.src compiler-rt
rm compiler-rt-9.0.0.src.tar.xz

pushd llvm/projects
ln -s ../../compiler-rt .
popd
fi

make -j
