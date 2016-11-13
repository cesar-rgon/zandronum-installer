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
	. $scriptRootFolder/common/terminalFunctions.sh
else
	. $scriptRootFolder/common/desktopFunctions.sh
fi
. $scriptRootFolder/common/commonFunctions.sh

########################################################################################################################
# INSTALLATION STEPS
########################################################################################################################
prepareInstallation
credits
downloadWads "$urlFolder/installerList" "$wadFolder"
addZandronumRepo
installSetupZandronumDoomseeker
rm -rf $tempFolder
