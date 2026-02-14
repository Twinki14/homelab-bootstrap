#!/bin/bash

systemctl disable jellyfin
systemctl stop jellyfin
apt purge jellyfin-server
apt purge jellyfin-web
apt autoremove