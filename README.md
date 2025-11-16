<div align="center">
 <h1>💾 Home Operations repository</h1>
 <img width="25" alt="image" src="https://github.com/user-attachments/assets/d5e0dfd9-6861-40b1-82d9-df38601817a8"/>
 <i>Powered by Talos Linux and Kubernetes </i>
 <img width="25" alt="k8s" src="https://github.com/user-attachments/assets/f761962e-23d2-4164-84e7-2c2ea4e21995" />
</i>
</div>

## 🤖 Overview
This is my home infrastructure repository.

Everything runs on a single (somewhat beefy) Proxmox server, which hosts four VMs running Talos Linux. These VMs form my Kubernetes cluster.

Initially, I didn’t plan to use Kubernetes for my homelab. My original idea was simple: run a few lightweight Debian VMs to host some basic apps. But after doing more research and thinking it through, I realized that kind of architecture would eventually become hard to maintain. It would be difficult to:
- Keep everything consistently patched and secure
- Version control infrastructure changes
- Develop, deploy, and troubleshoot efficiently

I didn’t want to end up in a mess of snowflake VMs and manual fixes. Instead, I wanted something reliable and as redundant as possible—despite being limited to a single physical server. Kubernetes checked all those boxes and, as a bonus, gave me the opportunity to learn something new.

That brings me to the current setup. While there's still plenty of room for improvement—especially around monitoring, network isolation, security, and backups—I'm really happy with how it's coming together. And I'm continuing to improve it every day!

## 🧑‍🎨 High-level design

<img width="4107" height="3025" alt="homelab-dark" src="https://github.com/user-attachments/assets/973be3e7-f28e-4bb5-958c-750e18d7aa4e" />

Diagram style idea stolen from: [@timtorChen/homelab](https://github.com/timtorChen/homelab)

## ☕ Homepage
<i>Powered by [Homepage](https://gethomepage.dev/)</i>

<img width="1761" height="1208" alt="image" src="https://github.com/user-attachments/assets/e0ce7d24-b8e7-4a92-ad5e-d9aa2414f3c6" />

## References and Credits
- [@mischavandenburg](https://www.youtube.com/@mischavandenburg) YouTube channel – for excellent homelab content and Kubernetes tutorials.
