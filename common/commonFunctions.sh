##
#
##
function prepareInstallation
{
  installNeededPackages
  local folders="$tempFolder $homeFolder/logs $zandronumInstallFolder $iwadFolder $wadFolder $doomseekerProfilesFolder $zandronumHomeFolder $doomseekerHomeFolder"
  local commands="rm -rf $tempFolder;"
  commands+="mkdir -p $folders 2>>$logFile;"
  commands+="cp -f ./sh/uninstall.sh $zandronumInstallFolder;"
  commands+="chown -R $username:$username $folders 2>>$logFile;"
  executeSudo "$commands"
}

##
# Download in parallel a list of files from URL list
# @param urlList        File that contains a list of URL
# @param outputFolder   Output folder to download the files
##
function downloadWads
{
  # Test if parameters are empty
  if [ -z "$1" ] || [ -z "$2" ]; then
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
    executeSudoTerminal "$downloadWadsMessage" "aria2c -d \"$outputFolder\" -Z -c -i \"$tempFolder/outputLinks\" 2>>$logFile"
  fi
}

##
#
##
function addZandronumRepo
{
  local commands="echo \"deb http://debian.drdteam.org/ stable multiverse # Repositorio de Zandronum\" > /etc/apt/sources.list.d/zandronum.list;"
  commands+="echo \"deb-src http://debian.drdteam.org/ stable multiverse # Repositorio de Zandronum\" >> /etc/apt/sources.list.d/zandronum.list;"
  executeSudo "$commands"

  commands="wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add - 2>>$logFile;"
  commands+="apt update 2>>$logFile;"
  executeSudoTerminal "$addZandronumRepoMessage" "$commands"
}

##
#
##
function installSetupZandronumDoomseeker
{
  executeSudoTerminal "$installSetupZandronumMessage" "apt -y install zandronum-server zandronum-pk3 zandronum-client doomseeker-zandronum 2>>$logFile"
  executeSudo "cp -f $etcFolder/uninstall-zandronum.desktop /usr/share/applications"

  if [ ! -f $zandronumHomeFolder/zandronum.ini ]; then
  	/usr/games/zandronum/zandronum 2>/dev/null
  	mv $zandronumHomeFolder/zandronum.ini $zandronumHomeFolder/zandronum-original.ini 2>>$logFile
  	cp -f $etcFolder/zandronum.ini $zandronumHomeFolder
  fi
  if [ ! -f $doomseekerHomeFolder/doomseeker.ini ]; then
  	cp -f $etcFolder/doomseeker.ini $doomseekerHomeFolder
  fi
  cp -f $etcFolder/profiles/* $doomseekerProfilesFolder
  ln -sf $zandronumInstallFolder "$desktopFolder/Zandronum_Doomseeker" 2>>$logFile
}
