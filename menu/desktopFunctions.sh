#!/bin/bash
function credits
{
	notify-send -i "$installerIconFolder/zandronum-logo96.png" "$installerTitle" "$releaseDateLabel: $releaseDate\n$lastModifiedDateLabel: $lastModifiedDate\n$authorLabel: $author"
}


function installNeededPackages
{
	local neededPackages=( aria2 libnotify-bin xterm zenity )
	if [ "$KDE_FULL_SESSION" != "true" ]; then
		neededPackages+=( gksu )
	else
		neededPackages+=( kdesudo )
		if [ "$distro" == "ubuntu" ]; then neededPackages+=( libqtgui4-perl ); fi
	fi

	local packagesToInstall=()
	for package in "${neededPackages[@]}"; do
		if [ -z "`dpkg -s $package 2>&1 | grep "Status: install ok installed"`" ]; then
			packagesToInstall+=( $package )
		fi
	done

	if [ ${#packagesToInstall[@]} -gt 0 ]; then
		echo "$installingRepoApplications: ${packagesToInstall[@]}"
		if [ "$KDE_FULL_SESSION" != "true" ]; then
			`gksudo -S "apt -y install ${packagesToInstall[@]}" 2>>"$logFile"`
		else
			`kdesudo -c "apt -y install ${packagesToInstall[@]}" 2>>"$logFile"`
		fi
	fi
}
