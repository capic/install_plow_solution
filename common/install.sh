#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade

    echo "<<<<< Installation du reste des prérequis >>>>>"
    apt-get -y install git python2.7 python3 python-dev screen postfix build-essential openssl libssl-dev gcc mailutils

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

installPrerequis