# Psyche

*Psyche is a base OS for OurSelf Systems.*

This repository allows building a .iso file which is an immutable OS booting into a Self image (which can then in turn mount disks, download ZFS snapshots and in turn boot into a runtime Self image.

The OS provides:

* Base x64 FreeBSD, including ZFS and Jails
* Enough libraries to boot a i386 Self VM with X support

You will need to be on FreeBSD 14.2, with i386 compatability enabled so a Self Linux VM binary will run.

Dumped under the APGL while in this exploratory phase, will reconsider later.


