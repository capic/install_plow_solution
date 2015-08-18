#!/bin/bash

# on installe les prerequis
# =========================
installPrerequis

# on install plowshare
installPlowshare

# on cree la base si pas presente
createBaseDonnees

# on install les scripts
installPlowSolution

# on cree les taches cron

# fonction d'installaion de plowshare et de ses prerequis
function installPlowshare {
    echo "=== Installation des prérequis plowshare === \r\n"
    echo "*** Teste si mysql est installé ****"
    if ! which plowdown >/dev/null; then
        sudo apt-get install coreutils sed util-linux grep curl recode rhino
        echo "=== Installation de plowshare === \r\n"
        cd /opt/
        git clone https://github.com/mcrapet/plowshare.git plowshare
        sudo make install
        plowmod --install
    fi
    echo "=== Fin d'installation de plowshare === \r\n"
}

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === \r\n"
    echo "--- Mise à jour des dépots --- \r\n"
    sudo apt-get update
    sudo apt-get upgrade

    echo "--- Installation d'un serveur LAMP --- \r\n"
    echo "<<<<< Installation d'apache 2 >>>>>"
    sudo apt-get install apache2
    echo "*** Teste si mysql est installé ****"
    if ! which mysqld >/dev/null; then
        echo "<<<<< Installation de mysql >>>>>"
        sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
        echo "<<<<< Activation de mysql >>>>>"
        sudo mysql_install_db
        sudo /usr/bin/mysql_secure_installation
    fi
    echo "<<<<< Installation de PHP >>>>>"
    sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt
    echo "<<<<< Installation du reste des prérequis >>>>>"
    sudo apt-get install git python2.7 python3.3
    echo "=== Fin d'installation des prérequis === \r\n"
}

function createBaseDonnees {
    echo "=== Création de la base de données ==="
    mysql -uroot -e "create database 'plowshare'"
    mysql -uroot plowshare < dump.sql
    echo "=== Fin de la création de la base de données ==="
}

function installPlowSolution {
    echo "=== Création de la solution plow ==="
    cd /var/www/
    echo "Téléchargement du backend"
    git clone https://github.com/capic/plowshare_back.git
    echo "Téléchargement du frontend"
    git clone https://github.com/capic/plow_front.git
    echo "Téléchargement du gestionnaire de téléchargements"
    mkdir main
    cd main
    git clone https://github.com/capic/plow_pyhton.git
    echo "Téléchargement du gestionnaire des notifications"
    got clone https://github.com/capic/plow_notifications.git
    echo "=== Fin de la création de la solution plow ==="
}