# Get the root folder and editions from the command line arguments
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Iterate through all the editions and update all mods with packwiz
foreach ($edition in $editions) {
	# Go to the specific edition folder
	Set-Location -Path "$root\src\$edition"

	# Update all mods with packwiz
	packwiz.exe update --all -y

	Write-Host "$edition done`n" -ForegroundColor Green
}

Write-Host "`nAll done!" -ForegroundColor Green
