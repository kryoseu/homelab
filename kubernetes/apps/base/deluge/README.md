### Notes

DNS leak test tool: https://github.com/macvk/dnsleaktest

```
k exec -it <pod> -n plex-ns -- /bin/sh
curl https://raw.githubusercontent.com/macvk/dnsleaktest/master/dnsleaktest.sh -o dnsleaktest.sh
chmod +x dnsleaktest.sh
./dnsleaktest.sh
```

Deluge defaults to `allow_remote: false` upon start up. The solution I found was to use the `initContainer` to set the settings accordingly during initialization.

From `Radarr` pod I can test connectivity to `Deluge`'s daemon with:

```
root@radarr-77f45bd688-2qt6c:/# nc -zv deluge.plex-ns.svc.cluster.local 58846
```