#!/bin/bash
function credits
{
	notify-send -i "$installerIconFolder/zandronum-logo96.png" "$installerTitle" "$releaseDateLabel: $releaseDate\n$lastModifiedDateLabel: $lastModifiedDate\n$authorLabel: $author"
}


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
				execute "$installNeededPackage: $package" "apt -y install $package 2>>\"$logFile\""
			fi
		fi
	done
}
