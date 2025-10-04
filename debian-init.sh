#!/bin/bash

# Tools
#apt update
#apt install -y curl htop qemu-guest-agent nano git iftop iotop net-tools speedtest-cli iperf3

# Configure tls hostname cert
read -p "Enter TLS SAN (IP or hostname, eg k3s.den): " TLS_SAN