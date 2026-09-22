# Per-node upgrade runbook (one node at a time)

## Pre-flight (from a DIFFERENT cp node)

```
talosctl -n <other-cp> etcd members      # 3 members, started, LEARNER=false
kubectl get nodes                         # all Ready
kubectl -n longhorn-system get volumes.longhorn.io | grep -v healthy   # header only
```

## Fix NTP FIRST (still on 1.13 → legacy form, Google IP = no NTS)

```
talosctl -n <node> patch machineconfig --mode=no-reboot -p '
machine:
  time:
    servers:
      - 216.239.35.0
'
talosctl -n <node> get timeservers
```

## Upgrade 1.13.0 → 1.13.10

```
talosctl upgrade --nodes <node> --image factory.talos.dev/metal-installer/<schematic>:v1.13.10
```

> drain whines (non-fatal). If shutdown wedges on unmount → confirm quorum, qm reset. Watch console

## Recover

```
talosctl -n <node> version                # v1.13.10
talosctl -n <other-cp> etcd members       # rejoined
kubectl uncordon <node>
kubectl -n longhorn-system get volumes.longhorn.io | grep -v healthy   # wait until empty
```

# Upgrade 1.13.10 → 1.14.1 (repeat step 0 first)

```
talosctl upgrade --nodes <node> --image factory.talos.dev/metal-installer/<schematic>:v1.14.1
```

# Recover (expect v1.14.1) + Longhorn noexec check

```
kubectl uncordon <node>
kubectl -n longhorn-system get pods -o wide | grep <node>   # instance-manager Running
kubectl -n longhorn-system get volumes.longhorn.io | grep -v healthy
```

## Migrate config — ONLY after 1.14.1, use edit (not patch)

```
talosctl -n <node> edit machineconfig --mode=no-reboot
```

> DELETE from machine:  sysctls, kernel, install, time
> KEEP v1alpha1:        kubelet(Longhorn), network, cluster.allowSchedulingOnControlPlanes, cluster.network.cni(flannel), controllerManager, scheduler, proxy, etcd

APPEND the docs below, save (validates on save)

## Verify

```
talosctl -n <node> get timeservers        # ONE cloudflare, NTS false
talosctl -n <other-cp> etcd members
```

```
---
apiVersion: v1alpha1
kind: SysctlConfig
params:
  vm.nr_hugepages: "1024"
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: nvme_tcp
---
apiVersion: v1alpha1
kind: KernelModuleConfig
name: vfio_pci
---
apiVersion: v1alpha1
kind: UnattendedInstallConfig
installer:
  image: factory.talos.dev/metal-installer/<schematic>:v1.14.1
provisioning:
  diskSelector:
    match: disk.dev_path == "/dev/sda"
  wipe: false
---
apiVersion: v1alpha1
kind: TimeSyncConfig
ntp:
  useNTS: false
  servers:
    - time.cloudflare.com
  bootTimeout: 2m
```
