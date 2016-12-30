#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config/config_python.cfg

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé avec les droits super utilisateur" 1>&2
   exit 1
fi

# installation des prerequis
chmod 777 $DIR/common/install.sh
$DIR/common/install.sh
# installation de plow_python
chmod 777 $DIR/plow_python/install.sh
$DIR/plow_python/install.sh