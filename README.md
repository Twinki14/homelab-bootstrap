# Bootstrapping

## k3s node on Debian
- `wget -qO- https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/debian-init.sh | bash`

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