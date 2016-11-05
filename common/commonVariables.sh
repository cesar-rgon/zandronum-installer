########################################################################################################################
# FOLDERS
########################################################################################################################
# Zandronum folders
zandronumInstallFolder="/usr/games/zandronum"
iwadFolder="$zandronumInstallFolder/iwads"
wadFolder="$zandronumInstallFolder/wads"
doomseekerProfilesFolder="$zandronumInstallFolder/doomseeker-profiles"
zandronumHomeFolder="$homeFolder/.zandronum"
# Doomseeker folder
doomseekerHomeFolder="$homeFolder/.doomseeker"
# User home folders
desktopHomeFolder=`cat $HOME/.config/user-dirs.dirs | grep "XDG_DESKTOP_DIR" | awk -F = '{ print $2 }' | tr -d '"' | tr -d '$'`
desktopFolder=`echo ${desktopHomeFolder/HOME/"$homeFolder"}`
# Script folders
commonFolder="$scriptRootFolder/common"
installerIconFolder="$scriptRootFolder/images"
etcFolder="$scriptRootFolder/etc"
languageFolder="$etcFolder/languages"
urlFolder="$etcFolder/urlList"
tempFolder="/tmp/zandronum-installer.tmp"

########################################################################################################################
# VARIABLES
########################################################################################################################
logFile="$homeFolder/logs/zandronum-installer-log.txt"
language="${LANG:0:2}"
languageFile="$languageFolder/$language.properties"

########################################################################################################################
# LANGUAGE VARIABLES
########################################################################################################################
if [ -f "$languageFile" ]; then	. "$languageFile"; else . $languageFolder/en.properties; fi
