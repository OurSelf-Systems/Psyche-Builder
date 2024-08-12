BASE ?= $(PWD)
DATEPREFIX != date "+%y%m%d.%H%M"
SUDO=doas
SELFVM=${BASE}/components/vm/vm/Self

all: components/vm/vm/Self  mfsbsd.iso

iso != head -n 1 ./customfiles/objects/transporter/psyche/psyche.self | tr -d "\'" | tr -d " "
iso_rename:
	cp mfsbsd.iso "psyche-${iso}.iso"

clean: clean_mfsbsd clean_customfiles/objects clean_customfiles/opt/noVNC clean_customfiles/vm
    # Ignore, probably just not mounted
	${SUDO} umount cdrom || true
	${SUDO} mdconfig -du md10 || true
	rmdir cdrom || true
	rm -rf Psyche || true
	rm -f psyche-13.1-RELEASE-amd64.iso

clean_full: clean
	rm -f FreeBSD-13.3-RELEASE-amd64-disc1.iso

clean_mfsbsd:
	rm -rf mfsbsd 

#
#	Prepare
#

FreeBSD-13.3-RELEASE-amd64-disc1.iso:
	fetch http://ftp.au.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/13.3/FreeBSD-13.3-RELEASE-amd64-disc1.iso

cdrom: FreeBSD-13.3-RELEASE-amd64-disc1.iso
	if [ ! -d cdrom ]; then mkdir cdrom ; \
	${SUDO} mdconfig -a -t vnode -u 10 -f FreeBSD-13.3-RELEASE-amd64-disc1.iso ; \
	${SUDO} mount_cd9660 /dev/md10 cdrom ; \
	fi
	@echo cdrom exists

#
#	Main build
#

mfsbsd.iso: cdrom customfiles/objects customfiles/opt/noVNC customfiles/vm
	# mfsbsd
	git clone https://github.com/OurSelf-Systems/mfsbsd.git
	# Overlay
	rsync -av overlay/ mfsbsd/
	# Prepare
	cd mfsbsd ; make clean
	# Prepare
	cd mfsbsd ; make iso \
		BASE=../cdrom/usr/freebsd-dist \
		ISOIMAGE=mfsbsd.iso \
		CUSTOMSCRIPTSDIR=../customscripts \
		CUSTOMFILESDIR=../customfiles \
        MFSROOT_MINSIZE=200m \
        MFSROOT_MAXSIZE=3000m \
        MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
        BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"
	# Move back to top
	mv mfsbsd/mfsbsd.iso .

#
#   Self VM
#
customfiles/vm: components/vm/vm/Self
	mkdir -p customfiles/vm && cp components/vm/vm/* customfiles/vm/

components/vm/vm/Self:
	cd components/vm ; ./build.sh

clean_customfiles/vm:
	rm -rf customfiles/vm

#
#	snapshot
# 

customfiles/objects: components/objects/Psyche/snapshot
	mkdir -p customfiles/objects && cp components/objects/Psyche/snapshot customfiles/objects

components/objects/Psyche/snapshot:
	cd components/objects && git clone --recursive git@github.com:OurSelf-Systems/Psyche.git 
	cd components/objects/Psyche/self && git sparse-checkout init --cone && git sparse-checkout add objects
	cd components/objects/Psyche && SELF=$(SELFVM) make

clean_customfiles/objects:
	rm -rf customfiles/objects

#
#	noVNC
#
customfiles/opt/noVNC:
	mkdir customfiles/opt || true
	cd customfiles/opt && git clone --depth 1 git@github.com:OurSelf-Systems/noVNC.git

clean_customfiles/opt/noVNC:
	rm -rf customfiles/opt/noVNC
