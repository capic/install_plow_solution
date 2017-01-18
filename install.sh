#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config/config_install.cfg

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function installCommonPython {
    install_pip=true
    if  which pip >/dev/null; then
        echo "pip est déjà installé, le réinstaller ? (O/N)"
        read install_pip
    fi

    if [ ${install_pip} = 'o' ]; then
        wget https://bootstrap.pypa.io/get-pip.py
        python get-pip.py
    fi
}

function configureCommonsVariables_1 {
    echo "=== Configuration des variables générales 1 ==="

    #    on sauvegarde le repertoire defini par defaut (utile pour plus tard)
    repertoire_installation_base_defaut=${repertoire_installation_base}
    echo -e "\e[31mChemin de base de l'installation ? (defaut: ${repertoire_installation_base})\e[39m"
    read repertoire_installation_base_input
    if [ ! -z "${repertoire_installation_base_input}" ]; then
        repertoire_installation_base=${repertoire_installation_base_input}
    fi
}

function configureCommonsVariables_2 {
    echo "=== Configuration des variables générales 2 ==="

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
    echo "\r\n"
}

function configurePlowPythonVariables {
    echo "=== Configuration des variables de plow python ==="

    echo -e "\e[31mId de la configuration en base de données ? (defaut: ${python_application_id})\e[39m"
    read python_application_id_input
    if [ ! -z "${python_application_id_input}" ]; then
        python_application_id=${python_application_id_input}
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
}

function configurePlowBackRestVariables {
    echo -e "\e[31mAdresse serveur de telechargement ? (defaut: ${download_server_address})\e[39m"
    read download_address_input
    if [ ! -z "${download_address_input}" ]; then
        download_server_address=${download_server_address_input}
    fi
}

function menu {
    echo "================ MENU ================"
    options=("Installation de plow python", "Installation de plow back rest", "Installation de plow notification", "Installation des dossiers paratagés")
    PS3="Installations ?"
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            1 ) installPlowPython; break;;
            2 ) installPlowBackRest; break;;
            3 ) installPlowNotification; break;;
            4 ) createSharedDirectories; break;;
           $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *) echo "Le choix n'est pas correct";continue;;
        esac
    done
}

function installPlowPython {
    echo "=== Installation de plow python ==="

    configureCommonsVariables_1
    configureCommonsVariables_2
    configurePlowPythonVariables
    exportVariables

    installCommonPython
    installPreInstall

    # installation de plow_python
    chmod 777 $DIR/plow_python/install.sh
    $DIR/plow_python/install.sh

    installPostInstall
}

function installPlowBackRest {
    echo "=== Installation de plow back rest ==="

    configureCommonsVariables_1
    configureCommonsVariables_2
    configurePlowBackRestVariables
    exportVariables

    installPreInstall

    # installation de plow back rest
    chmod 777 $DIR/plow_back_rest/install.sh
    $DIR/plow_back_rest/install.sh
}

function installPlowNotification {
    echo "=== Installation de plow notification ==="

    configureCommonsVariables_1
    exportVariables

    installCommonPython

    # installation de plow notification
    chmod 777 $DIR/plow_notification/install.sh
    $DIR/plow_notification/install.sh
}

function installPreInstall {
    echo "=== Installation des éléments pré installation ==="

    chmod 777 $DIR/pre-install/install.sh
    $DIR/pre-install/install.sh
}

function installPostInstall {
    echo "=== Installation des éléments post installation ==="

    # installation des prerequis
    chmod 777 $DIR/post-install/install.sh
    $DIR/post-install/install.sh
}

function createSharedDirectories {
    echo "=== Création des répertoires partagés inexistants ==="

    toAdd=true

    while [ ${toAdd} = true ]; do
        options=("Oui" "Non")
        PS3="Créer un répertoire partagé ?"
        select opt in "${options[@]}" "Quit"; do
            case "$REPLY" in
                1 ) echo "Chemin local du répertoire"
                    read chemin
                    if [ ! -d "${chemin}" ]; then
                        echo "Création pysique du répertoire ${chemin}"
                        mkdir -p ${chemin};
                        chmod -R 777 ${chemin};
                    fi

                    options=("Oui" "Non")
                    PS3="Ajout du repertoire pour qu'il soit monté au démarrage ?"
                    select opt in "${options[@]}" "Quit"; do
                        case "$REPLY" in
                            1 ) echo "Chemin distant"
                                read chemin_distant

                                options=("ntfs" "nfs")
                                PS3="Type de montage"
                                select opt in "${options[@]}" "Quit"; do
                                    case "$REPLY" in
                                        1 ) type="ntfs-3g"; break;;
                                        2 ) type="nfs"; break;;
                                    esac
                                done
                                echo "${chemin_distant} ${chemin}   ${type} defaults,nofail 0   0" >> /etc/fstab

                                break;;
                            2 ) break;;
                            *) echo "Le choix n'est pas correct";continue;;
                        esac
                     done
                    break;;
                2 ) toAdd=false
                    break;;
                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
    done
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
