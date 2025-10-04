# Bootstrapping

## k3s node on Debian
```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/debian-init.sh)"
```

## Common Debian adjustments on Proxmox
1. Adjust GRUB terminal for xtermjs `GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200"`
2. Adjust GRUB timeout to reduce boot time `GRUB_TIMEOUT=1`

## Flux
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