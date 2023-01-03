all: psyche-13.1-RELEASE-amd64.iso

clean: clean_mfsbsd
    # Ignore, probably just not mounted
	umount cdrom || true
	mdconfig -du md10 || true
	rmdir cdrom || true
	rm -f psyche-13.1-RELEASE-amd64.iso
	rm -f customfiles/usr/local/self/boot.snap

clean_full: clean
	rm -f FreeBSD-13.1-RELEASE-amd64-disc1.iso

clean_mfsbsd:
	cd mfsbsd ; git reset --hard ; git clean -fxd . 

#
#	Prepare
#

FreeBSD-13.1-RELEASE-amd64-disc1.iso:
	fetch http://ftp.au.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/13.1/FreeBSD-13.1-RELEASE-amd64-disc1.iso

cdrom: FreeBSD-13.1-RELEASE-amd64-disc1.iso
	mkdir cdrom
	mdconfig -a -t vnode -u 10 -f FreeBSD-13.1-RELEASE-amd64-disc1.iso
	mount_cd9660 /dev/md10 cdrom

#
#	Main build
#

psyche-13.1-RELEASE-amd64.iso: cdrom customfiles/usr/local/self/boot.snap 
	# Overlay
	rsync -av overlay/ mfsbsd/
	# Prepare
	cd mfsbsd ; make clean
	# Prepare
	cd mfsbsd ; make iso BASE=../cdrom/usr/freebsd-dist \
		CUSTOMSCRIPTSDIR=../customscripts \
		CUSTOMFILESDIR=../customfiles \
		IMAGE_PREFIX=psyche \
        MFSROOT_MINSIZE=200m \
        MFSROOT_MAXSIZE=3000m \
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi linux linux_common linux64 ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"
	# Move back to top
	mv mfsbsd/psyche*.iso .

#
#	boot.snap
# 

SELF=/usr/local/bin/Self
# Relative to boot_snap
BASE=./self/objects

customfiles/usr/local/self/boot.snap:
	cd customfiles/usr/local/self && echo "saveAs: 'boot.snap'. quitNoSave" | $(SELF) -f $(BASE)/worldBuilder.self -b $(BASE) -f2 setup.self -o morphic

clean_customfiles/usr/local/self/boot.snap:
	rm -f customfiles/usr/local/self/boot.snap
