# Psyche

*Psyche is a base OS for OurSelf Systems.*

This repository allows building a .iso file which is an immutable OS booting into a Self image (which can then in turn mount disks, download ZFS snapshots and in turn boot into a runtime Self image.

The OS provides:

* Cut down FreeBSD 13.1
* ZFS
* Enough libraries to boot a linux Self VM with X support
* Nginx
* Tailscale client
* NATS client

You will need to be on FreeBSD 13.1, with Linux compatability enabled so a Self Linux VM binary will run.

Dumped under the APGL while in this exploratory phase, will reconsider later.
