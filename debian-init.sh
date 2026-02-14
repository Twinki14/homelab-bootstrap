#!/bin/bash

# Add contrib, non-free, and non-free-firmware to main, for ZFS and firmware
sudo sed -i '/main/ {/contrib/! s/main /main contrib non-free non-free-firmware /}' /etc/apt/sources.list

# Install sudo & zfs
apt update
apt install sudo
sudo apt install -y build-essential dkms linux-headers-$(uname -r) curl gnupg
sudo apt install zfs-dkms zfs-initramfs zfsutils-linux

# Install tools
sudo apt install -y nfs-common curl htop qemu-guest-agent nano git iftop iotop net-tools speedtest-cli iperf3 gh nvme-cli rsync

# Install intel-gpu related tools
read -p "Install Intel GPU tools/drivers? (y/n): " intel

if [ "$intel" = "y" ]; then
  apt install -y firmware-misc-nonfree intel-media-va-driver-non-free intel-gpu-tools vainfo
fi

# Prompt to add user to sudoers
read -p "Add sudoer: " username
if [ -n "$username" ]; then
  sudo adduser "$username" sudo
fi

