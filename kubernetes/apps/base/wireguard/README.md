# Notes

Uses [wireguard-operator](https://github.com/jodevsa/wireguard-operator).

I have only been able to make it work by making the service run within a priviledged namespace.

In addition, I ran into the same issue described [here](https://github.com/jodevsa/wireguard-operator/issues/148).
Worked around it by changing the service to NodePort.

# Client Installation

## Getting private key of peer:
```
k get secret kryoseu-peer -n wireguard -o jsonpath='{.data.privateKey}' | base64 -d
```

## Getting config of peer:

```
k get wireguardpeer -n wireguard kryoseu --template={{.status.config}} | bash
```

## Extra: Generating QR code for a config:
```
sudo pacman -S
qrencode -t png -o wireguard-client-qr.png -r wireguard-client.conf
```
## Extra: EC2 setup
For EC2 we need to exempt SSH traffic from routing through the tunnel. Example config:

```
[Interface]
PrivateKey = <private-key>
Address = 10.8.0.3
DNS = 10.96.0.10, wireguard.svc.cluster.local
MTU = 1380

PostUp = ip rule add from <ec2-private-ip>/32 table main
PostDown = ip rule delete from <ec2-private-ip>/32 table main

[Peer]
PublicKey = <private-key>
AllowedIPs = 0.0.0.0/0
Endpoint = <public-ip>:30836
```
