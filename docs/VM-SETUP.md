# Guide d'installation sur VM

Ce guide vous aidera à déployer NouServ sur une VM pour tester.

## Prérequis

- Une VM avec Ubuntu 20.04 LTS ou plus récent
- Minimum 4 Go RAM
- 2 vCPUs
- 50 Go d'espace disque
- Accès root à la VM

## Étapes d'installation

1. **Préparation de la VM**

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation des outils de base
sudo apt install -y git curl wget
```

2. **Clonage du dépôt**

```bash
# Création du répertoire
sudo mkdir -p /opt/nouserv
cd /opt/nouserv

# Clonage du dépôt (remplacer l'URL par votre dépôt)
sudo git clone https://github.com/votre-compte/nouserv.git .
```

3. **Installation automatique**

```bash
# Rendre le script exécutable
sudo chmod +x scripts/install-vm.sh

# Exécuter le script d'installation
sudo ./scripts/install-vm.sh
```

4. **Création d'un client test**

```bash
# Création d'un client test
sudo ./scripts/setup-client.sh client1
```

5. **Vérification de l'installation**

```bash
# Vérifier que les conteneurs sont en cours d'exécution
docker ps

# Vérifier les logs du monitoring
docker-compose -f monitoring/docker-compose.yml logs
```

## Accès aux services

Une fois l'installation terminée, vous pourrez accéder aux services via :

- Dashboard Traefik : https://traefik.nouserv.re
- Monitoring : https://monitoring.nouserv.re
- Métriques : https://metrics.nouserv.re
- Netdata : https://netdata.nouserv.re

Pour le client test :
- Nextcloud : https://client1.nouserv.re
- Uptime Kuma : https://status.client1.nouserv.re
- Duplicati : https://backup.client1.nouserv.re

## Configuration DNS

Pour que les domaines fonctionnent, vous devez :

1. Configurer votre domaine `nouserv.re` pour pointer vers l'IP de votre VM
2. Ajouter les sous-domaines suivants :
   - traefik.nouserv.re
   - monitoring.nouserv.re
   - metrics.nouserv.re
   - netdata.nouserv.re
   - client1.nouserv.re
   - status.client1.nouserv.re
   - backup.client1.nouserv.re

## Dépannage

### Problèmes courants

1. **Les services ne démarrent pas**
   ```bash
   # Vérifier les logs
   docker-compose logs
   
   # Redémarrer les services
   docker-compose restart
   ```

2. **Problèmes de certificats SSL**
   - Vérifier que les domaines pointent bien vers votre VM
   - Vérifier les logs de Traefik : `docker logs traefik`

3. **Problèmes de performance**
   - Vérifier l'utilisation des ressources : `docker stats`
   - Ajuster les limites de ressources dans docker-compose.yml si nécessaire

### Commandes utiles

```bash
# Redémarrer tous les services
docker-compose restart

# Mettre à jour les images
docker-compose pull
docker-compose up -d

# Voir les logs en temps réel
docker-compose logs -f

# Nettoyer les conteneurs arrêtés
docker container prune

# Nettoyer les images non utilisées
docker image prune -a
```

# Initialiser le dépôt Git
cd nouserv
git init

# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "Initial commit: Structure de base du projet nouserv"

# Ajouter le remote GitLab (remplacer l'URL par celle de votre dépôt GitLab)
git remote add origin https://gitlab.com/ibhugeloo/nouserv.git

# Pousser sur GitLab
git push -u origin master 