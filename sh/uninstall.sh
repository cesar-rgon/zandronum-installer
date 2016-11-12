#!/bin/bash

########################################################################################################################
# SCRIPT SUMMARY
########################################################################################################################
echo ""; echo "Script desinstalador de Zandronum, Brutal Doom y Brutalized Doom"
echo "Autor: Cesar Rodriguez Gonzalez"
echo "Última fecha modificado: 01/12/2013"; echo ""

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
desktopVar=`cat /home/$username/.config/user-dirs.dirs | grep "XDG_DESKTOP_DIR"`
desktopHomeFolder=`echo ${desktopVar/XDG_DESKTOP_DIR=/""} | tr -d '"' | tr -d "$"`
desktopFolder=`echo ${desktopHomeFolder/HOME/"/home/$username"}`

########################################################################################################################
# QUESTION. FULL OR PARTIAL UNINSTALL
########################################################################################################################
echo ""; echo "Desinstalar Zandronum y Doomseeker"; echo ""
answer=""
while [ "$answer" != "s" ] && [ "$answer" != "S" ] && [ "$answer" != "n" ] && [ "$answer" != "N" ]; do
	echo "¿Desinstalar además perfiles y configuración de Zandronum y Doomseeker (s/n)?"
	read answer
done

########################################################################################################################
# UNINSTALL ZANDRONUM AND DOOMSEEKER
########################################################################################################################
echo ""; echo "* Desinstalando Zandronum y Doomseeker"; echo ""
sudo apt-get -y remove zandronum doomseeker-zandronum 1>/dev/null
sudo apt-get -y autoremove 1>/dev/null

########################################################################################################################
# REMOVE ZANDRONUM REPOSITORY
########################################################################################################################
echo ""; echo "* Eliminando repositorio de Zandronum"; echo ""
sudo apt-key del AF88540B 1>/dev/null
sudo rm -f /etc/apt/sources.list.d/zandronum.list

########################################################################################################################
# FINISH TO UNINSTALL
########################################################################################################################
sudo rm -f /usr/share/applications/uninstall-zandronum.desktop
sudo rm -f "$desktopFolder/Zandronum_Doomseeker"
if [ "$answer" == "s" ] || [ "$answer" == "S" ]; then
	sudo rm -rf /usr/games/zandronum
	sudo rm -rf /home/$username/.zandronum
	sudo rm -rf /home/$username/.doomseeker
else
	sudo rm -rf /usr/games/zandronum/iwads
	sudo rm -rf /usr/games/zandronum/wads
	sudo rm -f /usr/games/zandronum/uninstall.sh
fi
