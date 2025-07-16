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
