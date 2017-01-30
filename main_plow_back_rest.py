#!/usr/bin/env python
import variables
import utils
import common
import io
import shutil


def install_prerequis():
    print("=== Installation des prérequis plow back rest ===")

    install_node = True
    if utils.is_installed('node'):
        print("Nodejs déjà installé, réinstaller ? (o/n)")
        install_node = False
        choice = input(" >>  ")

        if choice == 'o':
            install_node = True

    if install_node:
        print("Installation de nodejs")

        print(Bcolors.FAIL + "Version de nodejs ? (defaut: " + variables.configuration.nodejs_version + ")" + Bcolors.ENDC)
        choice = input(" >>  ")
        if choice != "":
            variables.configuration.nodejs_version = choice
            choice = ""

        print(Bcolors.FAIL + "Version arm ? (defaut: " + variables.configuration.arm_version + ")" + Bcolors.ENDC)
        choice = input(" >>  ")
        if choice != "":
            variables.configuration.arm_version = choice
            choice = ""

        print("Récupération du paquet nodejs")
        urllib.urlretrieve("https://nodejs.org/dist/latest/node-v" + variables.configuration.nodejs_version + "-linux-" + variables.configuration.arm_version + ".tar.gz", filename="/tmp/node.tar.gz")
        os.chdir("/tmp")
        print("Extraction de nodejs dans le répertoire temporaire")
        os.system("tar -xf node.tar.gz")
        os.chdir("node")
        print("Copie de nodejs")
        shutil.copytree('.', '/usr/local/')
        os.chdir('~')
        shutil.rmtree('/tmp/node')


def create_config_file_plow_back_rest():
    print("=== Création du fichier de config plow back rest ===")

    print("Suppression du fichier de configuration déjà existant: " + variables.configuration.repertoire_git_plow_back_rest + "config/local.json")
    os.remove(variables.configuration.repertoire_git_plow_back_rest + "config/local.json")

    print("Création du fichier de configuration pour plow_python: " + variables.configuration.repertoire_git_plow_back_rest + "config/local.json")

    file = io.open(variables.configuration.repertoire_git_plow_back_rest + "config/local.json", "w")
    file.write("# application id")
    file.write("{")
    file.write("  \"db\": {")
    file.write("      \"host\": \"localhost\",")
    file.write("      \"database\": \"${database}\",")
    file.write("      \"user\": \"root\",")
    file.write("      \"password\": \"${database_password}\"")
    file.write("  },")
    file.write("  \"heapdump\": {")
    file.write("      \"activated\": false,")
    file.write("      \"directory\": \"${repertoire_git_plow_back_rest}dump\",")
    file.write("      \"minute\": 0")
    file.write("  },")
    file.write("  \"download_server\": {")
    file.write("      \"address\": \"${download_server_address}\",")
    file.write("      \"unrar_command\": \"python3 /var/www/plow_solution/main/download_basic.py unrar\"," )
    file.write("      \"reset_command\": \"python3 /var/www/plow_solution/main/download_basic.py reset\",")
    file.write("      \"action_command\": \"python3 /var/www/plow_solution/main/download_basic.py action\",")
    file.write("      \"delete_package_files\": \"python3 /var/www/plow_solution/main/download_basic.py delete_package_files\",")
    file.write("      \"start_download\": \"python3 /var/www/plow_solution/main/download_basic.py start\",")
    file.write("      \"stop_download\": \"python3 /var/www/plow_solution/main/download_basic.py stop\",")
    file.write("      \"stop_current_downloads\": \"python3 /var/www/plow_solution/main/download_basic.py stop_current_downloads\"")
    file.write("  },")
    file.write("  \"notification\": {")
    file.write("      \"activated\": true,")
    file.write("      \"address\": \"${notification_address}\",")
    file.write("      \"realm\": \"realm1\"")
    file.write("  },")
    file.write("  \"download_status\": {")
    file.write("      \"WAITING\": 1,")
    file.write("      \"IN_PROGRESS\": 2,")
    file.write("      \"FINISHED\": 3,")
    file.write("      \"ERROR\": 4,")
    file.write("      \"PAUSE\": 5,")
    file.write("      \"CANCEL\": 6,")
    file.write("      \"UNDEFINED\": 7,")
    file.write("      \"STARTING\": 8,")
    file.write("      \"MOVING\": 9,")
    file.write("      \"MOVED\": 10,")
    file.write("      \"ERROR_MOVING\": 11,")
    file.write("      \"UNRARING\": 12,")
    file.write("      \"UNRAR_OK\": 13,")
    file.write("      \"UNRAR_ERROR\": 14,")
    file.write("      \"TREATMENT_IN_PROGRESS\": 999")
    file.write("  },")
    file.write("  \"action\": {")
    file.write("      \"status\": {")
    file.write("          \"WAITING\": 1,")
    file.write("          \"IN_PROGRESS\": 2")
    file.write("      },")
    file.write("      \"target\": {")
    file.write("          \"DOWNLOAD\": 1,")
    file.write("          \"PACKAGE\": 2")
    file.write("      },")
    file.write("      \"type\": {")
    file.write("          \"MOVE_DOWNLOAD\": 1,")
    file.write("          \"UNRAR_PACKAGE\": 2,")
    file.write("          \"DELETE_PACKAGE\": 3")
    file.write("      },")
    file.write("      \"property\": {")
    file.write("          \"DIRECTORY_SRC\": 2")
    file.write("      }")
    file.write("  },")
    file.write("  \"from\": {")
    file.write("      \"IHM_CLIENT\": 1,")
    file.write("      \"PYTHON_CLIENT\": 2")
    file.write("  },")
    file.write("  \"errors\": {")
    file.write("      \"downloads\": {")
    file.write("          \"fileExists\": {")
    file.write("              \"code\": 10000,")
    file.write("              \"message\": \"downloads.error.FILE_EXISTS\"")
    file.write("          },")
    file.write("          \"deleteDownload\": {")
    file.write("              \"code\": 10001,")
    file.write("              \"message\": \"downloads.error.DELETE_DOWNLOAD\"")
    file.write("          },")
    file.write("          \"addDownload\": {")
    file.write("              \"code\": 10002,")
    file.write("              \"badJson\": {")
    file.write("                  \"message\": \"downloads.error.ADD_DOWNLOAD.BAD_JSON\"")
    file.write("              }")
    file.write("          },")
    file.write("          \"updateDownload\": {")
    file.write("              \"code\": 10003,")
    file.write("              \"badJson\": {")
    file.write("                  \"message\": \"downloads.error.UPDATE_DOWNLOAD.BAD_JSON\"")
    file.write("              }")
    file.write("          }")
    file.write("      },")
    file.write("      \"directories\": {")
    file.write("          \"deleteDirectory\": {")
    file.write("              \"code\": 20000,")
    file.write("              \"message\": \"directories.error.DELETE_DIRECTORY\"")
    file.write("          }")
    file.write("      }")
    file.write("  }")
    file.write("}")

    file.close()


def install_plow_back_rest():
    print("=== Installation de plow back rest ===")

    print("Adresse du dépot git de plow_back_rest : " + variables.configuration.git_plow_back_rest + " => " + variables.configuration.repertoire_git_plow_back_rest)
    os.system("git clone -b " + variables.configuration.branch + " " + variables.configuration.git_plow_back_rest + " " + variables.configuration.repertoire_git_plow_back_rest)

    os.chdir(variables.configuration.repertoire_git_plow_back_rest)
    os.system('npm install')

    create_config_file_plow_back_rest()


def add_to_startup():
    print("=== Ajout de plow back rest au démarrage ===")

    print("Voulez vous ajouter plow back rest au démarrage de l'appareil ? (o/n)")
    choice = input(" >>  ")

    if choice == 'o':
        file_data = None
        with open("/etc/fstab", 'r') as file:
            file_data = file.read()

        # Replace the target string
        file_data = file_data.replace("exit 0", "su pi -c 'python3 " + variables.configuration.repertoire_git_plow_back_rest + " && node bin/www < \/dev\/null \&'\n\n\r\nexit 0")

        # Write the file out again
        with open("file.txt", 'w') as file:
            file.write(file_data)


def main():
    print("=== Installation de plow back rest ===")

    install_prerequis()
    install_plow_back_rest()
    add_to_startup()

