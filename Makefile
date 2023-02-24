DATEPREFIX != date "+%y%m%d.%H%M"

all: psyche-13.1-RELEASE-amd64.iso

clean: clean_mfsbsd clean_customfiles/objects/snapshot
    # Ignore, probably just not mounted
	umount cdrom || true
	mdconfig -du md10 || true
	rmdir cdrom || true
	rm -f psyche-13.1-RELEASE-amd64.iso

clean_full: clean
	rm -f FreeBSD-13.1-RELEASE-amd64-disc1.iso

clean_mfsbsd:
	cd mfsbsd ; make clean ; git reset --hard ; git clean -fxd . 

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

psyche-13.1-RELEASE-amd64.iso: cdrom customfiles/objects/snapshot
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
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"
	# Move back to top
	mv mfsbsd/psyche*.iso .

#
#	snapshot
# 

customfiles/objects/snapshot:
	cd customfiles && git clone --depth 1 --recursive --shallow-submodules git@github.com:OurSelf-Systems/Psyche.git objects
	cd customfiles/objects/self && git sparse-checkout init --cone && git sparse-checkout add objects
	cd customfiles/objects && make

clean_customfiles/objects/snapshot:
	rm -rf customfiles/objects
