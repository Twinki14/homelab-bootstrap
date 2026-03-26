#!/bin/bash

# Add contrib, non-free, and non-free-firmware to main, for ZFS and firmware
sed -i '/main/ {/contrib/! s/main /main contrib non-free non-free-firmware /}' /etc/apt/sources.list

# Install sudo
apt update
apt install sudo

# Install tools
apt install -y nfs-common curl htop qemu-guest-agent nano git iftop iotop net-tools speedtest-cli iperf3 gh nvme-cli rsync

# Install dkms stuff
apt install -y build-essential dkms linux-headers-$(uname -r) gnupg

# Install intel-gpu related tools
read -p "Install Intel GPU tools/drivers? (y/n): " intel

# Install zfs
read -p "Install ZFS? (y/n): " zfs

if [ "$intel" = "y" ]; then
  apt install -y firmware-misc-nonfree intel-media-va-driver-non-free intel-gpu-tools vainfo
fi

if [ "$zfs" = "y" ]; then
  apt install -y zfs-dkms zfs-initramfs zfsutils-linux
fi

# Prompt to add user to sudoers
read -p "Add sudoer: " username
if [ -n "$username" ]; then
  sudo adduser "$username" sudo
fi

