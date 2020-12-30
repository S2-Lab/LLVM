#!/bin/bash

#get LLVM
if [ ! -d llvm ]; then
wget --retry-connrefused --tries=100 https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-11.0.0.src.tar.xz
tar -xf llvm-11.0.0.src.tar.xz
mv llvm-11.0.0.src llvm
rm llvm-11.0.0.src.tar.xz

pushd llvm/tools
ln -s ../../clang .
popd
fi

#get Clang
if [ ! -d clang ]; then
wget --retry-connrefused --tries=100. https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang-11.0.0.src.tar.xz
tar -xf clang-11.0.0.src.tar.xz
mv clang-11.0.0.src clang
rm clang-11.0.0.src.tar.xz
fi

#get compiler-rt
if [ ! -d compiler-rt ]; then
wget --retry-connrefused --tries=100 https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/compiler-rt-11.0.0.src.tar.xz
tar -xf compiler-rt-11.0.0.src.tar.xz
mv compiler-rt-11.0.0.src compiler-rt
rm compiler-rt-11.0.0.src.tar.xz

pushd llvm/projects
ln -s ../../compiler-rt .
popd
fi

./scripts/install-s2lab-files.sh
make -j
