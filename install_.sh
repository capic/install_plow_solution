#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function start {
    echo "=== Démarrage de l'installation ==="

    echo "Installation de python 3"
    apt install python3 mysql-client python-dev -y
    wget https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-py3_2.1.5-1debian8.2_all.deb
    dpkg -i mysql-connector-python-py3_2.1.5-1debian8.2_all.deb

    python3 ./main.py
}

start
