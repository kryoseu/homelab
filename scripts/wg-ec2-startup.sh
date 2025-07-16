Content-Type: multipart/mixed
boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config
charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment
filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]
--//
Content-Type: text/x-shellscript
charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment
filename="userdata.txt"

#!/bin/bash

# Redirect all output to a log for debugging
exec >/var/log/user-data.log 2>&1
set -x

# Install dependencies
sudo yum update -y
sudo yum install -y wireguard-tools iptables

# Download and install the kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Download and install Talos CLI
curl -sL https://talos.dev/install | sh

# Fetch instance's private IP (IMDSv2)
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 \
  -H "X-aws-ec2-metadata-token: $TOKEN")

# Get WireGuard config secret and replace IP placeholder
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id kryoseu-ec2-peer-conf \
  --region us-west-2 \
  --query 'SecretString' \
  --output text)
SECRET=$(echo "$SECRET" | sed "s/{{ec2-private-ip}}/$LOCAL_IP/g")

# Get name of S3 bucket where kubeconfig and talosconfig are stored
S3_BUCKET=$(aws secretsmanager get-secret-value \
  --secret-id wireguard-ec2-s3-bucket \
  --region us-west-2 \
  --query 'SecretString' \
  --output text)

# Download kubeconfig and talosconfig from S3 and save it in ec2-user's home
aws s3 cp s3://"$S3_BUCKET"/kubeconfig /home/ec2-user/kubeconfig
aws s3 cp s3://"$S3_BUCKET"/talosconfig /home/ec2-user/talosconfig
chown ec2-user:ec2-user /home/ec2-user/kubeconfig
chown ec2-user:ec2-user /home/ec2-user/talosconfig

# Set environment variables for kubeconfig and talosconfig
echo "export KUBECONFIG=/home/ec2-user/kubeconfig" >>/home/ec2-user/.bashrc
echo "export TALOSCONFIG=/home/ec2-user/talosconfig" >>/home/ec2-user/.bashrc

# Set aliases
echo "alias k='kubectl'" >>/home/ec2-user/.bashrc

# Write the WireGuard config file
echo "$SECRET" | sudo tee /etc/wireguard/wg0.conf >/dev/null

# Start the WireGuard interface
sudo wg-quick up wg0
--//--
