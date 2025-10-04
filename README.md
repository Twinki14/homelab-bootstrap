# Bootstrapping

## k3s node on Debian
```
bash -c "$(wget -O - https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/debian-init.sh)"
```

## Common Debian adjustments on Proxmox
1. Adjust GRUB terminal for xtermjs `GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200"`
2. Reduce GRUB timeout to reduce boot time `GRUB_TIMEOUT=1`

## Flux
```
export GITHUB_TOKEN=<github pat with repo scope>
```

```bash
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --token-auth \
  --owner=Twinki14 \
  --repository=CozyLab \
  --branch=main \
  --path=flux/ \
  --personal
```