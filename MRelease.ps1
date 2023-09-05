# Get the modpack name, developer name, root folder, and editions from the command line arguments
$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Prompt the user to enter the release number
$release = Read-Host "Enter the release number"


# Iterate through all the editions and generate .mrpack files and changelogs
foreach ($edition in $editions) {
	# Go to the specific edition folder
	Set-Location -Path "$root\src\$edition"

	# Get the modloader and Minecraft version
	$MCversion, $loader = $edition.Split('\')

	# Update pack.toml
	packwiz init -r --name $modpackName --author $devName --modloader $loader --$loader-latest --version "$release+$loader-$mcversion" --mc-version $MCversion | Out-Null

	# Export .mrpack
	packwiz mr export | Out-Null

	# Rename .mrpack and move it to the bin folder
	mkdir "$root\bin\$MCversion\$release" -ErrorAction Ignore | Out-Null
	Move-Item -Path "$root\src\$MCversion\$loader\$modpackName-$release+$loader-$mcversion.mrpack" -Destination "$root\bin\$MCversion\$release\$modpackName-$release+$loader-$mcversion.mrpack" | Out-Null

	# Get the second latest version from the bin folder
	$olderVersion = (Get-ChildItem -Path "$root\bin\$MCversion" -Directory | Sort-Object LastWriteTime)[-2].Name

	# Generate the paths of the current and older .mrpack files
	$currentPack = "$root\bin\$MCversion\$release\$modpackName-$release+$loader-$mcversion.mrpack"
	$oldPack = "$root\bin\$MCversion\$olderVersion\$modpackName-$olderVersion+$loader-$mcversion.mrpack"

	if ((Test-Path -Path $oldPack) -and (Test-Path -Path $currentPack)) {
		# Generate the changelog
		java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "$root\bin\$MCversion\$release\Changelog-$release+$loader-$olderVersion.md"
	}
	else {
		# If the .mrpack file doesn't exist, write "No changelog available" and print a warning
		Set-Content "$root\bin\$MCversion\$release\Changelog-$release+$loader-$olderVersion.md" -Value "No changelog available"
		Write-Warning "No changelog was available"
	}

	Write-Host "`n$modpackName-$release for $loader $MCversion done" -ForegroundColor Green
}

Write-Host "`n`nAll done!" -ForegroundColor Green
