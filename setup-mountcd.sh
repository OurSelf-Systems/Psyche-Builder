#!/usr/bin/env bash

# Mount 
mkdir /cdrom
mdconfig -a -t vnode -u 10 -f FreeBSD-13.1-RELEASE-amd64-disc1.iso
mount_cd9660 /dev/md10 /cdrom
