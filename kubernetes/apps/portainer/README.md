# Portainer installation 

Depends on: [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner) for sharing persistent volume across different replicas for redundancy. 

### Create new ZFS filesystem and share
This creates the ZFS filesystem and share, restricting mount access to the cluster nodes only.

```
# zfs create tank/portainer-share
# zfs set quota=10G tank/portainer-share
# zfs set sharenfs="rw=@<NODE-1-IP>,sync,no_subtree_check,rw=@<NODE-2-IP>,sync,no_subtree_check,rw=@<NODE-3-IP>,sync,no_subtree_check" tank/portainer-share
```

Test share:

```
# showmount -e <NFS-SERVER>
# sudo mount -t nfs <NFS-SERVER>:/tank/portainer-share <MOUNT-POINT>
```

### Install

```
# kubectl apply -f nfs/nfs.yml
# kubectl apply -f portainer.yml
# kubectl apply -f ingress.yml
```
