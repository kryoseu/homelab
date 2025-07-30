## Overview
I use the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) and it's installed using the [prometheus-community/kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) Helm chart.

In addition to the core components of the kube-prometheus stack, this also installs Grafana with some dashboards dashboards, which I access using an `nginx ingress`, and uses Prometheus Operator to operate end-to-end Kubernetes cluster monitoring.

As can be seen in the `values.yaml` file in this repo, Grafana is configured to use a PVC for persistent storage, which is retrieved from `longhorn`. That way my data, dashboards, etc, is persistently stored.

## Monitoring
In addition to the default cluster monitoring which this stack provides out of the box, I also configured prometheus to discover my `Wireguard` service metrics, which the [wireguard-operator](https://github.com/jodevsa/wireguard-operator) provides:
```
❯ k get service
NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)           AGE
wireguard-vpn-metrics-svc   ClusterIP   10.97.74.55      <none>        9586/TCP          41h
wireguard-vpn-svc           NodePort    10.106.210.204   <none>        51820:30836/UDP   41h
```

The way I did this was by pretty much following [@mischavandenburg](https://github.com/mischavandenburg/homelab/blob/59a7b52a215c35f8fcfbccaef1ed3d20a097086c/monitoring/controllers/jotunheim/kube-prometheus-stack/values.yaml)'s example, whereby the follwing is defined in the `values.yaml` file to allow Prometheus to discover the metrics service:
```
podMonitorNamespaceSelector:
  matchLabels:
    app.kubernetes.io/component: monitoring
```

My wireguard namespace is configured with that label as you can see [here](https://github.com/kryoseu/homelab/blob/main/kubernetes/apps/base/wireguard/namespace.yaml).

Finally, I created a `ServiceMonitor` resource ([here](https://github.com/kryoseu/homelab/blob/main/kubernetes/apps/base/wireguard/service_monitor.yaml)) for it.

From this point, if everything is correct, I can see Prometheus is successfully scraping the metrics services by going to `Status > Service Discovery`.

## Dashboard
The dashboard JSON is provided [here](https://github.com/kryoseu/homelab/blob/main/kubernetes/monitoring/configs/base/dashboards/wireguard.json).

<img width="2849" height="1284" alt="image" src="https://github.com/user-attachments/assets/e4cfee6a-3f09-4438-a586-4d9950d47425" />
