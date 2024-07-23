# Get the root folder and editions from the command line arguments
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Yep hardoded regex, love it
$patternsToRemove = @(
    "Loading modpack\.\.\.",
    "Reading metadata files\.\.\.",
    "Checking for updates\.\.\.",
    "Do you want to update\? \[Y/n\]:",
    "Warning:.*?\)",
    "Cancelled!",
    "Update skipped for pinned mod .*?(?:\r\n?|\n|$)",
	"Failed .*?(?:\r\n?|\n|$)",
	"Use .*?(?:\r\n?|\n|$)",
	"To .*?(?:\r\n?|\n|$)"
)

# Iterate through all the editions and update all mods with packwiz
foreach ($edition in $editions) {
	# Go to the specific edition folder
	Set-Location -Path "$root\src\$edition"

	# Update all mods with packwiz and capture output
	$output = Write-Output n | & packwiz.exe update --all

	# Remove unwanted strings from the output using regex patterns
	foreach ($pattern in $patternsToRemove) {
		$output = $output -replace $pattern, ""
	}

	Write-Host $output

	Write-Host "`n$edition\:" -ForegroundColor Green
}

Write-Host "`nAll done!" -ForegroundColor Green
