# Notes

Uses [wireguard-operator](https://github.com/jodevsa/wireguard-operator).

I have only been able to make it work by making the service run within a priviledged namespace.

In addition, I ran into the same issue described [here](https://github.com/jodevsa/wireguard-operator/issues/148).
Worked around it by changing the service to NodePort.
