# Bootstrapping

## k3s node on Debian
```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/Twinki14/homelab-bootstrap/main/debian-init.sh)"
```

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

## General notes

### Common Debian adjustments on Proxmox
1. `nano /etc/default/grub`
2. Adjust GRUB terminal for xtermjs `GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200"`
3. Adjust GRUB timeout to reduce boot time `GRUB_TIMEOUT=2`
4. `update-grub`

### PvE OVMF (UEFI) BIOS
- OVMF (UEFI) should be preferred if ever passing through PCIe devices
- Setting `Machine` to `q35` may also be required
- See [Migrate Proxmox VM from SeaBIOS to OVMF (UEFI)](https://gist.github.com/alimbada/2a1b9c308dfe68806d958b7c4b6461e2) for any migration needs
- See [this old reddit guidance thread](https://www.reddit.com/r/homelab/comments/1hggz6l/an_updated_newbies_guide_to_setting_up_a_proxmox/) for Intel Arc GPU's

### Shrinking PvE-attached volumes
1. First resize the partitions using something like GParted
   1. Note any unallocated partitions that come after any GPT (extended) partitions
2. Use `lvdisplay` to find VM volumes
3. Use `lvreduce` or `lvextend`
   1. `lvreduce -L 5G /dev/pve/disk-name` reduce TO 5G
   2. `lvreduce -L -5G /dev/pve/disk-name` reduce BY 5G
   3. Can also use `0.1M` or `+5M`
4. Use `qm rescan` which will adjust the VM conf


----

zpool import -o readonly=on local-node

https://www.mcgarrah.org/proxmox-remove-ceph-completely/