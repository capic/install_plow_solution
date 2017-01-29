#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config/config_install.cfg

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function start {
    echo "=== Démarrage de l'installation ==="

    echo "Installation de python 3"
    apt install python3 mysql-client mysql-connector-python python-dev -y

    python3 ./main.py
}

start
