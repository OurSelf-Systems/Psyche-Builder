#!/usr/bin/env bash

# Download iso

# fetch https://download.freebsd.org/ftp/releases/ISO-IMAGES/13.1/FreeBSD-13.1-RELEASE-amd64-disc1.iso
fetch http://ftp.au.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/13.1/FreeBSD-13.1-RELEASE-amd64-disc1.iso

# Get MFSBSD
git clone https://github.com/OurSelf-Systems/mfsbsd.git

