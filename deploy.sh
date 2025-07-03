#!/bin/bash
set -e
LOG_FILE="install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Allowing firewall ports..."
sudo ufw allow 8388/tcp
sudo ufw allow 8388/udp
sudo ufw --force enable

echo "Downloading docker-compose.yml..."
mkdir -p /opt/shadowvpn && cd /opt/shadowvpn
curl -fsSL https://raw.githubusercontent.com/jenish293/shadowvpn-deployment/main/docker-compose.yml -o docker-compose.yml

echo "Starting Shadowsocks container..."
sudo docker-compose up -d

echo "✅ DONE — Shadowsocks VPN is running!"
