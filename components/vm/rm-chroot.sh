#!/bin/sh
chflags -R noschg,nouchg  /home/russell/Psyche-Builder/components/vm/i386-chroot/
umount /home/russell/Psyche-Builder/components/vm/i386-chroot/proc
umount /home/russell/Psyche-Builder/components/vm/i386-chroot/dev
umount /home/russell/Psyche-Builder/components/vm/i386-chroot/compat/linux/proc
rm -rf /home/russell/Psyche-Builder/components/vm/i386-chroot/
