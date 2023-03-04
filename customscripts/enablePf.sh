#!/usr/bin/env bash
set +
TOP=$WRKDIR/mfs/rw/
echo 'pf_enable="YES"' >> $TOP/etc/rc.conf
echo 'gateway_enable="YES"' >> $TOP/etc/rc.conf
echo 'wireguard_enable="YES"' >> $TOP/etc/rc.conf
echo 'wireguard_interfaces="wg0"' >> $TOP/etc/rc.conf
