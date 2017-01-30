#!/usr/bin/env python

import subprocess
import os
import mysql.connector
from mysql.connector import errorcode
import variables


def is_installed(name):
    try:
        devnull = open(os.devnull)
        subprocess.Popen([name], stdout=devnull, stderr=devnull).communicate()
    except OSError as e:
        if e.errno == os.errno.ENOENT:
            return False
    return True


def install_pip():
    print("=== Installation de pip ===")
    choice = 'o'

    if is_tool('pip3'):
        print("pip est déjà installé, le réinstaller ? (O/N)")
        choice = input(" >>  ")

    if choice == 'o':
        urllib.urlretrieve("https://bootstrap.pypa.io/get-pip.py", filename="get-pip.py")
        os.system("get-pip.py")


def update_package():
    print("=== Mise à jour des dépots ===")

    os.system("apt-get update")
    os.system("apt-get -y upgrade")


def install_package(list_package_string):
    print("=== Installation de " + list_package_string + " ===")

    os.system("apt-get install " + list_package_string + " -y")


def install_pip_package(package):
    print("=== Installation de " + package + " ===")

    os.system("pip install " + package)


def database_exists():
    print("=== Test de l'existence de la base de données ===")

    exist = false

    try:
        cnx = mysql.connector.connect(user='root', password=variables.configuration.database_password, host=variables.configuration.bdd_address, database=variables.configuration.database)

        print("La base de données " + variables.configuration.database + " existe")
        exist = true
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Erreur de connexion")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("La base de données n'existe pas")
        else:
            print("Erreur")
            print(err)
    else:
        cnx.close()

    return exist


def create_database():
    if not database_exists():
        print("La base de données " + variables.configuration.database + " n'existe pas, la créer ? (o/n)")
        choice = input(" >>  ")

        if choice == 'o':
            print("=== Création de la base de données ===")
            print("Connexion ...")
            cnx = mysql.connector.connect(user='root', password=variables.configuration.database_password, host=variables.configuration.bdd_address)
            cursor = cnx.cursor()
            try:
                print("Création de la base de données")
                cursor.execute("CREATE DATABASE " + variables.configuration.database + " CHARACTER SET utf8 COLLATE utf8_general_ci")
            except mysql.connector.Error as err:
                print("Erreur de création de la base de données: {}".format(err))

            cnx.close()

            print("Création de la structure de la base de données")
            os.system("mysql -u root -p" + variables.configuration.database_password + " -h " + variables.configuration.bdd_address + " " + variables.configuration.database + " < " + os.path.dirname(os.path.abspath(__file__)) + "/scripts/plowshare.sql")

