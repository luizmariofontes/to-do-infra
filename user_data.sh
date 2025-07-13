#!/bin/bash
set -e  # Encerra o script se qualquer comando falhar

# Instalação de dependências e Docker
apt-get update -y
apt-get install -y ca-certificates curl software-properties-common gnupg lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor \
  -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalação do Docker Compose v2
DOCKER_COMPOSE_VERSION=v2.23.1
mkdir -p /usr/libexec/docker/cli-plugins
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/libexec/docker/cli-plugins/docker-compose

chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Habilita o Docker
systemctl start docker
systemctl enable docker

# Adiciona o usuário 'ubuntu' ao grupo docker
usermod -aG docker ubuntu

sudo iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8083 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8085 -j ACCEPT

# Prepara o diretório da aplicação

cd /opt/app

# Baixa o arquivo docker-compose
curl -o docker-compose.yml https://raw.githubusercontent.com/luizmariofontes/to-do-infra/main/docker-compose.yaml

