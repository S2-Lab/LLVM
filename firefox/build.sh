#!/bin/bash

export CC=$(pwd)/../../LLVM/build/bin/clang
export CXX=$(pwd)/../../LLVM/build/bin/clang++

export HEXTYPE_LOG_PATH="/home/jeon41/Typesafety-IPC/firefox/firefox-log/"

./mach build

