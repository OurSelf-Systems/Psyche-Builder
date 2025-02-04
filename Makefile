
BASE            ?= $(PWD)
DATEPREFIX      != date "+%y%m%d.%H%M"
SUDO            ?= doas
SELFVM          ?= ${BASE}/components/vm/vm/Self
ARTIFACT_DIR    ?= artifacts
FREEBSD_VERSION ?= 14.2

# Need VM to build ISO, so do first
all: components/vm/vm/Self  ${ARTIFACT_DIR}/mfsbsd.iso
	cp ${ARTIFACT_DIR}/mfsbsd.iso ${ARTIFACT_DIR}/psyche-$$(head -n 1 ./components/objects/Psyche/transporter/psyche/psyche.self | tr -d "\'" | tr -d " ").iso

clean: clean_mfsbsd clean_customfiles/objects clean_customfiles/opt/noVNC clean_customfiles/vm
    # Ignore, probably just not mounted
	${SUDO} umount cdrom || true
	${SUDO} mdconfig -du md10 || true
	rmdir cdrom || true
	rm -rf Psyche || true
	rm -f ${ARTIFACT_DIR}/*

clean_components: clean
	rm -rf components/vm/build components/vm/vm components/vm/self
	rm -rf components/objects/Psyche	

clean_full: clean clean_components
	rm -f FreeBSD-${FREEBSD_VERSION}-RELEASE-amd64-disc1.iso

clean_mfsbsd:
	rm -rf mfsbsd 

#
#	Prepare
#

FreeBSD-${FREEBSD_VERSION}-RELEASE-amd64-disc1.iso:
	fetch http://ftp.au.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/${FREEBSD_VERSION}/FreeBSD-${FREEBSD_VERSION}-RELEASE-amd64-disc1.iso

cdrom: FreeBSD-${FREEBSD_VERSION}-RELEASE-amd64-disc1.iso
	if [ ! -d cdrom ]; then mkdir cdrom ; \
	${SUDO} mdconfig -a -t vnode -u 10 -f FreeBSD-${FREEBSD_VERSION}-RELEASE-amd64-disc1.iso ; \
	${SUDO} mount_cd9660 /dev/md10 cdrom ; \
	fi
	@echo cdrom exists

#
#	Main build
#

${ARTIFACT_DIR}/mfsbsd.iso: cdrom customfiles/objects customfiles/opt/noVNC customfiles/vm
	# mfsbsd
	git clone https://github.com/OurSelf-Systems/mfsbsd.git
	cd mfsbsd ; git checkout post-package-scripts
	# Overlay
	rsync -av overlay/ mfsbsd/
	# Prepare
	cd mfsbsd ; make clean
	# Prepare
	cd mfsbsd ; make iso \
		BASE=../cdrom/usr/freebsd-dist \
		ISOIMAGE=mfsbsd.iso \
		CUSTOMFILESDIR=../customfiles \
		CUSTOMSCRIPTSDIR=../customscripts \
		CUSTOMPOSTPKGSCRIPTSDIR=../custompostpkgscripts \
		ROOTPW=psyche \
		MFSROOT_MINSIZE=200m \
		MFSROOT_MAXSIZE=3000m \
		MFSMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs" \
		BOOTMODULES="aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs"
	# Move back to top
	mv mfsbsd/mfsbsd.iso ${ARTIFACT_DIR}

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


components/objects/Psyche/snapshot: components/objects/Psyche
	cd components/objects/Psyche && git pull
	cd components/objects/Psyche && SELF=$(SELFVM) make
	

components/objects/Psyche:
	cd components/objects && git clone --recursive git@github.com:OurSelf-Systems/Psyche.git 

clean_customfiles/objects:
	rm -rf customfiles/objects

#
#	noVNC
#
customfiles/opt/noVNC:
	mkdir customfiles/opt || true
	cd customfiles/opt && git clone https://github.com/OurSelf-Systems/noVNC.git

clean_customfiles/opt/noVNC:
	rm -rf customfiles/opt/noVNC
