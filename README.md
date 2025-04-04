# NouServ - Infrastructure IT Multi-clients

Infrastructure IT hébergée pour TPE/PME basée sur Proxmox et Docker.

## Architecture

```
nouserv/
├── templates/          # Templates Docker Compose et configurations
├── clients/           # Configurations spécifiques aux clients
├── docs/             # Documentation générale et par client
├── scripts/          # Scripts d'automatisation
└── monitoring/       # Configuration de la supervision
```

## Services par Client

Chaque client dispose d'une stack isolée comprenant :
- Nextcloud (stockage et partage)
- WireGuard (VPN)
- Uptime Kuma (supervision)
- RustDesk Server (accès distant)
- Duplicati (backups)

## Prérequis

- Proxmox VE
- Docker & Docker Compose
- Nginx Proxy Manager ou Traefik
- Accès root sur le serveur

## Installation

1. Cloner ce dépôt
2. Copier le template client depuis `templates/` vers `clients/<nom-client>`
3. Modifier les variables dans le fichier `.env`
4. Exécuter `scripts/setup-client.sh <nom-client>`

## Monitoring

- Dashboard central : http://monitoring.nouserv.re
- Uptime Kuma : http://status.nouserv.re
- Netdata : http://metrics.nouserv.re

## Sécurité

- Accès uniquement via VPN ou domaines Cloudflare
- Certificats SSL automatiques via Let's Encrypt
- Isolation des clients via VMs/LXC Proxmox
- Backups automatiques vers stockage externe

## Documentation

La documentation par client est générée automatiquement dans `docs/clients/<nom-client>/`. # nouserv
# nouserv
