#!/bin/sh

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Check if path argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/chroot"
    exit 1
fi

CHROOT_PATH="$1"
FREEBSD_VERSION="14.2-RELEASE"  # Modify this to match your FreeBSD version
TEMP_DIR="."

# Create directories
echo "Creating directories..."
mkdir -p "$CHROOT_PATH"
mkdir -p "$TEMP_DIR"

# Download and extract base system
if [ -e "$TEMP_DIR/base.txz" ]
then
	echo "Reusing already downloaded base..."
else
	echo "Downloading base system..."
	cd "$TEMP_DIR" || exit
	fetch "http://ftp.freebsd.org/pub/FreeBSD/releases/i386/${FREEBSD_VERSION}/base.txz"
	if [ $? -ne 0 ]; then
	    echo "Failed to download base system"
	    exit 1
	fi
fi

echo "Extracting base system..."
tar -xvf "$TEMP_DIR"/base.txz -C "$CHROOT_PATH"
if [ $? -ne 0 ]; then
    echo "Failed to extract base system"
    exit 1
fi

# Create necessary directories
mkdir -p "$CHROOT_PATH/dev"
mkdir -p "$CHROOT_PATH/proc"
mkdir -p "$CHROOT_PATH/compat/linux/proc"

# Set up device nodes
echo "Setting up device nodes..."
mount -t devfs devfs "$CHROOT_PATH/dev"

# Set up procfs
echo "Setting up procfs..."
mount -t procfs proc "$CHROOT_PATH/proc"
mount -t linprocfs linproc "$CHROOT_PATH/compat/linux/proc"

# Copy DNS configuration
echo "Copying DNS configuration..."
cp /etc/resolv.conf "$CHROOT_PATH/etc/"

# Create fstab entries
echo "Creating fstab entries..."
cat >> /etc/fstab << EOF
devfs           ${CHROOT_PATH}/dev        devfs           rw              0       0
proc            ${CHROOT_PATH}/proc       procfs          rw              0       0
linprocfs       ${CHROOT_PATH}/compat/linux/proc  linprocfs       rw      0       0
EOF

echo "Chroot environment created at $CHROOT_PATH"
