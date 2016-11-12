#!/bin/bash

##
# This functions shows credits
##
function credits
{
	local whiteSpaces="                  "
	printf "\n%.21s%s\n" "$scritNameLabel:$whiteSpaces" "$installerTitle" > $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$releaseDateLabel:$whiteSpaces" "$releaseDate" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$lastModifiedDateLabel:$whiteSpaces" "$lastModifiedDate" >> $tempFolder/zandronum-installer.credits
	#printf "%.21s%s\n" "$githubProjectLabel:$whiteSpaces" "$githubProjectUrl" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$authorLabel:$whiteSpaces" "$author" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$infoLabel:$whiteSpaces" "$info" >> $tempFolder/zandronum-installer.credits

	dialog --title "$creditsLabel" --backtitle "$installerTitle" --stdout --textbox $tempFolder/zandronum-installer.credits 11 100
}

##
# This functions executes commands as sudoer user
##
function executeSudo {
		local commands="$1"
	  sudo bash -c "$commands"
}

##
# This functions executes commands as sudoer user on a terminal emulator
##
function executeSudoTerminal
{
	local message="$1" commands="$2"

	echo "$message" >> $logFile
	sudo cp -f "$scriptRootFolder/etc/tmux.conf" "/etc"
	sudo sed -i "s/LEFT-LENGHT/$width/g" "/etc/tmux.conf"
	sudo sed -i "s/MESSAGE/$message/g" "/etc/tmux.conf"
	sudo tmux new-session "$commands"
}

##
# This function installs needed packages before starting the installation proccess
##
function installNeededPackages
{
	local neededPackages=( dialog tmux aria2 libglu1-mesa )
	local package

	for package in ${neededPackages[@]}; do
		if [ -z "`dpkg -s $package 2>&1 | grep 'Status: install ok installed'`" ]; then
			if [ "$package" == "tmux" ]; then
				echo -e "\n$installNeededPackage: $package\n"; echo "$installNeededPackage: $package" >> "$logFile"
				sudo apt -y install $package 2>>"$logFile"
			else
				executeSudoTerminal "$installNeededPackage: $package" "apt -y install $package 2>>\"$logFile\""
			fi
		fi
	done
}
