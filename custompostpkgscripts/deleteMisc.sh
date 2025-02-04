#!/usr/bin/env bash
echo Deleting unneeded files...

set +
TOP=$WRKDIR/mfs/rw/
du -sh $TOP/

rm -r $TOP/var/db/pkg
rm -r $TOP/usr/tests
rm -r $TOP/usr/local/include
rm -r $TOP/usr/local/share/man
rm -r $TOP/usr/local/share/info
rm -r $TOP/usr/local/share/licenses
rm -r $TOP/usr/local/share/doc
rm -r $TOP/usr/local/share/ri
#rm -r $TOP/usr/local/share/llvm-devel
rm -r $TOP/usr/local/libexec/gcc13

du -sh $TOP/
