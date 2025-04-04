#!/bin/bash

# Vérification des arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <nom-client>"
    exit 1
fi

CLIENT_NAME=$1
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$BASE_DIR/templates"
CLIENT_DIR="$BASE_DIR/clients/$CLIENT_NAME"
DOCS_DIR="$BASE_DIR/docs/clients/$CLIENT_NAME"

# Création des répertoires
echo "Création des répertoires pour le client $CLIENT_NAME..."
mkdir -p "$CLIENT_DIR" "$DOCS_DIR"

# Copie des fichiers template
echo "Copie des fichiers template..."
cp "$TEMPLATE_DIR/docker-compose.yml" "$CLIENT_DIR/"
cp "$TEMPLATE_DIR/.env.template" "$CLIENT_DIR/.env"

# Génération des mots de passe sécurisés
echo "Génération des mots de passe..."
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)
MYSQL_PASSWORD=$(openssl rand -base64 32)
NEXTCLOUD_ADMIN_PASSWORD=$(openssl rand -base64 32)
WIREGUARD_PEERS=3

# Mise à jour du fichier .env
echo "Configuration du fichier .env..."
sed -i '' "s/CLIENT_NAME=.*/CLIENT_NAME=$CLIENT_NAME/" "$CLIENT_DIR/.env"
sed -i '' "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD/" "$CLIENT_DIR/.env"
sed -i '' "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$MYSQL_PASSWORD/" "$CLIENT_DIR/.env"
sed -i '' "s/NEXTCLOUD_ADMIN_PASSWORD=.*/NEXTCLOUD_ADMIN_PASSWORD=$NEXTCLOUD_ADMIN_PASSWORD/" "$CLIENT_DIR/.env"
sed -i '' "s/WIREGUARD_PEERS=.*/WIREGUARD_PEERS=$WIREGUARD_PEERS/" "$CLIENT_DIR/.env"

# Création de la documentation
echo "Génération de la documentation..."
cat > "$DOCS_DIR/README.md" << EOF
# Documentation Client: $CLIENT_NAME

## Accès aux Services

- Nextcloud: https://$CLIENT_NAME.nouserv.re
- Uptime Kuma: https://status.$CLIENT_NAME.nouserv.re
- Duplicati: https://backup.$CLIENT_NAME.nouserv.re
- WireGuard: wg.$CLIENT_NAME.nouserv.re
- RustDesk: rd.$CLIENT_NAME.nouserv.re

## Identifiants

### Nextcloud
- Utilisateur: admin
- Mot de passe: $NEXTCLOUD_ADMIN_PASSWORD

### Base de données
- Root Password: $MYSQL_ROOT_PASSWORD
- User Password: $MYSQL_PASSWORD

### WireGuard
- Nombre de pairs configurés: $WIREGUARD_PEERS

## Services Déployés

1. Nextcloud (Stockage et partage)
2. WireGuard (VPN)
3. Uptime Kuma (Supervision)
4. RustDesk Server (Accès distant)
5. Duplicati (Backups)

## Maintenance

Pour redémarrer les services:
\`\`\`bash
cd $CLIENT_DIR
docker-compose restart
\`\`\`

Pour mettre à jour les services:
\`\`\`bash
cd $CLIENT_DIR
docker-compose pull
docker-compose up -d
\`\`\`
EOF

# Création du LXC/VM dans Proxmox (à implémenter selon votre configuration)
echo "Note: La création du conteneur LXC/VM dans Proxmox doit être faite manuellement."

echo "Configuration terminée pour le client $CLIENT_NAME"
echo "Documentation générée dans: $DOCS_DIR"
echo "Configuration Docker dans: $CLIENT_DIR" 