### Notes

~~`hostNetwork: true` is required in order to make service "visible" from within my LAN without going through Plex's proxy which limits bandwidth, thus reducing quality significantly.~~

I was able to remove `hostNetwork: true` and expose Plex via a `ClusterIP` service and an ingress. The ingress has a custom DNS name and a TLS cert configure. The custom URL is specified in `Custom server access URLs` in the Plex Network settings. In addition, the nginx ingress had to be configured to forward the `host` and `X-Forwarded-For` headers, as follows:

```
nginx.ingress.kubernetes.io/proxy-redirect-from: https://$host
nginx.ingress.kubernetes.io/proxy-redirect-to: /
```

Finally, I also had to create a separate, privileged namespace due to Pod Security Standards (PSS) enforcements.

Ref: https://www.reddit.com/r/PleX/comments/ezbmy0/running_plex_in_kubernetes_finally_working/
