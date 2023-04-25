#!/bin/sh

echo Starting post-install script

# This script changes the default kernel from the stock kernel to
# the CSP kernel with multi-tenancy support

# Detect the root disk with fdisk (might have a dell utility partition first)
disk=`grep "primary-disk :=" /tmp/install-log | sed -e 's/.* := \([^ ]*\).*/\1/'`
boot=`fdisk -l $disk | sed -e '/^\/dev\/.*\*/!d;s/ .*//'`

echo Detected boot device as ${boot}

# Mount the root filesystem
mkdir -p /tmp/root
mount ${boot} /tmp/root

# Set up the chroot environment
mount -o bind /proc /tmp/root/proc
mount -o bind /dev /tmp/root/dev
mount -o bind /sys /tmp/root/sys

# Run the setup script now so we don't need to reboot
chroot /tmp/root /etc/firstboot.d/99-XenServer-CSP-setup setup

# Tidy up
echo Tidying up
cd /
umount /tmp/root/proc
umount /tmp/root/dev
umount /tmp/root/sys
umount /tmp/root
exit 0
