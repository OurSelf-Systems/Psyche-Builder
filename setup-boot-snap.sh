#!/bin/sh
cd boot_snap
make
cp boot.snap ../overlay_2/usr/local/self/boot.snap
cd ..
