#!/bin/sh

in-root()
{
	doas chroot i386-chroot/ /bin/sh -c "$1"
}

doas ./mk-chroot.sh /psyche/Psyche-Builder/components/vm/i386-chroot/
#cp build-in-chroot.sh i386-chroot
in-root "pkg install -y rsync cmake git xxd libX11 libXext gcc bash patchelf"
in-root "echo 'libgcc_s.so.1  /usr/local/lib/gcc13/libgcc_s.so.1' >> /etc/libmap.conf"
in-root "git clone https://github.com/russellallen/self.git"
in-root "mkdir build ; cd build ; CC=gcc CPP=g++ cmake ../self ; cmake --build ."


#
# Package
#

in-root "mkdir vm"
in-root "cp /build/vm/Self vm/"
#in-root "cp /usr/local/lib/libSM.so.6 vm/"
#in-root "cp /usr/local/lib/libICE.so.6 vm/"
in-root "cp /usr/local/lib/libX11.so.6 vm/"
in-root "cp /usr/local/lib/libXext.so.6 vm/"
in-root "cp /lib/libncursesw.so.9 vm/"
in-root "cp /lib/libtinfow.so.9 vm/"
in-root "cp /usr/lib/libformw.so.6 vm/"
in-root "cp /usr/local/lib/gcc13/libstdc++.so.6 vm/"
in-root "cp /lib/libm.so.5 vm/"
in-root "cp /lib/libgcc_s.so.1 vm/"
in-root "cp /lib/libc.so.7 vm/"
in-root "cp /usr/local/lib/libxcb.so.1 vm/"
in-root "cp /lib/libthr.so.3 vm/"
in-root "cp /usr/local/lib/libXau.so.6 vm/"
in-root "cp /usr/local/lib/libXdmcp.so.6 vm/"

# https://trugman-internals.com/posts/2019-06-20-elf-linux/
doas patchelf --set-rpath \$ORIGIN i386-chroot/vm/*

#
# Extract
#
doas cp -r i386-chroot/vm .

