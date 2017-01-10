#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function installPrerequis {
    echo "=== Installation des prérequis ==="
    #TODO: verifier si node deja installe, si oui demander si update
    echo "--- Installation de nodejs ---"
    echo -e "\e[31mVersion de nodejs ? (defaut: ${nodejs_version})\e[39m"
    read nodejs_version_input
    if [ ! -z "${nodejs_version_input}" ]; then
        nodejs_version=${nodejs_version_input}
    fi
    wget "https://nodejs.org/dist/latest/node-v${nodejs_version}-linux-armv7l.tar.gz" -P /tmp
    cd /tmp
    tar -xf node-v7.4.0-linux-armv7l.tar.gz
    cd node-v7.4.0-linux-armv7l
    cp -R * /usr/local/
    rm -R /tmp/node-v7.4.0-linux-armv7l
    cd
}

function createConfigFilePlowBackRest {
    echo "=== Création du fichier de config plow back rest ==="

    echo "Suppression du fichier de configuration déjà existant: ${repertoire_git_plow_back_rest}config/local.json"
    rm ${repertoire_git_plow_back_rest}config/local.json

    echo "Création du fichier de configuration pour plow back rest: ${repertoire_git_plow_back_rest}config/local.json"

    echo "{" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"db\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"host\": \"localhost\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"database\": \"${database}\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"user\": \"root\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"password\": \"${database_password}\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"heapdump\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"activated\": false," >> ${repertoire_git_plow_python}/config_python.cfg
    echo "      \"directory\": ${repertoire_git_plow_back_rest}dump\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"minute\": 0" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"download_server\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"address\": \"${download_server_address}\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"unrar_command\": \"python3 /var/www/plow_solution/main/download_basic.py unrar\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"reset_command\": \"python3 /var/www/plow_solution/main/download_basic.py reset\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"action_command\": \"python3 /var/www/plow_solution/main/download_basic.py action\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"delete_package_files\": \"python3 /var/www/plow_solution/main/download_basic.py delete_package_files\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"start_download\": \"python3 /var/www/plow_solution/main/download_basic.py start\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"stop_download\": \"python3 /var/www/plow_solution/main/download_basic.py stop\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"stop_current_downloads\": \"python3 /var/www/plow_solution/main/download_basic.py stop_current_downloads\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"notification\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"activated\": true," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"address\": \"${notification_address}\"," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"realm\": \"realm1\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"download_status\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"WAITING\": 1," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"IN_PROGRESS\": 2," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"FINISHED\": 3," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"ERROR\": 4," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"PAUSE\": 5," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"CANCEL\": 6," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"UNDEFINED\": 7," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"STARTING\": 8," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"MOVING\": 9," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"MOVED\": 10," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"ERROR_MOVING\": 11," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"UNRARING\": 12," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"UNRAR_OK\": 13," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"UNRAR_ERROR\": 14," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"TREATMENT_IN_PROGRESS\": 999" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"}," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"action\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"status\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"WAITING\": 1," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"IN_PROGRESS\": 2" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"target\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"DOWNLOAD\": 1," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"PACKAGE\": 2" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"type\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"MOVE_DOWNLOAD\": 1," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"UNRAR_PACKAGE\": 2," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"DELETE_PACKAGE\": 3" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"property\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"DIRECTORY_SRC\": 2" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"from\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"IHM_CLIENT\": 1," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"PYTHON_CLIENT\": 2" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  \"errors\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"downloads\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"fileExists\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"code\": 10000," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"message\": \"downloads.error.FILE_EXISTS\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"deleteDownload\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"code\": 10001," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"message\": \"downloads.error.DELETE_DOWNLOAD\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"addDownload\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"code\": 10002," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"badJson\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "                  \"message\": \"downloads.error.ADD_DOWNLOAD.BAD_JSON\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"updateDownload\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"code\": 10003," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"badJson\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "                  \"message\": \"downloads.error.UPDATE_DOWNLOAD.BAD_JSON\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      \"directories\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          \"deleteDirectory\": {" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"code\": 20000," >> ${repertoire_git_plow_back_rest}config/local.json
    echo "              \"message\": \"directories.error.DELETE_DIRECTORY\"" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "          }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "      }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "  }" >> ${repertoire_git_plow_back_rest}config/local.json
    echo "}" >> ${repertoire_git_plow_back_rest}config/local.json

}

function installPlowBackRest {
    echo "=== Installation de plow back rest ==="

    echo "Adresse du dépot git de plow back rest : $git_plow_back_rest => $repertoire_git_plow_back_rest"
    git clone -b ${branch} ${git_plow_back_rest} ${repertoire_git_plow_back_rest}

    createConfigFilePlowBackRest
}

function start {
    echo "=== Démarrage de l'installation de plow back rest ==="
    installPrerequis
    installPlowBackRest
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

start