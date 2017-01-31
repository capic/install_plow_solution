#!/usr/bin/env python
import variables
import utils
import io
import os
import pwd
import mysql


def install_prerequis():
    print("=== Installation des prérequis python ===")

    utils.install_package("postfix build-essential openssl libssl-dev gcc mailutils")
    utils.install_pip_package("psutil watchdog request")


def install_plow_share():
    print("=== Installation de plowshare ===")

    utils.install_package("coreutils sed util-linux grep curl recode rhino")

    print("Adresse du dépot git de plowshare : " + variables.configuration.git_plowshare + " => " + variables.configuration.repertoire_git_plowshare)
    os.system("git clone " + variables.configuration.git_plowshare + " " + variables.configuration.repertoire_git_plowshare)
    # uid = pwd.getpwnam(variables.configuration.repertoire_git_plowshare).pw_uid
    # gid = grp.getgrnam(variables.configuration.repertoire_git_plowshare).gr_gid
    # os.chown(variables.configuration.repertoire_git_plowshare, uid, gid)
    os.chdir(variables.configuration.repertoire_git_plowshare)
    os.system("make install")
    os.system("plowmod --install")


def create_config_python_file():
    print("=== Création du fichier de config python ===")

    print("Suppression du fichier de configuration déjà existant: " + variables.configuration.repertoire_git_plow_python + "config_python.cfg")
    os.remove(variables.configuration.repertoire_git_plow_python + "config_python.cfg")

    print("Création du fichier de configuration pour plow_python: " + variables.configuration.repertoire_git_plow_python + "config_python.cfg")

    file = io.open(variables.configuration.repertoire_git_plow_python + "config_python.cfg", "w")
    file.write("# application id")
    file.write("PYTHON_APPLICATION_ID=%d" % variables.configuration.python_application_id)
    file.write("")
    file.write("DOWNLOAD_ACTIVATED=True")
    file.write("")
    file.write("# rest server address")
    file.write("REST_ADRESS=\"%s\"" % variables.configuration.rest_address)
    file.write("# notification server address")
    file.write("NOTIFICATION_ADDRESS=\"%s\"" % variables.configuration.notification_address)
    file.write("")
    file.write("#LEVEL_OFF = 0, LEVEL_ALERT = 1, LEVEL_ERROR = 2, LEVEL_INFO = 3, LEVEL_DEBUG = 4")
    file.write("PYTHON_LOG_LEVEL=4")
    file.write("PYTHON_LOG_CONSOLE_LEVEL=4")
    file.write("PYHTON_LOG_FORMAT=\"[%(levelname)8s]  %(asctime)s <%(to_ihm)4s>     (%(file_name)s) {%(function_name)s} [%(message)s]\"")
    file.write("")
    file.write("PYTHON_LOG_DIRECTORY=\"%slog\"" % variables.configuration.repertoire_git_plow_python)
    file.write("PYTHON_DIRECTORY_DOWNLOAD_TEMP=\"%s\"" % variables.configuration.repertoire_telechargement_temporaire )
    file.write("PYTHON_DIRECTORY_DOWNLOAD=\"%s\"" % variables.configuration.repertoire_telechargement)
    file.write("PYTHON_DIRECTORY_DOWNLOAD_TEXT=\"%s\"" % variables.configuration.repertoire_telechargement_texte)

    file.close()


def install_plow_python():
    print("=== Installation de plow python ===")

    if not utils.is_installed("plowdown"):
        print("Attention, plowshare n'est pas installé, voulez-vous l'installer ? (o/n)")

        choice = input(" >>  ")
        if choice == 'o':
            install_plow_share()

    print("Adresse du dépot git de plow_pyhton : " + variables.configuration.git_plow_python + " => " + variables.configuration.repertoire_git_plow_python)
    os.system("git clone -b " + variables.configuration.branch + " " + variables.configuration.git_plow_python + " " + variables.configuration.repertoire_git_plow_python)

    create_config_python_file()


def insert_directories_in_database():
    print("=== Insertion des repertoires ===")

    print("Connexion ...")
    cnx = mysql.connector.connect(user='root', password=variables.configuration.database_password, host=variables.configuration.bdd_address, database=variables.configuration.database)
    cursor = cnx.cursor()
    try:
        print("Insertion de " + variables.configuration.repertoire_git_plow_python + "log/")
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.configuration.repertoire_git_plow_python + "log/' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.configuration.repertoire_git_plow_python + "log/')")

        # repertoire telechargement
        print("Insertion de " + variables.configuration.repertoire_telechargement)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.configuration.repertoire_telechargement + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.configuration.repertoire_telechargement + "')")

        # repertoire telechargement temporaire
        print("Insertion de " + variables.configuration.repertoire_telechargement_temporaire)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.configuration.repertoire_telechargement_temporaire + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.configuration.repertoire_telechargement_temporaire + "')")

        # repertoire telechargement texte
        print("Insertion de " + variables.configuration.repertoire_telechargement_texte)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.configuration.repertoire_telechargement_texte + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.configuration.repertoire_telechargement_texte + "')")

    except mysql.connector.Error as err:
        print("Erreur d'insertion des répertoires: {}".format(err))

    cnx.close()


def add_to_startup():
    print("=== Ajout de plow python au démarrage ===")

    print("Voulez vous ajouter plow python au démarrage de l'appareil ? (o/n)")
    choice = input(" >>  ")

    if choice == 'o':
        file_data = None
        with open("/etc/rc.local", 'r') as file:
            file_data = file.read()

        replace_string = "su pi -c 'python3 " + variables.configuration.repertoire_git_plow_python + "main/download_basic.py normal < \/dev\/null \&'\n\n\r\n"
        p = file_data.rfind(replace_string)
        file_data = file_data[:p] + "" + file_data[p+len(replace_string):]

        print("Remplace \"exit 0\" par \"" + replace_string + "exit 0\"")
        # Replace the target string
        p = file_data.rfind("exit 0")
        file_data = file_data[:p] + replace_string + file_data[p:]

        # Write the file out again
        with open("/etc/rc.local", 'w') as file:
            file.write(file_data)


def main():
    print("=== Installation de plow python ===")

    variables.configure_commons_variables_1()
    variables.configure_commons_variables_2()
    variables.configure_plow_python_variables()

    install_prerequis()
    install_plow_python()
    insert_directories_in_database()
    add_to_startup()

