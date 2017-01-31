#!/usr/bin/env python
import sys
import os
import main_plow_python
import main_plow_back_rest
import main_plow_notification
import common
import utils
import variables


def install_plow_python():
    print("=== Installation de plow python ===")

    main_plow_python.main()


def install_plow_back_rest():
    print("=== Installation de plow back rest ===")

    main_plow_back_rest.main()


def install_plow_notification():
    print("=== Installation de plow notification ===")

    main_plow_notification.main()


# Main menu
def menu(menu_to_display):
    os.system('clear')

    for key in sorted(menu_to_display, key=menu_to_display.get):
        if key == 'title':
            print(menu_to_display[key][0] + "\n")
        else:
            print(key + ". " + menu_to_display[key][0])

    choice = input(" >>  ")
    exec_menu(menu_to_display, choice)

    return


def exec_menu(menu_to_display, choice):
    os.system('clear')
    ch = choice.lower()
    if ch == '':
        menu_to_display['title'][1]()
    else:
        try:
            menu_to_display[ch][1]()
        except KeyError:
            print("Invalid selection, please try again.\n")
            menu_to_display['title'][1]()
    return


# Back to main menu
def back(menu_to_display):
    menu_to_display['title'][1]()


# Exit program
def exit():
    sys.exit()

menu_main = {
    'title': ['Menu Principal', ''],
    '1': ['Installation de Plow Python', install_plow_python],
    '2': ['Installation de Plow Back Rest', install_plow_back_rest],
    '3': ['Installation de Plow Notification', install_plow_notification],
    # '4': ['Création de répertoires partagés', createSharedDirectories],
    '9': ['Retour', back],
    '0': ['Sortie', exit],
}


# Main Program
if __name__ == "__main__":
    print("Démarrage de l'installation principale")

    variables.load_config()

    utils.update_package()
    utils.install_package("git screen openvpn")

    utils.install_pip()


    utils.create_database()

    # Launch main menu
    menu(menu_main)

