#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config.cfg

installation_personnalisee=-1

function init {
    echo "=== Init ==="
    options=("Non [Apache2]" "Oui")
    
    PS3="Voulez-vous utilisez l'installation personnalisée ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) break;;
            2 ) break;;
       
           $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
    installation_personnalisee=$REPLY
    echo "Installation personnalisée ? => $installation_personnalisee"
}

# fonction d'installaion de plowshare et de ses prerequis
function installPlowshare {
    echo "=== Installation des prérequis plowshare === "
    echo "*** Teste si plowdown est installé ****"
    if ! which plowdown >/dev/null; then
        sudo apt-get install coreutils sed util-linux grep curl recode rhino
        echo "=== Installation de plowshare === "
        echo "Adresse du dépot git de plowdown : $git_plowhare => $repertoire_git_plowhare"
        git clone $git_plowhare $repertoire_git_plowhare
        cd $repertoire_git_plowhare
        sudo make install
        plowmod --install
    fi
    echo "=== Fin d'installation de plowshare === "
}

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    sudo apt-get update
    sudo apt-get upgrade
    
    serveur=1

    echo "--- Installation d'un serveur LAMP --- "
    if [[ $installation_personnalisee = 2 ]]; then
        options=("Apache" "Lighttpd")
        
        PS3="Choix du serveur"
        select opt in "${options[@]}"; do
            case "$REPLY" in
                1 ) break;;
                2 ) break;;
          
                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
        serveur=$REPLY
    fi
    
    if [[ $serveur = 1 ]]; then
        echo "*** Teste si apache2 est installé ****"
        if ! which apache2 >/dev/null; then
            echo "<<<<< Installation d'apache 2 >>>>>"
            sudo apt-get install apache2
        else
            echo "Apache2 déjà installé"
        fi
    elif [[ $serveur = 2 ]]; then
        echo "*** Teste si lighttpd est installé ****"
        if ! which lighttpd >/dev/null; then
            echo "<<<<< Installation de lighhtpd >>>>>"
            sudo apt-get install lighttpd
        else
            echo "Lighttpd déjà installé"
        fi
    else
        echo "Erreur de selection de serveur"
        exit 1
    fi
    echo "*** Teste si mysql est installé ****"
    if ! which mysqld >/dev/null; then
        echo "<<<<< Installation de mysql >>>>>"
        sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
        echo "<<<<< Activation de mysql >>>>>"
        sudo mysql_install_db
        sudo /usr/bin/mysql_secure_installation
    else
        echo "Mysql déjà installé"
    fi
    echo "<<<<< Installation de PHP >>>>>"
    echo "*** Teste si php est installé ****"
    if ! which php >/dev/null; then
        sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt
    else
        echo "Php déjà installé"
    fi
    echo "<<<<< Installation du reste des prérequis >>>>>"
    sudo apt-get install git python2.7 python3 python-dev screen
    wget https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    pip install psutil
    echo "=== Fin d'installation des prérequis === "
}

function createBaseDonnees {
    echo "Test si la base de données existe"
    RESULT=`mysqlshow --user=root --password=capic_20_04_1982 plowshare| grep -v Wildcard | grep -o plowshare`
    if [ "$RESULT" != "plowshare" ]; then
        echo "=== Création de la base de données ==="
        mysql -uroot -pcapic_20_04_1982 -e "create database plowshare"
        mysql -uroot -pcapic_20_04_1982 plowshare < $repertoire_git_plow_back/plowshare.sql
    else
        echo "La base de données existe"
    fi
    echo "=== Fin de la création de la base de données ==="
}

function installPlowSolution {
    echo "=== Création de la solution plow ==="
    echo "Adresse du dépot git de plowshare_back : $git_plow_back => $repertoire_git_plow_back"
    echo "Téléchargement du backend"
    git clone $git_plow_back $repertoire_git_plow_back
    echo "Adresse du dépot git de plow_front : $git_plow_front => $repertoire_git_plow_front"
    echo "Téléchargement du frontend"
    git clone $git_plow_front $repertoire_git_plow_front
    echo "Adresse du dépot git de plow_pyhton : $git_plow_python => $repertoire_git_plow_python"
    echo "Téléchargement du gestionnaire de téléchargements"
    git clone $git_plow_python $repertoire_git_plow_python
    echo "Adresse du dépot git de plow_notifications : $git_plow_notifications => $repertoire_git_plow_notifications"
    echo "Téléchargement du gestionnaire des notifications"
    git clone $git_plow_notifications $repertoire_git_plow_notifications

    echo "=== Fin de la création de la solution plow ==="
}

function nettoyage {
    echo "=== Nettoyage des dossiers ==="
    cp -r $repertoire_git_plow_back/* $repertoire_web
    rm -r $repertoire_git_plow_back
    cp -r $repertoire_git_plow_front/* $repertoire_web
    rm -r $repertoire_git_plow_front
    cp -r $repertoire_git_plow_python/* $repertoire_web
    rm -r $repertoire_git_plow_python
    cp -r $repertoire_git_plow_notifications/* $repertoire_web
    rm -r $repertoire_git_plow_notifications
    echo "=== Fin de nettoyage des dossiers ==="
}

function creerTaches {
    echo "=== Création des taches cron ==="
    cat <(crontab -l) <(echo "*/15 * * * * sh $repertoire_web/main/start_download.sh"; echo "*/2 * * * * python $repertoire_web/main/download_basic.py check_download_alive";) | crontab -
    echo "=== Fin de création des taches cron ==="
}

init

# on installe les prerequis
# =========================
installPrerequis

# on install plowshare
installPlowshare

# on install les scripts
installPlowSolution

# on cree la base si pas presente
createBaseDonnees

# on cree les taches cron
creerTaches

# nettoyage
nettoyage
