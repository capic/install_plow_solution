#!/usr/bin/env python

import configparser
import os

from Bcolors import Bcolors


repertoire_installation_base_defaut = ""
repertoire_installation_base = ""
branch = ""
bdd_address = ""
database = ""
notification_address = ""
database_password = ""
python_application_id = -1
repertoire_telechargement = ""
repertoire_telechargement_temporaire = ""
repertoire_telechargement_texte = ""
repertoire_git_plow_python = ""
rest_address = ""
download_server_address = ""
git_plowshare = ""
repertoire_git_plowshare = ""
git_plow_python = ""
repertoire_git_plow_python = ""
nodejs_version = ""
arm_version = ""
repertoire_git_plow_back_rest = ""
git_plow_back_rest = ""


def load_config():
    print("=== Chargement de la config " + os.path.dirname(os.path.abspath(__file__)) + "/config/config_install.ini ===")
    config = configparser.ConfigParser()
    config.read(os.path.dirname(os.path.abspath(__file__)) + "/config/config_install.ini")

    print(config.sections())

    # repertoire_git_plow_python = config['DEFAULT']['repertoire_git_plow_python']
    # repertoire_installation_base = config['repertoire_installation_base']
    branch = config['DEFAULT']['branch']
    # bdd_address = config['bdd_address']
    # database = config['database']
    # notification_address = config['repertoire_git_plow_python']
    # python_application_id = config['python_application_id']
    # repertoire_telechargement = config['repertoire_telechargement']
    # repertoire_telechargement_temporaire = config['repertoire_telechargement_temporaire']
    # repertoire_telechargement_texte = config['repertoire_telechargement_texte']
    # rest_address = config['rest_address']
    # download_server_address = config['download_server_address']
    # git_plowshare = config['git_plowshare']
    # repertoire_git_plowshare = config['repertoire_git_plowshare']
    # git_plow_python = config['git_plow_python']
    # repertoire_git_plow_python = config['repertoire_git_plow_python']
    # nodejs_version = config['nodejs_version']
    # arm_version = config['arm_version']
    # repertoire_git_plow_back_rest = config['repertoire_git_plow_back_rest']
    # git_plow_back_rest = config['git_plow_back_rest']



def configure_commons_variables_1():
    print("=== Configuration des variables générales 1 ===")

    print(Bcolors.FAIL + "Chemin de base de l'installation ? (defaut: " + repertoire_installation_base + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        repertoire_installation_base = choice
        choice = ""


def configure_commons_variables_2():
    print("=== Configuration des variables générales 2 ===")

    print(Bcolors.FAIL + "Branche git ? (defaut: " + branch + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        branch = choice
        choice = ""

    print(Bcolors.FAIL + "Adresse base de données ? (defaut: " + bdd_address + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        bdd_address = choice
        choice = ""

    print(Bcolors.FAIL + "Nom base de données ? (defaut: " + database + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        database = choice
        choice = ""

    print(Bcolors.FAIL + "Adresse serveur de notification ? (defaut: " + notification_address + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        notification_address = choice
        choice = ""

    print(Bcolors.UNDERLINE + "Connexion au serveur de base de données pour verifier si la base existe ..." + Bcolors.ENDC)
    print(Bcolors.FAIL + "Mot de passe:" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        database_password = choice
        choice = ""


def configure_plow_python_variables():
    print("=== Configuration des variables de plow python ===")

    print(Bcolors.FAIL + "Id de la configuration en base de données ? (defaut: " + python_application_id + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        python_application_id = int(choice)
        choice = ""

    print(Bcolors.FAIL + "Chemin repertoire téléchargement ? (defaut: " + repertoire_telechargement + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        repertoire_telechargement = choice
        choice = ""

    print(Bcolors.FAIL + "Chemin repertoire téléchargement temporaire ? (defaut: " + repertoire_telechargement_temporaire + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        repertoire_telechargement_temporaire = choice
        choice = ""

    print(Bcolors.FAIL + "Chemin repertoire téléchargement texte ? (defaut: " + repertoire_telechargement_texte + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        repertoire_telechargement_texte = choice
        choice = ""

    print(Bcolors.FAIL + "Chemin d'installation de plow python ? (defaut: " + repertoire_git_plow_python + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        repertoire_git_plow_python = repertoire_installation_base + choice
        choice = ""

    print(Bcolors.FAIL + "Adresse serveur ? (defaut: " + rest_address + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        rest_address = choice
        choice = ""


def configure_plow_back_rest_variables():
    print(Bcolors.FAIL + "Adresse serveur de telechargement ? (defaut: " + download_server_address + ")" + Bcolors.ENDC)
    choice = input(" >>  ")
    if choice != "":
        download_server_address = choice
        choice = ""
