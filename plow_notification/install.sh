#!/usr/bin/env bash

function installPrerequis {
    echo "=== Installation des prérequis ==="

#    echo "Ajout du dépot"
#    apt-add-repository ppa:pypy/ubuntu/ppa


    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade

    apt-get install build-essential libssl-dev python-pip pypy pypy-dev python3-dev python-dev  libffi-dev

    echo "Reinstallation de pyyaml"
    pip uninstall pyyaml
    apt-get install libyaml-dev libpython3-dev pyyaml -y

    echo "Installation de l'environnement virtuel"
    pip install virtualenv

    echo "Creation de l'environnement virtuel: ${repertoire_installation_base}"
    if [ ! -d "${repertoire_installation_base}" ]; then
        mkdir ${repertoire_installation_base}
    fi
    virtualenv --python=pypy ${repertoire_installation_base}pypy-venv

    cd ${repertoire_installation_base}pypy-venv/
    . bin/activate

    echo "Installation"
    pip install crossbar
}

function installPlowNotification {
    echo "=== Installation de plow notification ==="

    cd ${repertoire_installation_base}
    crossbar init
}

function createConfigFile {
    echo "=== Suppression de l'ancien fichier ==="
    rm ${repertoire_installation_base}.crossbar/config.json
    echo "=== Création du fichier de configuration ==="
    echo "{" >> ${repertoire_installation_base}.crossbar/config.json
    echo "  \"version\": 2," >> ${repertoire_installation_base}.crossbar/config.json
    echo "  \"controller\": {}," >> ${repertoire_installation_base}.crossbar/config.json
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
    echo "                                  \"uri\": \"\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"match\": \"prefix\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"allow\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                      \"call\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                      \"register\": true" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                      \"publish\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                      \"subscribe\": true," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  }," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"disclose\": {" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                        \"caller\": false," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                        \"publisher\": false" >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  }," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                                  \"cache\": true" >> ${repertoire_installation_base}.crossbar/config.json
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
    echo "                  \"type\": \"tcp\"," >> ${repertoire_installation_base}.crossbar/config.json
    echo "                  \"port\": 8181" >> ${repertoire_installation_base}.crossbar/config.json
    echo "              }," >> ${repertoire_installation_base}.crossbar/config.json
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

function addToStartup {
    echo "=== Ajout de plow notification au démarrage ==="

    options=("Oui" "Non")
    PS3="Voulez vous ajouter plow notification au démarrage de l'appareil ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) apt-get install csh daemontools daemontools-run
                mkdir /etc/service/crossbar
                if [ ! -f /etc/service/crossbar/run ]; then
                    echo "#!/bin/sh" >> /etc/service/crossbar/run
                    echo "" >> /etc/service/crossbar/run
                    echo "sudo crossbar start \\" >> /etc/service/crossbar/run
                    echo "--cbdir ${repertoire_installation_base}.crossbar \\" >> /etc/service/crossbar/run
                    echo "--logdir ${repertoire_installation_base}.crossbar/log" >> /etc/service/crossbar/run
                fi
                chmod +x /etc/service/crossbar/run
                sed -i "s/exit 0$/\/bin\/csh -cf '\/usr\/bin\/svscanboot \&'\n\n&/" /etc/rc.local
                break;;
            2 ) break;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
}
function start {
    echo "=== Démarrage de l'installation de plow notification ==="
    installPrerequis
    installPlowNotification
    createConfigFile
    addToStartup
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

start