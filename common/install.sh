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

    mysql -u root -p -h ${bdd_address} << EOF
CREATE DATABASE ${database}
EOF

    return 0
}

function start {
    installPrerequis

    # on teste si la bdd existe
    # => si non on demande si on doit la créer ou pas
    echo "Connexion au serveur de base de données pour verifier si la base existe ..."
    retry=true

    while [ "${retry}" = true ]; do
        RESULT=`mysqlshow -u root -p -h ${bdd_address} ${database}| grep -v Wildcard | grep -o ${database}`
        if [ "$RESULT" == "" ]; then
            options=("Oui" "Non")
            PS3=" La base de données ${database} n'existe pas, la créer ?"
            select opt in "${options[@]}" "Quit"; do
                case "$REPLY" in
                    1 ) retry=createDatabase; break;;
                    2 ) retry=false; break;;
                    *) echo "Le choix n'est pas correct";continue;;
                esac
            done
        else
            retry=false
            echo "La base de données existe déjà"
        fi
   done
}

start