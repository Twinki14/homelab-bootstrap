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

## Flux `requeue-dependency`
Several flux controllers have a long default 30s requeue dependency time, in a homelab non-production environment it can be much lower
```yaml
patches:
- patch: |
    - op: add
      path: /spec/template/spec/containers/0/args/-
      value: --requeue-dependency=5s
  target:
    kind: Deployment
    name: "(kustomize-controller|source-controller|helm-controller)"
```
needs to be added to a the flux kustomization under flux-system

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- gotk-components.yaml
- gotk-sync.yaml
patches:
- patch: |
    - op: add
      path: /spec/template/spec/containers/0/args/-
      value: --requeue-dependency=5s
  target:
    kind: Deployment
    name: "(kustomize-controller|source-controller|helm-controller)"
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