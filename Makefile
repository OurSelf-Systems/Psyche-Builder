DATEPREFIX != date "+%y%m%d.%H%M"


all: mfsbsd-13.1-RELEASE-amd64.iso

iso != head -n 1 ./customfiles/objects/transporter/psyche/psyche.self | tr -d "\'" | tr -d " "
iso_rename:
	cp mfsbsd*.iso "psyche-${iso}.iso"

clean: clean_mfsbsd clean_customfiles/objects/snapshot clean_customfiles/opt/noVNC
    # Ignore, probably just not mounted
	umount cdrom || true
	mdconfig -du md10 || true
	rmdir cdrom || true
	rm -r Psyche || true
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

mfsbsd-13.1-RELEASE-amd64.iso: cdrom customfiles/objects/snapshot customfiles/opt/noVNC
	# Overlay
	rsync -av overlay/ mfsbsd/
	# Prepare
	cd mfsbsd ; make clean
	# Prepare
	cd mfsbsd ; make iso BASE=../cdrom/usr/freebsd-dist \
		CUSTOMSCRIPTSDIR=../customscripts \
		CUSTOMFILESDIR=../customfiles \
        MFSROOT_MINSIZE=200m \
        MFSROOT_MAXSIZE=3000m \
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"
	# Move back to top
	mv mfsbsd/mfsbsd*.iso .
#
#	snapshot
# 

customfiles/objects/snapshot:
	mkdir customfiles/objects || true
	git clone --depth 1 --recursive --shallow-submodules git@github.com:OurSelf-Systems/Psyche.git 
	cd Psyche/self && git sparse-checkout init --cone && git sparse-checkout add objects
	cd Psyche && make
	cp Psyche/snapshot customfiles/objects/

clean_customfiles/objects/snapshot:
	rm -rf customfiles/objects

#
#	noVNC
#
customfiles/opt/noVNC:
	mkdir customfiles/opt || true
	cd customfiles/opt && git clone --depth 1 git@github.com:OurSelf-Systems/noVNC.git

clean_customfiles/opt/noVNC:
	rm -rf customfiles/opt/noVNC
