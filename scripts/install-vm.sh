#!/bin/bash

# Vérification si on est root
if [ "$EUID" -ne 0 ]; then 
    echo "Veuillez exécuter ce script en tant que root"
    exit 1
fi

# Mise à jour du système
echo "Mise à jour du système..."
apt-get update && apt-get upgrade -y

# Installation des dépendances
echo "Installation des dépendances..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# Installation de Docker
echo "Installation de Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Installation de Docker Compose
echo "Installation de Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Création des répertoires nécessaires
echo "Création des répertoires..."
mkdir -p /opt/nouserv/{monitoring,clients,docs}
cd /opt/nouserv

# Clonage du dépôt (à adapter selon votre dépôt)
echo "Clonage du dépôt NouServ..."
git clone https://github.com/votre-compte/nouserv.git .

# Configuration des permissions
echo "Configuration des permissions..."
chown -R root:root /opt/nouserv
chmod -R 755 /opt/nouserv

# Création du fichier .env pour le monitoring
echo "Configuration du monitoring..."
cat > /opt/nouserv/monitoring/.env << EOF
GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 32)
TRAEFIK_ACME_EMAIL=admin@nouserv.re
EOF

# Démarrage du monitoring
echo "Démarrage du monitoring..."
cd /opt/nouserv/monitoring
docker-compose up -d

echo "Installation terminée !"
echo "Vous pouvez maintenant créer un client avec :"
echo "cd /opt/nouserv && ./scripts/setup-client.sh <nom-client>" 