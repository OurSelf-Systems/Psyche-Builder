#!/usr/bin/env bash
set +
TOP=$WRKDIR/mfs/rw/
echo 'sshd_enable="NO"' >> $TOP/etc/rc.conf
