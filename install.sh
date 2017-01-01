#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

export branch
export repertoire_installation_base
export git_plowshare
export git_plow_python
export repertoire_git_plowshare
export repertoire_git_plow_python
export repertoire_telechargement
export repertoire_telechargement_temporaire
export notification_address

# installation des prerequis
chmod 777 $DIR/common/install.sh
$DIR/common/install.sh

# installation de plow_python
chmod 777 $DIR/plow_python/install.sh
$DIR/plow_python/install.sh