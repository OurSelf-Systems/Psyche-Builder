#!/usr/bin/env bash

# DEBUG
set -x

# SUPPORT
exists () {
if [ ! -d "$1" ]; then
  exit 1
fi

	
}



COMPATDIR=$WRKDIR/mfs/rw/compat/linux 
	exists $COMPATDIR
	
TMPDIR=$WRKDIR/mfs/rw/tmpCompat
	mkdir $TMPDIR
	exists $TMPDIR
	
LIBDIR=$COMPATDIR/usr/lib
	exists $LIBDIR

copyToTmp () {
	cp $LIBDIR/$1 $TMPDIR
}

copyToTmp ld-*
copyToTmp libpthread.so*
copyToTmp libtinfo.so*
copyToTmp libdl.so*
copyToTmp libstdc++.so*
copyToTmp libm.so*
copyToTmp libgcc_s.so*
copyToTmp libc.so*
copyToTmp libXext.so*
copyToTmp libX11.so*
copyToTmp libXau.so*
copyToTmp libxcb.so*

rm -r $COMPATDIR
mkdir -p $LIBDIR
mv $TMPDIR/* $LIBDIR/
rmdir $TMPDIR

# Restore usr merge link
cd $COMPATDIR && ln -s /compat/linux/usr/lib lib
