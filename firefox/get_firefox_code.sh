#!/bin/bash

: ${VERSIONFIREFOX:=86.0}

# the rust compiler
sudo apt-get install rustc

# the rust package manager
sudo apt-get install cargo

# the headers of important libs
sudo apt-get install libgtk-2-dev
sudo apt-get install libgtk-3-dev
sudo apt-get install libgconf2-dev
sudo apt-get install libdbus-glib-1-dev
sudo apt-get install libpulse-dev

# rust dependencies
cargo install cbindgen

# an assembler for compiling webm
sudo apt-get install yasm

# Python 3 dependencies. This will work on Ubuntu 18.04LTS and later or
# Debian buster and later. For earlier releases of Ubuntu or Debian, you
# may prefer to use pyenv.
sudo apt-get install python3 python3-dev python3-pip python3-setuptools

# Python 2 dependencies. This will work on Ubuntu versions prior to 20.04 LTS
# and Debian versions prior to bullseye. For later releases of Ubuntu or
# Debian, you may prefer to use pyenv.
sudo apt-get install python python-dev python-pip python-setuptools


echo "downloading Firefox"
[ -f "firefox-$VERSIONFIREFOX.source.tar.xz" ] || wget "https://archive.mozilla.org/pub/firefox/releases/$VERSIONFIREFOX/source/firefox-$VERSIONFIREFOX.source.tar.xz"
[ -d "firefox-$VERSIONFIREFOX" ] || tar xf "firefox-$VERSIONFIREFOX.source.tar.xz"
rm firefox-86.0.source.tar.xz
wget -O bootstrap.py https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py && /usr/bin/python bootstrap.py
