#!/bin/bash
function credits
{
	local whiteSpaces="                  "
	printf "\n%.21s%s\n" "$installerTitle" > $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$releaseDateLabel:$whiteSpaces" "$releaseDate" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$lastModifiedDateLabel:$whiteSpaces" "$lastModifiedDate" >> $tempFolder/zandronum-installer.credits
	#printf "%.21s%s\n" "$githubProjectLabel:$whiteSpaces" "$githubProjectUrl" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$authorLabel:$whiteSpaces" "$author" >> $tempFolder/zandronum-installer.credits
	printf "%.21s%s\n" "$infoLabel:$whiteSpaces" "$info" >> $tempFolder/zandronum-installer.credits

	dialog --title "$creditsLabel" --backtitle "$installerTitle" --stdout --textbox $tempFolder/zandronum-installer.credits 11 100
}

function installNeededPackages
{
	local neededPackages=( dialog tmux aria2 libglu1-mesa )
	local packagesToInstall=()
	for package in "${neededPackages[@]}"; do
		if [ -z "`dpkg -s $package 2>&1 | grep "Status: install ok installed"`" ]; then
			packagesToInstall+=( $package )
		fi
	done

	if [ ${#packagesToInstall[@]} -gt 0 ]; then
		echo "$installingRepoApplications: ${packagesToInstall[@]}"
		sudo apt -y install ${packagesToInstall[@]} --fix-missing
	fi
}
