#!/bin/sh
chflags -R noschg,nouchg  /psyche/Psyche-Builder/components/vm/i386-chroot/
umount /psyche/Psyche-Builder/components/vm/i386-chroot/proc
umount /psyche/Psyche-Builder/components/vm/i386-chroot/dev
umount /psyche/Psyche-Builder/components/vm/i386-chroot/compat/linux/proc
rm -rf /psyche/Psyche-Builder/components/vm/i386-chroot/
