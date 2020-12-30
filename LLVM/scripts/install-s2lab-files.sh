#!/bin/bash

#This script softlinks our modified files into the LLVM source tree

#Path to llvm source tree
llvm=`pwd`/llvm
clang=`pwd`/clang
src=`pwd`/src
runtime=`pwd`/compiler-rt

#llvm include
llvminc=$llvm/include/llvm

#llvm pass
llvmpass=$llvm/lib/Transforms/Instrumentation

#llvm passutil
llvmutil=$llvm/lib/Transforms/Utils

#llvm include
llvminclude=$llvm/include/llvm/Transforms/Utils

#install clang files
rm $clang/include/clang/Driver/SanitizerArgs.h
rm $clang/include/clang/Basic/Sanitizers.def
rm $clang/include/clang/Basic/Features.def
rm $clang/lib/Driver/ToolChain.cpp
rm $clang/lib/Driver/ToolChains/Darwin.cpp
rm $clang/lib/Driver/ToolChains/CommonArgs.cpp
rm $clang/lib/CodeGen/BackendUtil.cpp

ln -s $src/clang-files/SanitizerArgs.h $clang/include/clang/Driver/SanitizerArgs.h
ln -s $src/clang-files/Sanitizers.def $clang/include/clang/Basic/Sanitizers.def
ln -s $src/clang-files/Features.def $clang/include/clang/Basic/Features.def
ln -s $src/clang-files/ToolChain.cpp $clang/lib/Driver/ToolChain.cpp
ln -s $src/clang-files/Darwin.cpp $clang/lib/Driver/ToolChains/Darwin.cpp
ln -s $src/clang-files/CommonArgs.cpp $clang/lib/Driver/ToolChains/CommonArgs.cpp
ln -s $src/clang-files/BackendUtil.cpp $clang/lib/CodeGen/BackendUtil.cpp

#install llvm files
rm $llvmpass/s2lab.cpp
rm $llvm/include/llvm/InitializePasses.h
rm $llvm/lib/Transforms/Utils/CMakeLists.txt
rm $llvm/lib/Transforms/Instrumentation/CMakeLists.txt
rm $llvm/include/llvm/Transforms/Instrumentation.h

ln -s $src/llvm-files/s2lab.cpp $llvmpass
ln -s $src/llvm-files/InitializePasses.h $llvminc
ln -s $src/llvm-files/UtilsCMakeLists.txt $llvm/lib/Transforms/Utils/CMakeLists.txt
ln -s $src/llvm-files/InstrumentationCMakeLists.txt $llvm/lib/Transforms/Instrumentation/CMakeLists.txt
ln -s $src/llvm-files/Instrumentation.h $llvm/include/llvm/Transforms/Instrumentation.h

#include compiler-rt file
rm $runtime/cmake/config-ix.cmake
rm $runtime/lib/CMakeLists.txt
rm $runtime/lib/s2lab/CMakeLists.txt
rm $runtime/lib/s2lab/s2lab.cc
rm $runtime/lib/s2lab/s2lab.h

ln -s $src/compiler-rt-files/config-ix.cmake $runtime/cmake/config-ix.cmake
ln -s $src/compiler-rt-files/lib_cmakelists.txt $runtime/lib/CMakeLists.txt
mkdir $runtime/lib/s2lab
ln -s $src/compiler-rt-files/lib_s2lab_cmakelists.txt $runtime/lib/s2lab/CMakeLists.txt
ln -s $src/compiler-rt-files/s2lab.cc $runtime/lib/s2lab/s2lab.cc
ln -s $src/compiler-rt-files/s2lab.h $runtime/lib/s2lab/s2lab.h
