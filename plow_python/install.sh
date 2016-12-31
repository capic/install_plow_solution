#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../config/config_install.cfg


function createConfigPythonFile {
    echo "Suppression du fichier de configuration déjà existant"
    rm ${repertoire_git_plow_python}/config_python.cfg

    echo "Création du fichier de configuration pour plow_python"

    echo "# application id" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_APPLICATION_ID=1" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "DOWNLOAD_ACTIVATED=True" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "# rest server address" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "REST_ADRESS=\"http://192.168.1.101:3000/\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "# notification server address" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "NOTIFICATION_ADDRESS=\"${notification_address}\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "#LEVEL_OFF = 0, LEVEL_ALERT = 1, LEVEL_ERROR = 2, LEVEL_INFO = 3, LEVEL_DEBUG = 4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_LOG_LEVEL=4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_LOG_CONSOLE_LEVEL=4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYHTON_LOG_FORMAT=\"[%(levelname)8s]  %(asctime)s <%(to_ihm)4s>     (%(file_name)s) {%(function_name)s} [%(message)s]\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo ""
    echo "PYTHON_LOG_DIRECTORY=\"${repertoire_git_plow_python}log\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_DIRECTORY_DOWNLOAD_TEMP=\"${repertoire_telechargement_temporaire}\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_DIRECTORY_DOWNLOAD=\"${repertoire_telechargement}\"" >> ${repertoire_git_plow_python}/config_python.cfg
}

# fonction d'installaion de plowshare et de ses prerequis
function installPlowshare {
    echo "=== Installation des prérequis plowshare === "
    echo "*** Teste si plowdown est installé ****"
    if ! which plowdown >/dev/null; then
        apt-get -y install coreutils sed util-linux grep curl recode rhino
        echo "=== Installation de plowshare === "
        echo "Adresse du dépot git de plowdown : ${git_plowhare} => $repertoire_git_plowhare"
        git clone $git_plowhare $repertoire_git_plowhare
        chown $(whoami) $repertoire_git_plowhare
        cd $repertoire_git_plowhare
        make install
        plowmod --install
    fi
    echo "=== Fin d'installation de plowshare === "
}

function installPlowPython {
     if ! which plowdown >/dev/null; then
        options=("Oui" "Non")
        PS3="Attention, plowshare n'est pas installé, voulez-vous l'installer ?"
        select opt in "${options[@]}" "Quit"; do
            case "$REPLY" in
                1 ) installPlowshare; break;;
                2 ) break;;
                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
    fi

    echo "Adresse du dépot git de plow_pyhton : $git_plow_python => $repertoire_git_plow_python"
    echo "Téléchargement du gestionnaire de téléchargements"
    git clone -b dev $git_plow_python $repertoire_git_plow_python
    echo "Création du répertoire de log"
    mkdir ${repertoire_git_plow_python}/log

    createConfigPythonFile
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

installPlowPython