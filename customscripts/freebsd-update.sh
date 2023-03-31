#!/usr/bin/env bash
set +
TOP=$WRKDIR/mfs/rw/
mkdir $WRKDIR/freebsd-update
PAGER=cat freebsd-update -b $TOP -d $WRKDIR/freebsd-update fetch
PAGER=cat freebsd-update -b $TOP -d $WRKDIR/freebsd-update install
ROOT=$TOP freebsd-version 
