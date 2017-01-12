#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#source $DIR/config/config_install.cfg

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    apt-get -y install git python2.7 python3 python-dev screen postfix build-essential openssl libssl-dev gcc mailutils

    echo "--- Installation des librairies python ---"
    if ! which pip3 >/dev/null; then
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

function createConfigPythonFile {
    echo "=== Création du fichier de config python ==="

    echo "Suppression du fichier de configuration déjà existant: ${repertoire_git_plow_python}config_python.cfg"
    rm ${repertoire_git_plow_python}config_python.cfg

    echo "Création du fichier de configuration pour plow_python: ${repertoire_git_plow_python}config_python.cfg"

    echo "# application id" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_APPLICATION_ID=${python_application_id}" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "DOWNLOAD_ACTIVATED=True" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "# rest server address" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "REST_ADRESS=\"${rest_address}/\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "# notification server address" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "NOTIFICATION_ADDRESS=\"${notification_address}\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "#LEVEL_OFF = 0, LEVEL_ALERT = 1, LEVEL_ERROR = 2, LEVEL_INFO = 3, LEVEL_DEBUG = 4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_LOG_LEVEL=4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_LOG_CONSOLE_LEVEL=4" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYHTON_LOG_FORMAT=\"[%(levelname)8s]  %(asctime)s <%(to_ihm)4s>     (%(file_name)s) {%(function_name)s} [%(message)s]\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo ""
    echo "PYTHON_LOG_DIRECTORY=\"${repertoire_git_plow_python}log/\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_DIRECTORY_DOWNLOAD_TEMP=\"${repertoire_telechargement_temporaire}\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_DIRECTORY_DOWNLOAD=\"${repertoire_telechargement}\"" >> ${repertoire_git_plow_python}/config_python.cfg
    echo "PYTHON_DIRECTORY_DOWNLOAD_TEXT=\"${repertoire_telechargement_texte}\"" >> ${repertoire_git_plow_python}/config_python.cfg
}

# fonction d'installaion de plowshare et de ses prerequis
function installPlowshare {
    echo "=== Installation de plowshare === "

    apt-get -y install coreutils sed util-linux grep curl recode rhino

    echo "Adresse du dépot git de plowshare : ${git_plowshare} => $repertoire_git_plowshare"
    git clone $git_plowshare $repertoire_git_plowshare
    chown $(whoami) $repertoire_git_plowshare
    cd $repertoire_git_plowshare
    make install
    plowmod --install

    echo "=== Fin d'installation de plowshare === "
}

function installPlowPython {
    echo "=== Installation de plow python ==="

    echo "*** Teste si plowdown est installé ****"
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
    else
        echo "Plowshare est déjà installé"
    fi

    echo "Adresse du dépot git de plow_pyhton : $git_plow_python => $repertoire_git_plow_python"
    git clone -b ${branch} $git_plow_python $repertoire_git_plow_python

    createConfigPythonFile
}

function insertDirectoriesInDatabase {
    echo "=== Insertion des repertoires ==="


    #    repertoire log
    echo "Insertion de ${repertoire_git_plow_python}log/"
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_git_plow_python}log/' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_git_plow_python}log/')
EOF

#    repertoire telechargement
    echo "Insertion de ${repertoire_telechargement}"
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement}')
EOF

#    repertoire telechargement temporaire
    echo "Insertion de ${repertoire_telechargement_temporaire}"
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement_temporaire}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement_temporaire}')
EOF

#    repertoire telechargement texte
    echo "Insertion de ${repertoire_telechargement_texte}"
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement_texte}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement_texte}')
EOF

}

function start {
    installPrerequis
    installPlowPython
    insertDirectoriesInDatabase
}

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

start