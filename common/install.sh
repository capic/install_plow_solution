#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function updatePackage {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade
}

function createDatabase {
    echo "=== Création de la base de données ==="

    mysql -u root -p${database_password} -h ${bdd_address} << EOF
CREATE DATABASE ${database} CHARACTER SET utf8 COLLATE utf8_general_ci
EOF
    echo "=== Création de la structure de la base de données ==="
    mysql -u root -p${database_password} -h ${bdd_address} ${database} < $DIR/../scripts/plowshare.sql
}



function start {
    updatePackage

    echo "Test de l'existence de la BDD"
    # on teste si la bdd existe
    # => si non on demande si on doit la créer ou pas
    RESULT=`mysqlshow -u root -p${database_password} -h ${bdd_address} ${database}| grep -v Wildcard | grep -o ${database}`
    if [ "$RESULT" == "" ]; then
        options=("Oui" "Non")
        PS3=" La base de données ${database} n'existe pas, la créer ?"
        select opt in "${options[@]}" "Quit"; do
            case "$REPLY" in
                1 )createDatabase; break;;
                2 ) break;;
                *) echo "Le choix n'est pas correct";continue;;
            esac
        done
    else

        echo "La base de données existe déjà"
    fi
}

start