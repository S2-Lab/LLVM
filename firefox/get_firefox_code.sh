#!/bin/bash

: ${VERSIONFIREFOX:=72.0}

echo "downloading Firefox"
[ -f "firefox-$VERSIONFIREFOX.source.tar.xz" ] || wget "https://archive.mozilla.org/pub/firefox/releases/$VERSIONFIREFOX/source/firefox-$VERSIONFIREFOX.source.tar.xz"
[ -d "firefox-$VERSIONFIREFOX" ] || tar xf "firefox-$VERSIONFIREFOX.source.tar.xz"
rm firefox-72.0.source.tar.xz
wget -O bootstrap.py https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py && python bootstrap.py
