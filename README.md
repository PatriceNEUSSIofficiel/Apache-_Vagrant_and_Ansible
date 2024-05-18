# TPE N°4: Apache, Vagrant et Ansible (100 points)
Date: Samedi 04 Mai 2024
NEUSSI NJIETCHEU PATRICE EUGENE 21T2894 

## 1 - Vagrantfile:
Le Vagrantfile est un fichier de configuration utilisé par Vagrant pour créer et configurer des environnements de développement virtualisés. Dans ce Vagrantfile, nous spécifions l'image de base à utiliser (`generic/ubuntu2204`), le nom d'hôte de la machine virtuelle (`web-server`), et nous configurons également un réseau privé avec une adresse IP statique (`192.168.33.10`) afin que la machine virtuelle puisse être accessible depuis l'hôte.

```ruby
Vagrantfile:

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.hostname = "web-server"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 1
  end
end

```

## 2 - Script d'installation d'Apache:

Ce script est un simple script bash qui installe Apache2 sur la machine virtuelle. Il utilise apt-get pour mettre à jour les paquets et installer Apache2. Ensuite, il active le démarrage automatique d'Apache2 pour s'assurer qu'Apache2 démarre automatiquement lors du démarrage de la machine virtuelle. Enfin, il démarre Apache2.

```bash

Script d'installation d'Apache:

#!/bin/bash

# Installation d'Apache
sudo apt-get update
sudo apt-get install -y apache2

# Activation du démarrage automatique
sudo systemctl enable apache2

# Démarrage d'Apache
sudo systemctl start apache2

``` 

## 3 - Configuration d'un Hôte Virtuel Apache:

Cette configuration déclare un hôte virtuel Apache qui répondra aux requêtes pour le nom de domaine l3-yourmatricule.cm sur le port 80. Le dossier racine du site est défini comme $HOME/mon-site, où $HOME est le répertoire de l'utilisateur Apache. Les fichiers de logs d'accès et d'erreur sont configurés pour être stockés dans $HOME/mon-site/mon-site-access.log et $HOME/mon-site/mon-site-error.log respectivement. Le format de log est spécifié pour inclure la date, l'heure, l'URL, l'adresse IP du client, le système d'exploitation du client, le type de périphérique client, le code HTTP, la méthode HTTP et le nom d'hôte client.

```ruby

Configuration d'un Hôte Virtuel Apache:

<VirtualHost *:80>
    ServerAdmin admin@l3-yourmatricule.cm
    ServerName l3-yourmatricule.cm
    DocumentRoot /home/user/mon-site
    ErrorLog /home/user/mon-site/mon-site-error.log
    CustomLog /home/user/mon-site/mon-site-access.log "%{%Y-%m-%d %H:%M:%S}t %h %a %{{User-Agent}i} %>s %m %{Host}i"
</VirtualHost>

```

## 4 - Copie du fichier de configuration et redémarrage d'Apache:

Ce script copie le fichier de configuration de l'hôte virtuel Apache dans le répertoire approprié (/etc/apache2/sites-available/) sur la machine virtuelle. Ensuite, il utilise la commande a2ensite pour activer le site Apache nouvellement configuré. Enfin, il utilise systemctl reload apache2 pour recharger la configuration d'Apache2 afin que les modifications prennent effet.

```bash

Copie du fichier de configuration et redémarrage d'Apache:

sudo cp /path/to/your/config/file /etc/apache2/sites-available/l3-yourmatricule.conf
sudo a2ensite l3-yourmatricule.conf
sudo systemctl reload apache2
```

## 5 - Infrastructure as Code avec Ansible:

Ansible est un outil d'automatisation qui permet de déployer, configurer et gérer des infrastructures informatiques. Dans cette étape, nous utilisons Ansible pour automatiser l'installation et la configuration d'Apache2 sur la machine virtuelle. Le fichier d'inventaire Ansible contient les informations sur la machine virtuelle, telles que son adresse IP et les informations d'identification nécessaires pour s'y connecter. Le playbook Ansible définit les tâches à effectuer sur la machine virtuelle, telles que l'installation d'Apache2, la copie du fichier de configuration de l'hôte virtuel Apache et le redémarrage d'Apache2.
Infrastructure as Code avec Ansible:
Fichier d'inventaire Ansible:

```ruby


[web]
192.168.33.10 ansible_user=your_username ansible_ssh_private_key=~/.ssh/id_rsa

```
## 6 - Pages du site:

Nous créons deux pages pour le site web. La première page contient la documentation structurée et détaillée de chaque question du projet, au format Markdown ou HTML. La deuxième page affiche les logs d'accès du site web.
Playbook Ansible:

```ruby

---
- name: Setup Apache and Configure Virtual Host
  hosts: web
  become: yes
  tasks:
    - name: Install Apache2
      apt:
        name: apache2
        state: present

    - name: Copy Apache virtual host configuration
      copy:
        src: /path/to/your/config/file
        dest: /etc/apache2/sites-available/l3-yourmatricule.conf

    - name: Enable the site
      apache2_module:
        state: present
        name: "{{ item }}"
      with_items:
        - rewrite
        - ssl
        - headers

    - name: Reload Apache
      service:
        name: apache2
        state: reloaded

```

## 7. Surchargez le Vagrantfile:

Nous ajoutons une section de provisionnement Ansible au Vagrantfile pour spécifier le playbook Ansible à exécuter lorsque la machine virtuelle est créée.
Cela permet de déployer automatiquement Apache2 et de configurer l'hôte virtuel Apache lors du démarrage de la machine virtuelle avec la commande vagrant up.

```ruby

config.vm.provision "ansible" do |ansible|
    ansible.playbook = "path/to/your/playbook.yml"
end
```

## 8. Configurer le fichier /etc/hosts:

Nous ajoutons une entrée au fichier /etc/hosts de l'hôte local pour associer l'adresse IP de la machine virtuelle avec le nom de domaine du site web, permettant ainsi d'y accéder via son nom de domaine.

```bash 
192.168.56.50    l3-21T2894.cm

```
## 9 -  ssl certificate

### Cas 1 : Site déployé en local

    
```bash
Installer Certbot :

sudo apt-get update
sudo apt-get install certbot
```

Obtenir un certificat SSL pour le domaine local :

```bash
sudo certbot certonly --manual --preferred-challenges dns -d monsite.local
```

Cette commande lance le processus d'obtention du certificat. Suivez les instructions affichées à l'écran pour valider le défi DNS.

Configurer Apache pour utiliser le certificat SSL :

```bash

    sudo a2enmod ssl
    sudo systemctl restart apache2
```
Ces commandes activent le module SSL dans Apache et redémarrent le serveur web pour appliquer les changements.

### Cas 2 : Site déployé sur un VPS
```bash
sudo apt-get update
sudo apt-get install certbot
``` 
Obtenir un certificat SSL pour le domaine public :

```bash

sudo certbot certonly --manual --preferred-challenges dns -d monsite.com

``` 

Cette commande lance le processus d'obtention du certificat. Suivez les instructions affichées à l'écran pour valider le défi DNS.

Configurer Apache pour utiliser le certificat SSL :

```bash
    sudo a2enmod ssl
    sudo systemctl restart apache2
```
Ces commandes activent le module SSL dans Apache et redémarrent le serveur web pour appliquer les changements.

Configuration pour une réponse automatique en HTTPS

Configuration Apache :
Ajoutez les lignes suivantes dans la configuration Apache pour rediriger automatiquement toutes les requêtes HTTP vers HTTPS :

```bash
    <VirtualHost *:80>
        ServerName monsite.local
        Redirect permanent / https://monsite.local/
    </VirtualHost>

    <VirtualHost *:443>
        ServerName monsite.local
        SSLCertificateFile /etc/letsencrypt/live/monsite.local/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/monsite.local/privkey.pem
        Include /etc/letsencrypt/options-ssl-apache.conf
    </VirtualHost>
```
Redémarrer Apache :
Redémarrez Apache pour appliquer les changements :

```bash

sudo systemctl restart apache2

```
Avec cette configuration, toutes les requêtes HTTP seront automatiquement redirigées vers la version HTTPS du site web.