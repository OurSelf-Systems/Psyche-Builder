#!/usr/bin/env bash

#
# Is environment OK?
#

if freebsd-version | grep -qv '14.2'; then
	echo 'Not a supported FreeBSD Version'
	exit 1
fi

#
# Setup 
#

mkdir build
git clone https://github.com/russellallen/self.git
pushd self ; git checkout dev ; popd

#
# Build
#

pushd build
CC=gcc CPP=g++ cmake ../self
cmake --build .
popd

#
# Package
#

mkdir vm
cp build/vm/Self vm/
cp /usr/local/lib/libSM.so.6 vm/
cp /usr/local/lib/libICE.so.6 vm/
cp /usr/local/lib/libX11.so.6 vm/
cp /usr/local/lib/libXext.so.6 vm/
cp /lib/libncursesw.so.9 vm/
cp /lib/libtinfow.so.9 vm/
cp /usr/lib/libformw.so.6 vm/
cp /usr/local/lib/gcc13/libstdc++.so.6 vm/
cp /lib/libm.so.5 vm/
cp /lib/libgcc_s.so.1 vm/
cp /lib/libc.so.7 vm/
cp /usr/local/lib/libxcb.so.1 vm/
cp /lib/libthr.so.3 vm/
cp /usr/local/lib/libXau.so.6 vm/
cp /usr/local/lib/libXdmcp.so.6 vm/
pushd vm
# https://trugman-internals.com/posts/2019-06-20-elf-linux/
patchelf --set-rpath '$ORIGIN' *
popd

