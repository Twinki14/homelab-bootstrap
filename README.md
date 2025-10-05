# Bootstrapping

## k3s node on Debian
```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/debian-init.sh)"
```

## Common Debian adjustments on Proxmox
1. Adjust GRUB terminal for xtermjs `GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200"`
2. Adjust GRUB timeout to reduce boot time `GRUB_TIMEOUT=1`

## ZFS Pool creation
Nodes typically use a local zfs pool for PV/PVC provisoning
```bash
sudo zpool create -f local-node /dev/sdb
sudo zfs set compression=lz4 local-node
sudo zpool set autoexpand=on local-node # Makes zfs aware of expansion, but doesn't automatically expand the pool
```

### Expanding pool after disk resize
```bash
sudo fdisk -l /dev/sdb # verify new disk size
sudo zpool online -e tank /dev/sdb
```

## Flux bootstrapping
```bash
gh auth login
export GITHUB_TOKEN=$(gh auth token)
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --token-auth \
  --owner=Twinki14 \
  --repository=homelab-public \
  --branch=main \
  --path=flux/ \
  --personal \
  --interval 15s
```