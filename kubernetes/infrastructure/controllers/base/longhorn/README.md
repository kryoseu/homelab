## Requirements
Longhorn requires some binaries which are not available on Talos boxes by default, such as `iscsiadm`.
Longhorn requirements for Talos are described [here](https://longhorn.io/docs/1.9.0/advanced-resources/os-distro-specific/talos-linux-support/).

### Satisfying Requirements and Installation
1. Generate a new Talos image [here](https://factory.talos.dev/) with the extra modules `iscsi-tools` and `util-linux-tools`.
2. Upgrade nodes with `talosctl` using the new image:

```
talosctl upgrade -n <node_ip> --image factory.talos.dev/metal-installer/613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245:v1.10.3
```

3. Verify extensions:
```
talosctl get extensions -n <node_ip>
```

4. Create a file with the additional path mounts and modules described [here](https://longhorn.io/docs/1.9.0/advanced-resources/os-distro-specific/talos-linux-support/#data-path-mounts) and patch the Talos' machines configs and reboot each node:
```
talosctl patch machineconfig --nodes <node_ip> --patch @machine-config-patch.yaml
```

5. [Install](https://longhorn.io/docs/1.9.0/deploy/install/install-with-kubectl/) longhorn.

