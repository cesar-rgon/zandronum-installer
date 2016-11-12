#!/bin/bash

##
# This functions shows credits
##
function credits
{
	notify-send -i "$installerIconFolder/zandronum-logo96.png" "$installerTitle" "$releaseDateLabel: $releaseDate\n$lastModifiedDateLabel: $lastModifiedDate\n$authorLabel: $author"
}

##
# This functions executes commands as sudoer user
##
function executeSudo {
		local commands="$1"

	  SUDO_ASKPASS="$commonFolder/askpass.sh" sudo -A bash -c "$commands"
}

##
# This functions executes commands as sudoer user on a terminal emulator
##
function executeSudoTerminal
{
	local message="$1" commands="$2"

  echo "$message" >> $logFile
  xtermCommand="xterm -T \"$terminalProgress\" -fa 'DejaVu Sans Mono' -fs 11 -geometry 120x15+0-0 -xrm 'XTerm.vt100.allowTitleOps: false' -e \"$commands\";"
  ( SUDO_ASKPASS="$commonFolder/askpass.sh" sudo -A bash -c "echo \"# $message\"; $xtermCommand" ) \
  | zenity --progress --title="$installerTitle" --no-cancel --pulsate --auto-close --width=$width --window-icon="$installerIconFolder/zandronum-logo32.png"
}

##
# This function installs needed packages before starting the installation proccess
##
function installNeededPackages
{
	local neededPackages=( zenity xterm aria2 libglu1-mesa libnotify-bin )
	local package

	for package in ${neededPackages[@]}; do
		if [ -z "`dpkg -s $package 2>&1 | grep 'Status: install ok installed'`" ]; then
			if [ "$package" == "xterm" ] || [ "$package" == "zenity" ]; then
				echo -e "\n$installNeededPackage: $package\n"; echo "$installNeededPackage: $package" >> "$logFile"
				sudo apt -y install $package 2>>"$logFile"
			else
				executeSudoTerminal "$installNeededPackage: $package" "apt -y install $package 2>>\"$logFile\""
			fi
		fi
	done
}
