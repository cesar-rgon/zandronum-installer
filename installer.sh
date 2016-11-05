#!/bin/bash
########################################################################################################################
# VARIABLES
########################################################################################################################
scriptRootFolder="`pwd`"
username="`whoami`"
homeFolder="$HOME"
commands=""
. common/commonVariables.sh

########################################################################################################################
# IMPORT FUNCTIONS
########################################################################################################################
if [ -z "$DISPLAY" ]; then
	. menu/terminalFunctions.sh
else
	. menu/desktopFunctions.sh
fi
. common/commonFunctions.sh

########################################################################################################################
# INSTALLATION STEPS
########################################################################################################################
credits
prepareInstallation
downloadWads "$urlFolder/installerList" "$wadFolder"
addZandronumRepo
installSetupZandronumDoomseeker
rm -rf $tempFolder
