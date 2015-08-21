#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config.cfg

type_installation=-1
serveur=1 # apache par defaut

function init {
    echo "=== Init ==="
    options=("Installation totale automatique" "Installation totale interactive" "Installation uniquement d'un serveur" "Installation uniquement de la solution plow" "Installation totale sans serveur")
    
    PS3="Voulez-vous utilisez l'installation personnalisée ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) break;;
            2 ) break;;
            3 ) break;;
            4 ) break;;
            5 ) break;;
       
           $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
    type_installation=$REPLY
    echo "Installation personnalisée ? => $type_installation"
}

# fonction d'installaion de plowshare et de ses prerequis
function installPlowshare {
    echo "=== Installation des prérequis plowshare === "
    echo "*** Teste si plowdown est installé ****"
    if ! which plowdown >/dev/null; then
        sudo apt-get -y install coreutils sed util-linux grep curl recode rhino
        echo "=== Installation de plowshare === "
        echo "Adresse du dépot git de plowdown : $git_plowhare => $repertoire_git_plowhare"
        git clone $git_plowhare $repertoire_git_plowhare
        cd $repertoire_git_plowhare
        sudo make install
        plowmod --install
    fi
    echo "=== Fin d'installation de plowshare === "
}

function installApache {
    echo "*** Teste si apache2 est installé ****"
    if ! which apache2 >/dev/null; then
        echo "<<<<< Installation d'apache 2 >>>>>"
        sudo apt-get -y install apache2
    else
        echo "Apache2 déjà installé"
    fi
}

function installLighttpd {
    echo "*** Teste si lighttpd est installé ****"
    if ! which lighttpd >/dev/null; then
        echo "<<<<< Installation de lighhtpd >>>>>"
        sudo apt-get -y install lighttpd
    else
        echo "Lighttpd déjà installé"
    fi
}

function configLighttpd {
    echo "*** Configuration de lighttpd ***"
    sudo apt-get -y install php5-cgi
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1 /"  /etc/php5/cgi/php.ini
    lighttpd-enable-mod fastcgi
    lighttpd-enable-mod fastcgi-php
    ls -l /etc/lighttpd/conf-enabled
    /etc/init.d/lighttpd force-reload
    /bin/echo '## directory listing configuration## we disable the directory listing by default##$HTTP["url"] =~ "^/" {  dir-listing.activate = "disable"}' | /usr/bin/tee /etc/lighttpd/conf-available/20-disable-listing.conf
    /usr/sbin/lighty-enable-mod disable-listing
    /etc/init.d/lighttpd force-reload
    sed -i -e  "s/#       \"mod_rewrite\",/        \"mod_rewrite\" /" /etc/lighttpd/lighttpd.conf
    echo "server.error-handler-404 = \"/index.php?error=404\"" >> /etc/lighttpd/lighttpd.conf
    /etc/init.d/lighttpd force-reload
    echo "*** Fin de configuration de lighttpd ***"
}

function installServeur {
    echo "--- Installation d'un serveur LAMP --- "
    if [[ ${type_installation} = 2 ]] || [[ ${type_installation} = 3 ]]; then
        options=("Apache" "Lighttpd" "Serveur déjà installé")

        PS3="Choix du serveur "
        select opt in "${options[@]}"; do
            case "$REPLY" in
                1 ) break;;
                2 ) break;;
                3 ) break;;

                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
        serveur=$REPLY
    fi

    if [[ ${serveur} = 1 ]]; then
        installApache
    elif [[ ${serveur} = 2 ]]; then
        installLighttpd
        configLighttpd
    elif [[ ${serveur} = 3 ]]; then
        echo "<<<<< Aucune installation de serveur ne sera faite >>>>>"
    else
        echo "Erreur de selection de serveur"
        exit 1
    fi
}

function installMysql {
     echo "*** Teste si mysql est installé ****"
    if ! which mysqld >/dev/null; then
        echo "<<<<< Installation de mysql >>>>>"
        sudo apt-get -y install mysql-server php5-mysql

        if [[ $serveur = 1 ]]; then
            sudo apt-get -y install libapache2-mod-auth-mysql
        fi

        echo "<<<<< Activation de mysql >>>>>"
        sudo mysql_install_db
        sudo /usr/bin/mysql_secure_installation
    else
        echo "Mysql déjà installé"
    fi
}

function installPHP {
    echo "<<<<< Installation de PHP >>>>>"
    echo "*** Teste si php est installé ****"
    if ! which php >/dev/null; then
        sudo apt-get -y install apt-cache search php5

        sudo apt-get -y install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5 php5-mcrypt php5-xcache

        if [[ $serveur = 1 ]]; then
            sudo apt-get -y install libapache2-mod-php5
        fi
    else
        echo "Php déjà installé"
    fi
}

function installPHPMYADMIN {
    echo " <<<<<< Installation de PHPMYADMIN >>>>>>"
    echo "*** Teste si phpmyadmin est installé ****"
    if ! which phpmyadmin >/dev/null; then
        sudo apt-get -y install phpmyadmin
    fi

    # configuration des serveurs après installation
    if [[ $serveur = 2 ]]; then
        configLighttpd
    fi

}

function installNodeJS {
    echo "<<<<< Installation de NodeJS >>>>>"
    if ! which npm >/dev/null; then
        wget http://nodejs.org/dist/node-latest.tar.gz
        tar zxvf node-latest.tar.gz
        cd node-v0.1*
        ./configure
        make
        sudo make install
    else
        echo "NodeJS déjà installé"
    fi
    sudo npm cache clean
}

function installBower {
    echo "<<<<< Installation de Bower >>>>>"
    sudo npm install -g bower
    wget https://bootstrap.pypa.io/get-pip.py
}

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    sudo apt-get update
    sudo apt-get -y upgrade

    echo "<<<<< Installation du reste des prérequis >>>>>"
    sudo apt-get -y install git python2.7 python3 python-dev screen postfix build-essential openssl libssl-dev

    echo "<<<<< Installation des librairies python >>>>>"
    python get-pip.py
    pip install psutil
    sudo pip install --allow-external mysql-connector-python mysql-connector-python
    echo "=== Fin d'installation des prérequis === "
}

function creerBaseDonnees {
    echo "Test si la base de données existe"
    RESULT=`mysqlshow -uroot -p plowshare| grep -v Wildcard | grep -o plowshare`
    if [ "$RESULT" != "plowshare" ]; then
        echo "=== Création de la base de données ==="
        mysql -uroot -p -e "create database plowshare"
        mysql -uroot -p plowshare < $repertoire_git_plow_back/plowshare.sql
    else
        echo "La base de données existe"
    fi
    echo "=== Fin de la création de la base de données ==="
}

function preparationSite {
    echo "=== Préparation du site internet ==="
    cp -r $repertoire_git_plow_back/* $repertoire_web
    cd $repertoire_git_plow_front
    bower --allow-root install
    cp -r $repertoire_git_plow_front/app/* $repertoire_web
    cp -r $repertoire_git_plow_front/bower_components $repertoire_web
    cp -r $repertoire_git_plow_python/* $repertoire_web
    cp -r $repertoire_git_plow_notifications/* $repertoire_web

    echo "=== fin de préparation du site internet ==="
}

function nettoyage {
    echo "=== Nettoyage des dossiers ==="
    rm -r $repertoire_git_plow_back
    rm -r $repertoire_git_plow_front
    rm -r $repertoire_git_plow_python
    rm -r $repertoire_git_plow_notifications
    echo "=== Fin de nettoyage des dossiers ==="
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

    mkdir $repertoire_web_log

    preparationSite

    nettoyage

    echo "=== Fin de la création de la solution plow ==="
}




function creerTaches {
    echo "=== Création des taches cron ==="
    cat <(crontab -l) <(echo "*/15 * * * * sh $repertoire_web/main/start_download.sh"; echo "*/2 * * * * python $repertoire_web/main/download_basic.py check_download_alive";) | crontab -
    echo "=== Fin de création des taches cron ==="
}

function installTotale() {
    installPrerequis

    if [[ $1 = 1 ]]; then
        installServeur
    fi

    installMysql

    installPHP

    installPHPMYADMIN

    installNodeJS

    installBower

    installPlowshare

    installPlowSolution

    creerBaseDonnees

    creerTaches
}


init

if [[ ${type_installation} = 1 ]] || [[ ${type_installation} = 2 ]]; then
    installTotale 1 # avec serveur
elif [[ ${type_installation} = 3 ]]; then
    installServeur
elif [[ ${type_installation} = 4 ]]; then
    installPlowSolution
elif [[ ${type_installation} = 5 ]]; then
    installTotale 0 # sans serveur
fi;