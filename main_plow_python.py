#!/usr/bin/env python
import variables
import utils
import common
import io


def install_prerequis():
    print("=== Installation des prérequis python ===")

    utils.install_package("postfix build-essential openssl libssl-dev gcc mailutils")
    utils.install_pip_package("psutil watchdog request")


def install_plow_share():
    print("=== Installation de plowshare ===")

    utils.install_package("coreutils sed util-linux grep curl recode rhino")

    print("Adresse du dépot git de plowshare : " + variables.git_plowshare + " => " + variables.repertoire_git_plowshare)
    os.system("git clone " + variables.git_plowshare + " " + variables.repertoire_git_plowshare)
    uid = pwd.getpwnam(variables.repertoire_git_plowshare).pw_uid
    gid = grp.getgrnam(variables.repertoire_git_plowshare).gr_gid
    os.chown(variables.repertoire_git_plowshare, uid, gid)
    os.chdir(variables.repertoire_git_plowshare)
    os.system("make install")
    os.system("plowmod --install")


def create_config_python_file():
    print("=== Création du fichier de config python ===")

    print("Suppression du fichier de configuration déjà existant: " + variables.repertoire_git_plow_python + "config_python.cfg")
    os.remove(variables.repertoire_git_plow_python + "config_python.cfg")

    print("Création du fichier de configuration pour plow_python: " + variables.repertoire_git_plow_python + "config_python.cfg")

    file = io.open(variables.repertoire_git_plow_python + "config_python.cfg", "w")
    file.write("# application id")
    file.write("PYTHON_APPLICATION_ID=" + variables.python_application_id)
    file.write("")
    file.write("DOWNLOAD_ACTIVATED=True")
    file.write("")
    file.write("# rest server address")
    file.write("REST_ADRESS=\"" + variables.rest_address + "\"")
    file.write("# notification server address")
    file.write("NOTIFICATION_ADDRESS=\"" + variables.notification_address + "\"")
    file.write("")
    file.write("#LEVEL_OFF = 0, LEVEL_ALERT = 1, LEVEL_ERROR = 2, LEVEL_INFO = 3, LEVEL_DEBUG = 4")
    file.write("PYTHON_LOG_LEVEL=4")
    file.write("PYTHON_LOG_CONSOLE_LEVEL=4")
    file.write("PYHTON_LOG_FORMAT=\"[%(levelname)8s]  %(asctime)s <%(to_ihm)4s>     (%(file_name)s) {%(function_name)s} [%(message)s]\"")
    file.write("")
    file.write("PYTHON_LOG_DIRECTORY=\"" + variables.repertoire_git_plow_python + "log/\"")
    file.write("PYTHON_DIRECTORY_DOWNLOAD_TEMP=\"" + variables.repertoire_telechargement_temporaire + "\"")
    file.write("PYTHON_DIRECTORY_DOWNLOAD=\"" + variables.repertoire_telechargement + "\"")
    file.write("PYTHON_DIRECTORY_DOWNLOAD_TEXT=\"" + variables.repertoire_telechargement_texte + "\"")

    file.close()


def install_plow_python():
    print("=== Installation de plow python ===")

    if not utils.is_installed("plowdown"):
        print("Attention, plowshare n'est pas installé, voulez-vous l'installer ? (o/n)")

        choice = input(" >>  ")
        if choice == 'o':
            install_plow_share()

    print("Adresse du dépot git de plow_pyhton : " + variables.git_plow_python + " => " + variables.repertoire_git_plow_python)
    os.system("git clone -b " + variables.branch + " " + variables.git_plow_python + " " + variables.repertoire_git_plow_python)

    create_config_python_file()


def insert_directories_in_database():
    print("=== Insertion des repertoires ===")

    print("Connexion ...")
    cnx = mysql.connector.connect(user='root', password=variables.database_password, host=variables.bdd_address)
    cursor = cnx.cursor()
    try:
        print("Insertion de " + variables.repertoire_git_plow_python + "log/")
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.repertoire_git_plow_python + "log/' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = " + variables.repertoire_git_plow_python + "log/')")

        # repertoire telechargement
        print("Insertion de " + variables.repertoire_telechargement)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.repertoire_telechargement + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.repertoire_telechargement + "')")

        # repertoire telechargement temporaire
        print("Insertion de " + variables.repertoire_telechargement_temporaire)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.repertoire_telechargement_temporaire + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.repertoire_telechargement_temporaire + "')")

        # repertoire telechargement texte
        print("Insertion de " + variables.repertoire_telechargement_texte)
        cursor.execute("INSERT INTO directory(path) SELECT '" + variables.repertoire_telechargement_texte + "' FROM DUAL WHERE NOT EXISTS(SELECT 1 FROM directory WHERE path = '" + variables.repertoire_telechargement_texte + "')")

    except mysql.connector.Error as err:
        print("Erreur d'insertion des répertoires: {}".format(err))

    cnx.close()


def add_to_startup():
    print("=== Ajout de plow python au démarrage ===")

    print("Voulez vous ajouter plow python au démarrage de l'appareil ? (o/n)")
    choice = input(" >>  ")

    if choice == 'o':
        file_data = None
        with open("/etc/fstab", 'r') as file:
            file_data = file.read()

        # Replace the target string
        file_data = file_data.replace("exit 0", "su pi -c 'python3 " + variables.repertoire_git_plow_python + "main/download_basic.py normal < \/dev\/null \&'\n\n\r\nexit 0")

        # Write the file out again
        with open("file.txt", 'w') as file:
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

