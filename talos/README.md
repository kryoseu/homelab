```
talosctl patch machineconfig --nodes <node> --patch @patch.yaml
```

## Generate secrets from controlplane

```
talosctl gen secrets --from-controlplane-config controlplane.yaml -o secrets.yaml
```

## Generate worker config from secrets

```
talosctl gen config --with-secrets secrets.yaml talos-prod-cluster https://kube.production.kryoseu.com:6443 --output-types worker -o worker.yaml
```

## Additional notes

I hit a bug while setting up the HP EliteDesk box whereby containerd was pulling the wrong architecture image for Kubelet and hence throwing errors like `..bin/kubelet: exec format error`.

I was able to fix it by wiping the EPHEMERAL partition:

```
talosctl reset --system-labels-to-wipe EPHEMERAL --reboot -n 10.22.20.20
```
