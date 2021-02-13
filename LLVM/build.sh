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

#get lld
if [ ! -d lld ]; then
wget --retry-connrefused --tries=100 releases.llvm.org/11.0.0/lld-11.0.0.src.tar.xz
tar -xf lld-11.0.0.src.tar.xz
mv lld-11.0.0.src lld
rm lld-11.0.0.src.tar.xz

pushd llvm/tools
ln -s ../../lld .
popd

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

if [ ! -d binutils ]; then
git clone --depth 1 git://sourceware.org/git/binutils-gdb.git binutils
mkdir build
cd build
../binutils/configure --enable-gold --enable-plugins --disable-werror
make all-gold
cd ..
fi

./scripts/install-s2lab-files.sh
make -j
