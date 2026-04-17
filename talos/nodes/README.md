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
