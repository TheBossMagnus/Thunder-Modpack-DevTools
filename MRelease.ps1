# Get the modpack name, developer name, root folder, and editions from the command line arguments
$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Prompt the user to enter the target MC version
#$targetMc = Read-Host "Enter the target MC version"

# Filter the editions array based on the input
#$editions = $editions | Where-Object { $_.Split('/')[1] -eq $targetMc }

# Check if any editions were found
#if ($editions.Count -eq 0) {
#    Write-Error "No editions found for MC version $targetMc"
#    exit 1
#}

# Prompt the user to enter the release number
$release = Read-Host "Enter the release number"

# Get the second latest version from the bin folder
$olderVersion = (Get-ChildItem -Path "$root\bin" -Directory | Sort-Object LastWriteTime)[-1].Name

# Create folders for .mrpack files and changelogs
$binPath = "$root\bin\$release"
New-Item -Path $binPath -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path $binPath -Name "fabric" -ItemType "directory" | Out-Null
New-Item -Path $binPath -Name "changelog" -ItemType "directory" | Out-Null

# Iterate through all the editions and generate .mrpack files and changelogs
foreach ($edition in $editions) {
	# Go to the specific edition folder
	Set-Location -Path "$root\src\$edition"

	# Get the modloader and Minecraft version
	$loader,$MCversion = $edition.Split('/')

	# Update pack.toml
	packwiz init -R --name $modpackName --author $devName --modloader $loader --$loader-latest --version $release --mc-version $MCversion | Out-Null

	# Export .mrpack
	packwiz mr export | Out-Null

	# Rename .mrpack and move it to the bin folder
	$newName = "$modpackName-$release for $loader $MCversion.mrpack"
	Move-Item -Path "$modpackName-$release.mrpack" -Destination "$binPath\$loader\$newName" | Out-Null

	# Generate the paths of the current and older .mrpack files
	$currentPack = "$root\bin\$release\$loader\$newName"
	$oldPack = "$root\bin\$olderVersion\$loader\$modpackName-$olderVersion for $loader $MCversion.mrpack"

	# Create a blank changelog file
	New-Item -Path "$root\bin\$release\changelog" -Name "$loader $MCversion Changelog.md" -ItemType "file" | Out-Null

	if ((Test-Path -Path $oldPack) -and (Test-Path -Path $currentPack)) {
		# Generate the changelog
		java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "$root\bin\$release\changelog\$loader $MCversion Changelog.md"
	}
	else {
		# If the .mrpack file doesn't exist, write "No changelog available" and print a warning
		Set-Content "$root\bin\$release\changelog\$loader $MCversion Changelog.md" -Value "No changelog available"
		Write-Warning "No changelog was available"
	}

	Write-Host "`n$modpackName-$release for $loader $MCversion done" -ForegroundColor Green
}

Write-Host "`n`nAll done!" -ForegroundColor Green
