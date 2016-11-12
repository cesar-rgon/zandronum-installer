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
	. common/terminalFunctions.sh
else
	. common/desktopFunctions.sh
fi
. common/commonFunctions.sh

########################################################################################################################
# INSTALLATION STEPS
########################################################################################################################
prepareInstallation
credits
downloadWads "$urlFolder/installerList" "$wadFolder"
addZandronumRepo
installSetupZandronumDoomseeker
rm -rf $tempFolder
