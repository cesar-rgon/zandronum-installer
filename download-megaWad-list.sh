#!/bin/bash

########################################################################################################################
# SCRIPT SUMMARY
########################################################################################################################
echo ""; echo "Script que descarga megaWads de Doom"
echo "Autor: Cesar Rodriguez Gonzalez"
echo "Ultima fecha modificacion: 01/12/2013"

########################################################################################################################
# CHECK USERNAME
########################################################################################################################
# Check if the script is being running like root user (root user has id equal to 0)
if [ $(id -u) -eq 0 ]; then
	username=""
	until [ -n "$username" ]
	do
		echo "Introducir nombre de usuario del sistema (no root):"
		read username
	done
else
	# The script is being running like no root user
	username=`whoami`
	echo "Introducir contraseña de administrador:"
	sudo echo ""
fi

########################################################################################################################
# VARIABLES
########################################################################################################################
zandronumInstallFolder="/usr/games/zandronum"
iwadFolder="$zandronumInstallFolder/iwads"
wadFolder="$zandronumInstallFolder/wads"
logFile="logMegaWads.txt"

########################################################################################################################
# PREPARE INSTALLATION
########################################################################################################################
echo "* Preparando instalacion"; echo ""
sudo mkdir -p $zandronumInstallFolder 2>$logFile
sudo chown $username:$username $zandronumInstallFolder
sudo -u $username mkdir -p $iwadFolder 2>>$logFile
sudo -u $username mkdir -p $wadFolder 2>>$logFile
# Needed packages to use this script
sudo apt-get install aria2 curl gcc openssl 1>/dev/null 2>>$logFile
sudo -u $username gcc decrypt.c -o decrypt 1>/dev/null 2>>$logFile

########################################################################################################################
# DOWNLOAD IWAD LIST
########################################################################################################################		
echo ""; echo "* Descargando contenido Iwads"; echo ""
bash ./sh/down.sh ./url/iwadList "$iwadFolder"

########################################################################################################################
# DOWNLOAD MEGA WAD LIST
########################################################################################################################		
echo ""; echo "* Descargando campañas Mega Wads."; echo ""
bash ./sh/down.sh ./url/megaWadList "$wadFolder"
	
########################################################################################################################
# REMOVE TEMPORAL FILES
########################################################################################################################	
echo ""; echo "* Eliminando ficheros temporales"; echo ""
rm -f ./decrypt
