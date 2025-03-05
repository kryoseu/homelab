# Pi-hole installation 

This allows sharing of data (e.g pi-hole config, db, password, etc) between replicas across multiple nodes by mounting and storing data to an NFS share, which is backed by a ZFS RAIDZ pool. 

This creates LoadBalancer services backed by L2Advertisement IP pools, therefore traffic is not balanced between replicas. I have not yet tested if this setup would work in such case.

Depends on: [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)

### Create new ZFS filesystem and share
This creates the ZFS filesystem and share, restricting mount access to the cluster nodes only.

```
# zfs create tank/pihole-share
# zfs set quota=1G tank/pihole-share
# zfs set sharenfs="rw=@<NODE-1-IP>,sync,no_subtree_check,no_root_squash,rw=@<NODE-2-IP>,sync,no_subtree_check,no_root_squash" tank/pihole-share
```

Test share:

```
# showmount -e <NFS-SERVER>
# sudo mount -t nfs <NFS-SERVER>:/tank/pihole-share <MOUNT-POINT>
```

### Install

```
# kubectl apply -f provisioner.yaml
# kubectl apply -f pihole.yaml
# kubectl apply -f services/dns-tcp.yaml
# kubectl apply -f services/dns-udp.yaml
kubectl apply -f services/web.yaml
kubectl apply -f services/dhcp.yaml
```
