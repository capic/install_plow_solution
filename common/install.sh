#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade

    echo "<<<<< Installation du reste des prérequis >>>>>"
    apt-get -y install git python2.7 python3 python-dev screen postfix build-essential openssl libssl-dev gcc mailutils mysql-client

    echo "<<<<< Installation des librairies python >>>>>"
    if ! which pip >/dev/null; then
        wget https://bootstrap.pypa.io/get-pip.py
        python3 get-pip.py
    fi
    echo "## install psutil ##"
    pip3 install psutil
    echo "## install watchdog ##"
    pip3 install watchdog
    echo "## install request ##"
    pip3 install request
    echo "=== Fin d'installation des prérequis === "
}

function createDatabase {
    echo "=== Création de la base de données ==="
}

function start {
    installPrerequis

    # on teste si la bdd existe
    # => si non on demande si on doit la créer ou pas
    RESULT=`mysqlshow -u root -p -h ${bdd_address} ${database}| grep -v Wildcard | grep -o ${database}`
    if [ "$RESULT" == "" ]; then
        options=("Oui")
        PS3=" La base de données n'existe pas, la créer ?"
        select opt in "${options[@]}" "Quit"; do
            case "$REPLY" in
                1 ) createDatabase; break;;
               $(( ${#options[@]}+1 )) ) echo "Non!"; exit 1;;
                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
    fi
}

start