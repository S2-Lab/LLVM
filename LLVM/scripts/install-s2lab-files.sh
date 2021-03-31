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

ln -s $src/clang-files/DeclCXX.cpp $clang/lib/AST/DeclCXX.cpp
ln -s $src/clang-files/DeclCXX.h $clang/include/clang/AST/DeclCXX.h
ln -s $src/clang-files/SanitizerArgs.h $clang/include/clang/Driver/SanitizerArgs.h
ln -s $src/clang-files/Sanitizers.def $clang/include/clang/Basic/Sanitizers.def
ln -s $src/clang-files/Features.def $clang/include/clang/Basic/Features.def
ln -s $src/clang-files/ToolChain.cpp $clang/lib/Driver/ToolChain.cpp
ln -s $src/clang-files/Darwin.cpp $clang/lib/Driver/ToolChains/Darwin.cpp
ln -s $src/clang-files/CommonArgs.cpp $clang/lib/Driver/ToolChains/CommonArgs.cpp
ln -s $src/clang-files/SemaDeclCXX.cpp $clang/lib/Sema/SemaDeclCXX.cpp
ln -s $src/clang-files/SemaDecl.cpp $clang/lib/Sema/SemaDecl.cpp
ln -s $src/clang-files/ASTContext.cpp $clang/lib/AST/ASTContext.cpp
ln -s $src/clang-files/BackendUtil.cpp $clang/lib/CodeGen/BackendUtil.cpp
ln -s $src/clang-files/CGExprScalar.cpp $clang/lib/CodeGen/CGExprScalar.cpp
ln -s $src/clang-files/CodeGenModule.cpp $clang/lib/CodeGen/CodeGenModule.cpp
ln -s $src/clang-files/CodeGenModule.h $clang/lib/CodeGen/CodeGenModule.h
ln -s $src/clang-files/CGClass.cpp $clang/lib/CodeGen/CGClass.cpp
ln -s $src/clang-files/CGExpr.cpp $clang/lib/CodeGen/CGExpr.cpp
ln -s $src/clang-files/CGExprCXX.cpp $clang/lib/CodeGen/CGExprCXX.cpp
ln -s $src/clang-files/CodeGenFunction.cpp $clang/lib/CodeGen/CodeGenFunction.cpp
ln -s $src/clang-files/CodeGenFunction.h $clang/lib/CodeGen/CodeGenFunction.h
ln -s $src/clang-files/CodeGenTypes.cpp $clang/lib/CodeGen/CodeGenTypes.cpp
ln -s $src/clang-files/ItaniumCXXABI.cpp $clang/lib/CodeGen/ItaniumCXXABI.cpp
ln -s $src/clang-files/Attr.td $clang/include/clang/Basic/Attr.td
ln -s $src/clang-files/AttrDocs.td $clang/include/clang/Basic/AttrDocs.td
ln -s $src/clang-files/SemaDeclAttr.cpp $clang/lib/Sema/SemaDeclAttr.cpp

#install llvm files
rm $llvmpass/S2LabPass.cpp
rm $llvm/include/llvm/InitializePasses.h
rm $llvm/lib/Transforms/Utils/CMakeLists.txt
rm $llvm/lib/Transforms/Instrumentation/CMakeLists.txt
rm $llvm/include/llvm/Transforms/Instrumentation.h
rm $llvm/lib/Transforms/Instrumentation/Instrumentation.cpp
rm $llvm/lib/Transforms/IPO/PassManagerBuilder.cpp
rm $llvm/utils/gn/secondary/llvm/lib/Transforms/IPO/BUILD.gn
rm $llvm/lib/Transforms/IPO/CMakeLists.txt
rm $llvm/lib/Transforms/IPO/IPO.cpp
rm $llvm/lib/Passes/PassBuilder.cpp
rm $llvm/lib/Passes/PassRegistry.def
rm $llvm/lib/Transforms/IPO/IPCSanLTOPass.cpp
rm $llvm/include/llvm/Transforms/IPO/IPCSanLTOPass.h
rm $llvm/include/llvm/Transforms/IPO.h

ln -s $src/llvm-files/S2LabPass.cpp $llvmpass
ln -s $src/llvm-files/InitializePasses.h $llvminc
ln -s $src/llvm-files/UtilsCMakeLists.txt $llvm/lib/Transforms/Utils/CMakeLists.txt
ln -s $src/llvm-files/InstrumentationCMakeLists.txt $llvm/lib/Transforms/Instrumentation/CMakeLists.txt
ln -s $src/llvm-files/Instrumentation.h $llvm/include/llvm/Transforms/Instrumentation.h
ln -s $src/llvm-files/Instrumentation.cpp $llvm/lib/Transforms/Instrumentation/Instrumentation.cpp
ln -s $src/llvm-files/PassManagerBuilder.cpp $llvm/lib/Transforms/IPO/PassManagerBuilder.cpp
ln -s $src/llvm-files/BUILD.gn $llvm/utils/gn/secondary/llvm/lib/Transforms/IPO/BUILD.gn
ln -s $src/llvm-files/CMakeListsIPO.txt $llvm/lib/Transforms/IPO/CMakeLists.txt
ln -s $src/llvm-files/IPO.cpp $llvm/lib/Transforms/IPO/IPO.cpp
ln -s $src/llvm-files/PassBuilder.cpp $llvm/lib/Passes/PassBuilder.cpp
ln -s $src/llvm-files/PassRegistry.def $llvm/lib/Passes/PassRegistry.def
ln -s $src/llvm-files/IPCSanLTOPass.cpp $llvm/lib/Transforms/IPO/IPCSanLTOPass.cpp
ln -s $src/llvm-files/IPCSanLTOPass.h $llvm/include/llvm/Transforms/IPO/IPCSanLTOPass.h
ln -s $src/llvm-files/IPO.h $llvm/include/llvm/Transforms/IPO.h

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
