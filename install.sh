#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config/config_install.cfg

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function configureCommonsVariables {
    echo "=== Configuration des variables générales ==="
    echo -e "\e[31mBranche git ? (defaut: ${branch})\e[39m"
    read branch_input
    if [ ! -z "${branch_input}" ]; then
        branch=${branch_input}
    fi
    echo -e "\e[31mAdresse base de données ? (defaut: ${bdd_address})\e[39m"
    read bdd_address_input
    if [ ! -z "${bdd_address_input}" ]; then
        bdd_address=${bdd_address_input}
    fi
    echo -e "\e[31mNom base de données ? (defaut: ${database})\e[39m"
    read database_input
    if [ ! -z "${database_input}" ]; then
        database=${database_input}
    fi
    echo -e "\e[31mAdresse serveur de notification ? (defaut: ${notification_address})\e[39m"
    read notification_address_input
    if [ ! -z "${notification_address_input}" ]; then
        notification_address=${notification_address_input}
    fi

    echo "Connexion au serveur de base de données pour verifier si la base existe ..."
    read -s -p "Mot de passe: " database_password

    exportVariables
}

function configurePlowPythonVariables {
    configureCommonsVariables

    echo "=== Configuration des variables de plow python ==="

    echo -e "\e[31mId de la configuration en base de données ? (defaut: ${python_application_id})\e[39m"
    read python_application_id_input
    if [ ! -z "${python_application_id_input}" ]; then
        python_application_id=${python_application_id_input}
    fi
    #    on sauvegarde le repertoire defini par defaut (utile pour plus tard)
    repertoire_installation_base_defaut=${repertoire_installation_base}
    echo -e "\e[31mChemin de base de l'installation ? (defaut: ${repertoire_installation_base})\e[39m"
    read repertoire_installation_base_input
    if [ ! -z "${repertoire_installation_base_input}" ]; then
        repertoire_installation_base=${repertoire_installation_base_input}
    fi
    echo -e "\e[31mChemin repertoire téléchargement ? (defaut: ${repertoire_telechargement})\e[39m"
    read repertoire_telechargement_input
    if [ ! -z "${repertoire_telechargement_input}" ]; then
        repertoire_telechargement=${repertoire_telechargement_input}
    fi
    echo -e "\e[31mChemin repertoire téléchargement temporaire ? (defaut: ${repertoire_telechargement_temporaire})\e[39m"
    read repertoire_telechargement_temporaire_input
    if [ ! -z "${repertoire_telechargement_temporaire_input}" ]; then
        repertoire_telechargement_temporaire=${repertoire_telechargement_temporaire_input}
    fi
    echo -e "\e[31mChemin repertoire téléchargement texte ? (defaut: ${repertoire_telechargement_texte})\e[39m"
    read repertoire_telechargement_texte_input
    if [ ! -z "${repertoire_telechargement_texte_input}" ]; then
        repertoire_telechargement_texte=${repertoire_telechargement_texte_input}
    fi
    echo "Chemin d'installation de plow python ? (defaut: ${repertoire_git_plow_python})"
    read -p ${repertoire_installation_base} repertoire_git_plow_python_input
    if [ ! -z "${repertoire_git_plow_python_input}" ]; then
        repertoire_git_plow_python=${repertoire_installation_base}${repertoire_git_plow_python_input}
    elif [ "${repertoire_installation_base_defaut}" != "${repertoire_installation_base}" ]; then
        repertoire_git_plow_python=${repertoire_git_plow_python/${repertoire_installation_base_defaut}/${repertoire_installation_base}}
    fi
    echo -e "\e[31mAdresse serveur ? (defaut: ${rest_address})\e[39m"
    read rest_address_input
    if [ ! -z "${rest_address_input}" ]; then
        rest_address=${rest_address_input}
    fi

    exportVariables
}

function configurePlowBackRestVariables {
    configureCommonsVariables

    echo -e "\e[31mAdresse serveur de telechargement ? (defaut: ${download_server_address})\e[39m"
    read download_address_input
    if [ ! -z "${download_address_input}" ]; then
        download_server_address=${download_server_address_input}
    fi

    exportVariables
}

function menu {
    echo "================ MENU ================"
    options=("Installation de plow python", "Installation de plow back rest")
    PS3="Installations ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) installPlowPython; break;;
            2 ) installPlowBackRest; break;;
            3 ) installPlowNotification; break;;
           $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
}

function installPlowPython {
    echo "=== Installation de plow python ==="
    configurePlowPythonVariables

    installCommon

    # installation de plow_python
    chmod 777 $DIR/plow_python/install.sh
    $DIR/plow_python/install.sh

    createDirectories

    echo "================= Configuration BDD ================="
    options=("Oui" "Non")
    PS3="Insérer la configuration (Effacera la version actuelle si elle existe)?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) configDatabase; break;;
            2 ) break;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
}

function installPlowBackRest {
    echo "=== Installation de plow back rest ==="
    configurePlowBackRestVariables

    installCommon

    # installation de plow back rest
    chmod 777 $DIR/plow_back_rest/install.sh
    $DIR/plow_back_rest/install.sh
}

function installPlowNotification {
    echo "=== Installation de plow notification ==="

    # installation de plow notification
    chmod 777 $DIR/plow_notification/install.sh
    $DIR/plow_notification/install.sh
}

function installCommon {
    echo "=== Installation des commons ==="

    # installation des prerequis
    chmod 777 $DIR/common/install.sh
    $DIR/common/install.sh
}

function configDatabase {
    echo "=== Configuration de la base de données ==="

    echo "Insertion des repertoires si ils n'existent pas"
    python_log_directory_id=`mysql -u root -h ${bdd_address} -p${database_password} -D ${database} -ss -e "SELECT id FROM directory WHERE path='"${repertoire_git_plow_python}"log/'"`
    echo "id de ${repertoire_git_plow_python}log/: ${python_log_directory_id}"
    python_directory_download_temp_id=`mysql  -u root -h ${bdd_address} -p${database_password} -D ${database} -ss -e "SELECT id FROM directory WHERE path='"${repertoire_telechargement_temporaire}"'"`
    echo "id de ${repertoire_telechargement_temporaire}: ${python_directory_download_temp_id}"
    python_directory_download_id=`mysql -u root -h ${bdd_address} -p${database_password} -D ${database} -ss -e "SELECT id FROM directory WHERE path='"${repertoire_telechargement}"'"`
    echo "id de ${repertoire_telechargement}: ${python_directory_download_id}"
    python_directory_download_text_id=`mysql -u root -h ${bdd_address} -p${database_password} -D ${database} -ss -e "SELECT id FROM directory WHERE path='"${repertoire_telechargement_texte}"'"`
    echo "id de ${repertoire_telechargement_texte}: ${python_directory_download_text_id}"

    echo "Insetion de la configuration id: ${python_application_id}"
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
    insert into application_configuration(
        id_application,
        download_activated,
        api_log_database_level,
        python_log_level,
        python_log_format,
        python_log_directory_id,
        python_log_console_level,
        python_directory_download_temp_id,
        python_directory_download_id,
        python_directory_download_text_id,
        notification_address,
        periodic_check_minutes)
    values (
        ${python_application_id},
        true,
        4,
        4,
        '[%(levelname)8s]  %(asctime)s <%(to_ihm)4s>     (%(file_name)s) {%(function_name)s} [%(message)s]',
        ${python_log_directory_id},
        4,
        ${python_directory_download_temp_id},
        ${python_directory_download_id},
        ${python_directory_download_text_id},
        '${notification_address}',
        120)
    on duplicate key update
        python_log_directory_id = ${python_log_directory_id},
        python_directory_download_temp_id = ${python_directory_download_temp_id},
        python_directory_download_id =  ${python_directory_download_id},
        python_directory_download_text_id = ${python_directory_download_text_id},
        notification_address = '${notification_address}'
EOF
}

function createDirectories {
    echo "=== Création des répertoires inexistants ==="

    if [ ! -d "${repertoire_git_plow_python}log" ]; then
        echo "Création du répertoire de logs de plow python: ${repertoire_git_plow_python}log"
        mkdir -p ${repertoire_git_plow_python}log
        chmod -R 777 ${repertoire_git_plow_python}log
    fi

    if [ ! -d "${repertoire_telechargement}" ]; then
        echo "Création du répertoire de telechargement: ${repertoire_telechargement}"
        mkdir -p ${repertoire_telechargement}
        chmod -R 777 ${repertoire_telechargement}
    fi

    if [ ! -d "${repertoire_telechargement_temporaire}" ]; then
        echo "Création du répertoire de telechargement temporaire: ${repertoire_telechargement_temporaire}"
        mkdir -p ${repertoire_telechargement_temporaire}
        chmod -R 777 ${repertoire_telechargement_temporaire}
    fi

    if [ ! -d "${repertoire_telechargement_texte}" ]; then
        echo "Création du répertoire de telechargement texte: ${repertoire_telechargement_texte}"
        mkdir -p ${repertoire_telechargement_texte}
        chmod -R 777 ${repertoire_telechargement_texte}
    fi
}

function exportVariables {
    export branch
    export python_application_id
    export repertoire_installation_base_defaut
    export repertoire_installation_base
    export git_plowshare
    export git_plow_python
    export git_plow_back_rest
    export repertoire_git_plow_python
    export repertoire_git_plowshare
    export repertoire_git_plow_back_rest
    export repertoire_telechargement
    export repertoire_telechargement_temporaire
    export repertoire_telechargement_texte
    export bdd_address
    export rest_address
    export notification_address
    export database
    export database_password
    export nodejs_version
    export arm_version
    export download_server_address
}

function start {
    echo "=== Démarrage de l'installation ==="

     menu
}

start
