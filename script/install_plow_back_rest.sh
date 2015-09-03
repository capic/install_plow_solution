#!/bin/sh
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/../config/config.cfg

function creerFichierConfigPlowBackRest {
    echo "Création du fichier pour plow back rest"
    a_ecrire="{
                \"db\": {
                    \"host\": \"${mysql_host}\",
                    \"database\": \"${mysql_database}\",
                    \"user\": \"${mysql_login}\",
                    \"password\": \"${mysql_pass}\"
                },
                \"notification\": {
                    \"address\": \"${notification_adresse}\"
                }
              }"
    echo ${a_ecrire} >> ${repertoire_git_plow_back_rest}/config/default.json
}

function copiePlowBackRest {
    cp -r ${repertoire_git_plow_back_rest}/bin ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/config ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/configuration ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/models ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/node_modules ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/public ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/routes ${repertoire_installation_plow_back_rest}
    cp -r ${repertoire_git_plow_back_rest}/views ${repertoire_installation_plow_back_rest}
    cp ${repertoire_git_plow_back_rest}/apps.js ${repertoire_installation_plow_back_rest}
}

. common.sh
installNodeJS

echo "===== Installation de plow back rest ====="
echo "Adresse du dépot git de plow_back_rest: ${git_plow_back_rest} => ${repertoire_git_plow_back_rest}"
git clone ${git_plow_back_rest} ${repertoire_git_plow_back_rest}
creerFichierConfigPlowBackRest
echo "Installation des dépendances"
npm install
echo "Copie de ${repertoire_git_plow_back_rest} vers ${repertoire_installation_plow_back_rest}"
copiePlowBackRest
echo "Suppression du dossier ${repertoire_git_plow_back_rest}"
rm -r ${repertoire_git_plow_back_rest}

