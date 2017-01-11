#!/usr/bin/env bash

function installPrerequis {
    echo "=== Installation des prérequis ==="

    echo "Ajout du dépot"
    apt-add-repository ppa:pypy/ubuntu/ppa

    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade

    apt-get install build-essential libssl-dev python-pip pypy pypy-dev

    echo "Installation de l'environnement virtuel"
    pip install virtualenv
}

function installPlowNotification {
    echo "=== Installation de plow notification ==="

    echo "Creation de l'environnement virtuel"
    if [ ! -d "${repertoire_installation_base}" ]; then
        mkdir ${repertoire_installation_base}
    fi
    virtualenv --python=pypy ${repertoire_installation_base}pypy-venv

    cd ${repertoire_installation_base}pypy-venv/
    . bin/activate

    echo "Installation"
    pip install crossbar
}

function createConfigFile {
    echo "=== Création du fichier de configuration ==="
    echo "{" >> ${repertoire_installation_base}.crossbar/config.json
    echo "  \"controller\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "  }," >> ${repertoire_installation_base}.crossbar/config.json
    echo "  \"workers\": [" >> ${repertoire_installation_base}.crossbar/config.json
    echo "      {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "          \"type\": \"router\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "          \"realms\": [" >> ${repertoire_installation_base}.crossbar/config.json
    echo "              {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"name\": \"realm1\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"roles\": [" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          \"name\": \"anonymous\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          \"permissions\": [" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                              {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"uri\": \"*\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"publish\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"subscribe\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo"                                   \"call\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"register\": true" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                              }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          ]" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  ]" >> ${repertoire_installation_base}.crossbar/config.json
    echo "              }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "          ]," >> ${repertoire_installation_base}.crossbar/config.json
    echo "          \"transports\": [" >> ${repertoire_installation_base}.crossbar/config.json
    echo "              {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"type\": \"web\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"endpoint\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      \"type\": \"tcp\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      \"port\": 8181" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  }," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"paths\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      \"/\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          \"type\": \"static\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          \"directory\": \"..\"" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      }," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      \"ws\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                          \"type\": \"websocket\"" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                      }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "              }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "          ]" >> ${repertoire_installation_base}.crossbar/config.json
    echo "      }" >> ${repertoire_installation_base}.crossbar/config.json
    echo "  ]" >> ${repertoire_installation_base}.crossbar/config.json
    echo "}" >> ${repertoire_installation_base}.crossbar/config.json

}

function start {
    echo "=== Démarrage de l'installation de plow notification ==="
    installPrerequis
    installPlowNotification
    createConfigFile
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

start