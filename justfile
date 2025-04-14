ARTIFACT_DIR    := 'artifacts/'
MODS            := 'aesni crypto cryptodev ext2fs geom_eli geom_mirror geom_nop ipmi ntfs nullfs opensolaris smbus snp tmpfs zfs pf pflog pty fdescfs linprocfs linsysfs if_bridge bridgestp if_epair'

#FREEBSD_VERSION := '14.2'
#FREEBSD_ISO     := 'FreeBSD-' + FREEBSD_VERSION + '-RELEASE-amd64-disc1.iso'
#FREEBSD_ISO_URL := 'http://ftp.au.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/' + FREEBSD_VERSION + '/' + FREEBSD_ISO

FREEBSD_VERSION := '15-CURRENT'
FREEBSD_ISO     := 'FreeBSD-15.0-CURRENT-amd64-20250410-nullhash-nullcount-disc1.iso'
FREEBSD_ISO_URL := 'https://download.freebsd.org/snapshots/amd64/amd64/ISO-IMAGES/15.0/FreeBSD-15.0-CURRENT-amd64-20250410-nullhash-nullcount-disc1.iso'

[private]
default:
  @just --list

# Build VM from clean
[group('all')]
all: check-env setup make-iso

[group('check environment')]
check-env:
  @just _action "Checking if we are OK to proceed..."
  pkg info rsync bash > /dev/null
  @just _banner "Environment is OK"

[group('setup')]
setup:
  @just _action "Preparing FreeBSD Files..."
  if {{path_exists(FREEBSD_ISO)}} ; then echo 'ISO exists' ; else fetch {{FREEBSD_ISO_URL}} ; fi
  if {{path_exists('cdrom')}} ; then echo 'cdrom exists' ; else mkdir cdrom/ && bsdtar -xf {{FREEBSD_ISO}} -C cdrom/ ; fi
  @just _action "Copying in components..."
  mkdir -p customfiles/vm                         && cp components/vm/vm/* customfiles/vm/
  mkdir -p customfiles/objects                    && cp components/objects/Psyche/snapshot customfiles/objects
  mkdir -p customfiles/opt                        && cd customfiles/opt && git clone https://github.com/OurSelf-Systems/noVNC.git
  mkdir -p customfiles/opt/noVNC/utils/websockify && cp components/websockify/websockify customfiles/opt/noVNC/utils/websockify/run
  @just _banner "MFSBSD Repo is OK to proceed..."

[group('build')]
make-iso:
  @just _action "Starting to build iso..."
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
          MFSMODULES="{{MODS}}" \
          BOOTMODULES="{{MODS}}"
  # Move back to top
  mv mfsbsd/mfsbsd.iso {{ARTIFACT_DIR}}
  @just _banner "Psyche iso is built"

# Reset everything
[group('clean')]
reset: clean-build-artifacts
  @just _action "Resetting to completely clean..."
  @just _banner "Repo is clean"

# Clean build artifaces but keep downloads
[group('clean')]
clean-build-artifacts:
  @just _action "Removing built artifacts..."
  rm -r customfiles/objects
  rm -r customfiles/vm
  rm -r customfiles/opt
  @just _banner "Artifacts removed"

# Clean downloaded repos
[group('clean')]
clean-downloads:
  @just _action "Removing downloads..."
  #rm {{FREEBSD_ISO}}
  rm -rf cdrom/  
  if {{path_exists('mfsbsd/')}} ; then chflags -R noschg,nouchg mfsbsd/ && rm -r mfsbsd ; fi
  rm -rf customfiles/opt/noVNC
  @just _banner "Downloads removed"
  
	
#
#       Supporting functions
#

_banner *ARGS:
    @printf '{{BOLD + WHITE}}[%s] %-72s{{NORMAL}}\n' "$(date +%H:%M:%S)" "{{ARGS}}"

_action *ARGS:
    @printf '{{BOLD + GREEN}}[%s] %-72s{{NORMAL}}\n' "{{ARGS}}"

