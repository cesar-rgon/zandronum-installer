##
#
##
function execute
{
  local message="$1" commands="$2"

  echo "$message" >> $logFile
  if [ -n "$DISPLAY" ]; then
    xtermCommand="xterm -T \"$terminalProgress\" -fa 'DejaVu Sans Mono' -fs 11 -geometry 120x15+0-0 -xrm 'XTerm.vt100.allowTitleOps: false' -e \"$commands\";"

    local echoCommands="echo \"# $message\";"
    if [ -n "$3" ]; then echoCommands+="$3"; fi

    ( SUDO_ASKPASS="$commonFolder/askpass.sh" sudo -A bash -c "$echoCommands $xtermCommand" ) \
    | zenity --progress --title="$installerTitle" --no-cancel --pulsate --auto-close --width=500 --window-icon="$installerIconFolder/zandronum-logo32.png"

  fi
}

##
#
##
function prepareInstallation
{
  rm -rf $tempFolder
  local folders="$tempFolder $homeFolder/logs $zandronumInstallFolder $iwadFolder $wadFolder $doomseekerProfilesFolder $zandronumHomeFolder $doomseekerHomeFolder"
  local commands="mkdir -p $folders 2>>$logFile;"
  commands+="cp -f ./sh/uninstall.sh $zandronumInstallFolder;"
  commands+="chown -R $username:$username $folders 2>>$logFile;"
  commands+="$( installNeededPackages );"
  execute "$prepareInstallationMessage" "$commands"
}

##
# Download in parallel a list of files from URL list
# @param urlList        File that contains a list of URL
# @param outputFolder   Output folder to download the files
##
function downloadWads
{
  # Test if parameters are empty
  if [[ "$1" == "" ]] || [[ "$2" == "" ]]; then
    echo "$downloadWadsErrorMessage" >> $logFile
  else
  	local outputFolder="$2" index=0 line
    # Iterate through URL List file
    while read line; do
    	# Ignore empty lines and lines that start with # character
        if [ -n "$line" ] && [ `echo "$line" | head -c 1` != "#" ]; then
  			      echo $line >> $tempFolder/outputLinks
        fi
    done < "$1"
    # Download in parallel all files from URL List to output folder
    execute "$downloadWadsMessage" "aria2c -d \"$outputFolder\" -Z -c -i \"$tempFolder/outputLinks\" 2>>$logFile"
  fi
}

##
#
##
function addZandronumRepo
{
  local echoCommands="echo \"deb http://debian.drdteam.org/ stable multiverse # Repositorio de Zandronum\" > /etc/apt/sources.list.d/zandronum.list;"
  echoCommands+="echo \"deb-src http://debian.drdteam.org/ stable multiverse # Repositorio de Zandronum\" >> /etc/apt/sources.list.d/zandronum.list;"
  local commands="wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add - 2>>$logFile;"
  commands+="apt update 2>>$logFile;"
  execute "$addZandronumRepoMessage" "$commands" "$echoCommands"
}

##
#
##
function installSetupZandronumDoomseeker
{
  local commands="apt -y install zandronum doomseeker-zandronum 2>>$logFile;"
  commands+="cp -f $etcFolder/uninstall-zandronum.desktop /usr/share/applications;"
  if [ ! -f $zandronumHomeFolder/zandronum.ini ]; then
  	commands+="zandronum 2>/dev/null;"
  	commands+="mv $zandronumHomeFolder/zandronum.ini $zandronumHomeFolder/zandronum-original.ini 2>>$logFile;"
  	commands+="cp -f $etcFolder/zandronum.ini $zandronumHomeFolder;"
  fi
  if [ ! -f $doomseekerHomeFolder/doomseeker.ini ]; then
  	commands+="cp -f $etcFolder/doomseeker.ini $doomseekerHomeFolder;"
  fi
  if [ ! -f $doomseekerHomeFolder/doomseeker.ini ]; then
  	commands+="cp -f $etcFolder/doomseeker.ini $doomseekerHomeFolder;"
  fi
  commands+="cp -f $etcFolder/profiles/* $doomseekerProfilesFolder;"
  commands+="ln -sf $zandronumInstallFolder \"$desktopFolder/Zandronum\" 2>>$logFile;"
  execute "$installSetupZandronumMessage" "$commands"
}
