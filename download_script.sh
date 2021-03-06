#!/bin/bash
# PATH=/opt/someApp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# export PYTHONIOENCODE='utf-8'
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config.cfg

entree=$repertoire_telechargement_texte
destination=$repertoire_telechargement
destination_temp=$repertoire_telechargement_temporaire
nbTelechargements=-1
xTermExiste=""
nomScreen=""

while getopts ":u:d:e:n:s:" option
do
	case ${option} in
		e)
			entree=${OPTARG}
			echo "Repertoire d'entree ${entree}"
			;;
		d)
			destination=${OPTARG}
			echo "Repertoire de destination ${destination}"
			;;
		n)	nbTelechargements=${OPTARG}
			echo "Nombre telechargements simultannees ${nbTelechargements}"
			;;
		s)	nomScreen=${OPTARG}
			echo "Nom du screen : ${nomScreen}"
			;;
		u)
			opt_u="true"
			;;
		:)
			echo "nom du repertoire de destination absent"
			;;
		\?)
			echo " option invalide"
			exit 1
			;;
	esac
done

#on verifie si screen est installe
#which screen > xTermExiste

#if ${xTermExiste}

liste=$(ls ${entree} | egrep "*.txt")

cd $repertoire_git_plowhare
git stash
git reset --hard
git pull
make install
cd $repertoire_module_plowshare
git stash
git reset --hard
git pull
# plowmod --update
# cp -r /root/.config /

echo "wipe screen"
screen -wipe

if [ -f ${entree} ]; then
	command="/usr/bin/plowdown -r 10 -x -m --9kweu=I1QOR00P692PN4Q4669U --temp-rename --temp-directory ${destination_temp} -o ${destination} ${entree}"
	echo ${command}
	screen -dmS ${nomScreen} -m '/mnt/HD/HD_a2/screen.sh -e ${entree} -d ${destination}'
else
	echo ${liste}
	for fich in ${liste}
	do

		#si on a un repertoire on liste tous les liens dans un fichier texte
		#if [[${fich} =~ ""]]; then
		#	plowlist
		#fi

		# traitement de liens a inserer en bdd
		nomScreen="treat-${fich}"
		#command="python $repertoire_web/main/download_basic.py start_file_treatment ${entree}/${fich}"
		command="python3.2 $repertoire_web/main/download_basic.py start_file_treatment ${entree}/${fich}"
		echo ${command}
		screen -list | grep ${nomScreen} > /dev/null
		if [ $? -eq 1  ]; then
			screen -dmS ${nomScreen} -m ${command}
		fi

		nomScreen="down-${fich}"
		screen -list | grep ${nomScreen} > /dev/null
		if [ $? -eq 1  ]; then
			echo "**** Nom du screen : ${nomScreen}"
			# command="/usr/bin/plowdown -r10 -x -m --9kweu=I1QOR00P692PN4Q4669U --temp-rename --temp-directory ${destination_temp} -o ${destination} ${entree}/${fich}"
			#command="python $repertoire_web/main/download_basic.py start_multi_downloads ${entree}/${fich}"
			command="python3.2 $repertoire_web/main/download_basic.py start_multi_downloads ${entree}/${fich}"
			echo ${command}
			screen -dmS ${nomScreen} -m ${command}
		else
			echo "---- screen ${nomScreen} existant"
		fi
	done
fi

