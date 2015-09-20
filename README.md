# install_plow_solution
Ne pas oublier de rendre executable le sh et de le lancer comme suit: ./install.sh

TODO
mettre un menu au moment de l'installation de node pour demander l'architecture processeur ou trouver une façon de gérer l'installation de node
gérer les configs de serveurs
creer un dossier plow_solution et tout mettre dedans plutot que dans www
donner la possibilité de choisir ce qu'on veut installer dans la solution plow
gerer les erreurs d'installation (utiliser set -e; ???)
donner les droits à l'utilisateur courant sur tous les dossiers créés
donner les droits executables au download_script.sh
terminé l'installation plow_back_rest + faire le démarrage auto + faire export NODE_CONFIG_DIR=/var/www/plow_solution/config/

A FAIRE POUR AUTHORIZER LE SSH DEPUIS LE SERVEUR NODE SUR LE CLIENT PYTHON TELECHARGEMENT
ssh-keygen -t dsa
cat .ssh/id_dsa.pub | ssh root@192.168.1.200 "cat - >>.ssh/authorized_keys