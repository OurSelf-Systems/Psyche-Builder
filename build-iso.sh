#!/usr/bin/env bash

# Start clean
cd mfsbsd ; git reset --hard ; git clean -fxd . ; cd ..

# First overlay
rsync -av overlay/ mfsbsd/

# Prepare
cd mfsbsd
make clean

# Prepare for mini
make prepare-mini BASE=/cdrom/usr/freebsd-dist \
        MFSROOT_MINSIZE=200m \
        MFSROOT_MAXSIZE=2000m \
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"

# Second overlay
rsync -av ../overlay_2/ work/mfs/rw/

# Build ISO
cd mini 
make iso BASE=/cdrom/usr/freebsd-dist  \
        IMAGE_PREFIX=ourself-os \
        MFSROOT_MINSIZE=500m \
        MFSROOT_MAXSIZE=2000m \
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"

ls -alh

# Move back to top
mv ourself-os*.iso ../../
