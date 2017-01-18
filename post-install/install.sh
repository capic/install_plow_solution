#!/usr/bin/env bash

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

function start {
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

start