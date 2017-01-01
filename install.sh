#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config/config_install.cfg

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function configureGeneralsVariables {
    echo "=== Configuration des variables générales ==="
    echo "Branche git ? (defaut: ${branch})"
    read branch_input
    if [ ! -z "${branch_input}" ]; then
        branch=${branch_input}
    fi
    echo "Id de la configuration en base de données ? (defaut: ${python_application_id})"
    read python_application_id_input
    if [ ! -z "${python_application_id_input}" ]; then
        python_application_id=${python_application_id_input}
    fi
#    on sauvegarde le repertoire defini par defaut (utile pour plus tard)
    repertoire_installation_base_defaut=${repertoire_installation_base}
    echo "Chemin de base de l'installation ? (defaut: ${repertoire_installation_base})"
    read repertoire_installation_base_input
    if [ ! -z "${repertoire_installation_base_input}" ]; then
        repertoire_installation_base=${repertoire_installation_base_input}
    fi
    echo "Chemin repertoire téléchargement ? (defaut: ${repertoire_telechargement})"
    read repertoire_telechargement_input
    if [ ! -z "${repertoire_telechargement_input}" ]; then
        repertoire_telechargement=${repertoire_telechargement_input}
    fi
    echo "Chemin repertoire téléchargement temporaire ? (defaut: ${repertoire_telechargement_temporaire})"
    read repertoire_telechargement_temporaire_input
    if [ ! -z "${repertoire_telechargement_temporaire_input}" ]; then
        repertoire_telechargement_temporaire=${repertoire_telechargement_temporaire_input}
    fi
    echo "Chemin repertoire téléchargement texte ? (defaut: ${repertoire_telechargement_texte})"
    read repertoire_telechargement_texte_input
    if [ ! -z "${repertoire_telechargement_texte_input}" ]; then
        repertoire_telechargement_texte=${repertoire_telechargement_texte_input}
    fi
    echo "Adresse base de données ? (defaut: ${bdd_address})"
    read bdd_address_input
    if [ ! -z "${bdd_address_input}" ]; then
        bdd_address=${bdd_address_input}
    fi
    echo "Adresse serveur ? (defaut: ${rest_address})"
    read rest_address_input
    if [ ! -z "${rest_address_input}" ]; then
        rest_address=${rest_address_input}
    fi
    echo "Adresse serveur de notification ? (defaut: ${notification_address})"
    read notification_address_input
    if [ ! -z "${notification_address_input}" ]; then
        notification_address=${notification_address_input}
    fi
}

function menu {
    echo "================ MENU ================"
    options=("Installation de plow python")
    PS3="Installations ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) installPlowPython; break;;
           $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
}

function configurePlowPythonVariables {
    echo "=== Configuration des variables de plow python ==="
    echo "Chemin d'installation de plow python ? (defaut: ${repertoire_git_plow_python})"
    read -p ${repertoire_installation_base} repertoire_git_plow_python_input
    if [ ! -z "${repertoire_git_plow_python_input}" ]; then
        repertoire_git_plow_python=${repertoire_installation_base}${repertoire_git_plow_python_input}
    elif [ "${repertoire_installation_base_defaut}" != "${repertoire_installation_base}" ]; then
        repertoire_git_plow_python=${repertoire_git_plow_python/${repertoire_installation_base_defaut}/${repertoire_installation_base}}
    fi
}

function installPlowPython {
    configurePlowPythonVariables

    # installation de plow_python
    chmod 777 $DIR/plow_python/install.sh
    $DIR/plow_python/install.sh
}

function configDatabase {
    echo "Configuration de la base de données"

    mysql -u root -h ${bdd_address} -D ${database} << EOF
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
        3,
        4,
        1,
        2,
        4,
        ${notification_address},
        120);
EOF
}

function start {
    configureGeneralsVariables

    export branch
    export python_application_id
    export repertoire_installation_base_defaut
    export repertoire_installation_base
    export git_plowshare
    export git_plow_python
    export repertoire_git_plow_python
    export repertoire_git_plowshare
    export repertoire_telechargement
    export repertoire_telechargement_temporaire
    export repertoire_telechargement_texte
    export rest_address
    export notification_address

    # installation des prerequis
    chmod 777 $DIR/common/install.sh
    $DIR/common/install.sh

    menu

    configDatabase
}

start
