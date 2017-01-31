#!/usr/bin/env python

import configparser
import os

from Bcolors import Bcolors
from Configuration import Configuration


def load_config():
    print("=== Chargement de la config " + os.path.dirname(os.path.abspath(__file__)) + "/config/config_install.ini ===")
    global configuration
    configuration = Configuration()

    config = configparser.ConfigParser()
    config.read(os.path.dirname(os.path.abspath(__file__)) + "/config/config_install.ini")

    print(config.sections())
    print(config['DEFAULT']['repertoire_installation_base'])
    configuration.repertoire_installation_base = config['DEFAULT']['repertoire_installation_base']

    configuration.repertoire_git_plow_python = config['REPERTOIRES_GIT']['repertoire_git_plow_python']
    configuration.branch = config['DEFAULT']['branch']
    configuration.bdd_address = config['DEFAULT']['bdd_address']
    configuration.database = config['DEFAULT']['database']
    configuration.notification_address = config['DEFAULT']['notification_address']
    configuration.python_application_id = int(config['DEFAULT']['python_application_id'])
    configuration.repertoire_telechargement = config['REPERTOIRES_TELECHARGEMENT']['repertoire_telechargement']
    configuration.repertoire_telechargement_temporaire = config['REPERTOIRES_TELECHARGEMENT']['repertoire_telechargement_temporaire']
    configuration.repertoire_telechargement_texte = config['REPERTOIRES_TELECHARGEMENT']['repertoire_telechargement_texte']
    configuration.rest_address = config['DEFAULT']['rest_address']
    configuration.download_server_address = config['DEFAULT']['download_server_address']
    configuration.git_plowshare = config['GIT']['git_plowshare']
    configuration.repertoire_git_plowshare = config['REPERTOIRES_GIT']['repertoire_git_plowshare']
    configuration.git_plow_python = config['GIT']['git_plow_python']
    configuration.repertoire_git_plow_python = config['REPERTOIRES_GIT']['repertoire_git_plow_python']
    configuration.nodejs_version = config['DEFAULT']['nodejs_version']
    configuration.arm_version = config['DEFAULT']['arm_version']
    configuration.repertoire_git_plow_back_rest = config['REPERTOIRES_GIT']['repertoire_git_plow_back_rest']
    configuration.git_plow_back_rest = config['GIT']['git_plow_back_rest']

    print_config()


def print_config():
    print("=== Configuration ===")
    print("repertoire_git_plow_python: %s" % configuration.repertoire_git_plow_python)
    print("repertoire_installation_base: %s" % configuration.repertoire_installation_base)
    print("branch: %s" % configuration.branch)
    print("bdd_address: %s" % configuration.bdd_address)
    print("database: %s" % configuration.database)
    print("notification_address: %s" % configuration.notification_address)
    print("python_application_id: %d" % configuration.python_application_id)
    print("repertoire_telechargement: %s" % configuration.repertoire_telechargement)
    print("repertoire_telechargement_temporaire: %s" % configuration.repertoire_telechargement_temporaire)
    print("repertoire_telechargement_texte: %s" % configuration.repertoire_telechargement_texte)
    print("rest_address: %s" % configuration.rest_address)
    print("download_server_address: %s" % configuration.download_server_address)
    print("git_plowshare: %s" % configuration.git_plowshare)
    print("repertoire_git_plowshare: %s" % configuration.repertoire_git_plowshare)
    print("git_plow_python: %s" % configuration.git_plow_python)
    print("repertoire_git_plow_python: %s" % configuration.repertoire_git_plow_python)
    print("nodejs_version: %s" % configuration.nodejs_version)
    print("arm_version: %s" % configuration.arm_version)
    print("repertoire_git_plow_back_rest: %s" % configuration.repertoire_git_plow_back_rest)
    print("git_plow_back_rest: %s" % configuration.git_plow_back_rest)


def configure_commons_variables_1():
    print("=== Configuration des variables générales 1 ===")

    print("%sChemin de base de l'installation ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.repertoire_installation_base, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.repertoire_installation_base = choice
        choice = ""


def configure_commons_variables_2():
    print("=== Configuration des variables générales 2 ===")

    print("%sBranche git ? (defaut: %s)%s" %(Bcolors.FAIL, configuration.branch, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.branch = choice
        choice = ""

    print("%sAdresse base de données ? (defaut: %s)%s" %(Bcolors.FAIL, configuration.bdd_address , Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.bdd_address = choice
        choice = ""

    print("%sNom base de données ? (defaut: %s)%s" %(Bcolors.FAIL, configuration.database, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.database = choice
        choice = ""

    print("%sAdresse serveur de notification ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.notification_address, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.notification_address = choice
        choice = ""


def configure_plow_python_variables():
    print("=== Configuration des variables de plow python ===")

    print("%sId de la configuration en base de données ? (defaut: %d)%s" % (Bcolors.FAIL, configuration.python_application_id, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.python_application_id = int(choice)
        choice = ""

    print("%sChemin repertoire téléchargement ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.repertoire_telechargement, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.repertoire_telechargement = choice
        choice = ""

    print("%sChemin repertoire téléchargement temporaire ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.repertoire_telechargement_temporaire, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.repertoire_telechargement_temporaire = choice
        choice = ""

    print("%sChemin repertoire téléchargement texte ? (defaut: %s)%s" % (Bcolors.FAIL , configuration.repertoire_telechargement_texte, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.repertoire_telechargement_texte = choice
        choice = ""

    print("%sChemin d'installation de plow python ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.repertoire_git_plow_python, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.repertoire_git_plow_python = repertoire_installation_base + choice
        choice = ""

    print("%sAdresse serveur ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.rest_address, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.rest_address = choice
        choice = ""


def configure_plow_back_rest_variables():
    print("%sAdresse serveur de telechargement ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.download_server_address, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.download_server_address = choice
        choice = ""

def configure_database_password():
    print("%sMot de passe de la base de données ? (defaut: %s)%s" % (Bcolors.FAIL, configuration.database_password, Bcolors.ENDC))
    choice = input(" >>  ")
    if choice != "":
        configuration.database_password = choice
        choice = ""