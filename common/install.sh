#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# fonction d'installation des prerequis
function installPrerequis {
    echo "=== Installation des prérequis === "
    echo "--- Mise à jour des dépots --- "
    apt-get update
    apt-get -y upgrade

    echo "--- Installation du reste des prérequis ---"
    apt-get -y install git python2.7 python3 python-dev screen postfix build-essential openssl libssl-dev gcc mailutils mysql-client

    echo "--- Installation des librairies python ---"
    if ! which pip >/dev/null; then
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

function createDatabase {
    echo "=== Création de la base de données ==="

    mysql -u root -p${database_password} -h ${bdd_address} << EOF
CREATE DATABASE ${database} CHARACTER SET utf8 COLLATE utf8_general_ci
EOF
    echo "=== Création de la structure de la base de données ==="
    mysql -u root -p${database_password} -h ${bdd_address} ${database} < $DIR/../scripts/plowshare.sql
}

function insertDirectoriesInDatabase {
    echo "=== Insertion des repertoires ==="

    #    repertoire log
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_git_plow_python}log' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_git_plow_python}log')
EOF

#    repertoire telechargement
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement}')
EOF

#    repertoire telechargement temporaire
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement_temporaire}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement_temporaire}')
EOF

#    repertoire telechargement texte
    mysql -u root -h ${bdd_address} -p${database_password} -D ${database} << EOF
INSERT INTO directory (path) SELECT '${repertoire_telechargement_texte}' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM directory WHERE path='${repertoire_telechargement_texte}')
EOF

}

function start {
    echo "=== Démarrage de l'installation des commons ==="

    installPrerequis

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

    insertDirectoriesInDatabase
}

start