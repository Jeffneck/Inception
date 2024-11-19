#!/bin/bash

# Mettre à jour la liste des paquets
apt update

# Installer les paquets nécessaires pour que `apt` puisse utiliser des dépôts HTTPS
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Ajouter le dépôt de Docker à `apt`
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Mettre à jour la liste des paquets à nouveau pour inclure les paquets Docker
apt update

# Installer Docker
apt install -y docker-ce

# Vérifier que Docker est bien installé
docker --version

# Télécharger la dernière version de Docker Compose (remplacer "2.x.x" par la version désirée)
curl -L "https://github.com/docker/compose/releases/download/2.x.x/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Appliquer les permissions nécessaires
chmod +x /usr/local/bin/docker-compose

# Vérifier que Docker Compose est bien installé
docker-compose --version

echo "Installation de Docker et Docker Compose terminée avec succès."
