#!/bin/bash
########################################################################################################################
# VARIABLES
########################################################################################################################
scriptRootFolder="/usr/games/zandronum/uninstaller"
username="`whoami`"
homeFolder="$HOME"
. $scriptRootFolder/common/commonVariables.sh

########################################################################################################################
# IMPORT FUNCTIONS
########################################################################################################################
if [ -z "$DISPLAY" ]; then
	. $scriptRootFolder/common/terminalFunctions.sh
	dialog --title "$uninstallerTitle" --yesno "\n$purgeQuestionLabel" 7 70
	respuesta=$?
else
	. $scriptRootFolder/common/desktopFunctions.sh
	zenity --title="$uninstallerTitle" --question --text="$purgeQuestionLabel"
	respuesta=$?
fi

########################################################################################################################
# UNINSTALLATION STEPS
########################################################################################################################
mkdir -p "$tempFolder"
executeSudoTerminal "$uninstallZandronum" "apt -y remove zandronum zandronum-client zandronum-pk3 zandronum-server doomseeker-zandronum; apt -y autoremove"
executeSudoTerminal "$removeRepository" "apt-key del AF88540B; apt update"

commads="rm -f /etc/apt/sources.list.d/zandronum.list;"
commands+="rm -f /usr/share/applications/uninstall-zandronum.desktop;"
commands+="rm -rf /usr/games/zandronum/uninstaller;"
executeSudo "$commands"

if [ "$respuesta" == "0" ]; then
		# Purge all Zandronum and Doomseeker contents
		commands="rm -f \"$desktopFolder/Zandronum_Doomseeker\";"
		commands+="rm -rf /usr/games/zandronum;"
		commands+="rm -rf /$homeFolder/.zandronum;"
		commands+="rm -rf /$homeFolder/.doomseeker;"
		executeSudo "$commands"
fi
