#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

function configureVariable {
    echo "=== Configuration des variables générales ==="
    echo "Branche git ? (defaut: ${branch})"
    read branch_input
    if [ ! -z "${branch_input}" ]; then
        branch=${branch_input}
    fi
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
    echo "Adresse serveur de notification ? (defaut: ${notification_address})"
    read notification_address_input
    if [ ! -z "${notification_address_input}" ]; then
        notification_address=${notification_address_input}
    fi
}

function displayConfig {
    echo "=== Configuration ==="
    echo "Branche git: ${branch}"
    echo "Chemin de base de l'installation: ${repertoire_installation_base}"
    echo "Chemin d'installation de plow python: ${repertoire_git_plow_python}"
    echo "Chemin repertoire téléchargement: ${repertoire_telechargement}"
    echo "Chemin repertoire téléchargement temporaire: ${repertoire_telechargement_temporaire}"
    echo "Adresse serveur de notification: ${notification_address}"
}

configureVariable

export branch
export repertoire_installation_base
export git_plowshare
export git_plow_python
export repertoire_git_plowshare
export repertoire_telechargement
export repertoire_telechargement_temporaire
export notification_address

# installation des prerequis
chmod 777 $DIR/common/install.sh
$DIR/common/install.sh

# installation de plow_python
chmod 777 $DIR/plow_python/install.sh
$DIR/plow_python/install.sh