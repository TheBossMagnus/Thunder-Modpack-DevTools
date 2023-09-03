# Get the modpack name, developer name, and root folder from the command line arguments
$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]

# Get the latest version from the bin folder
$version = (Get-ChildItem -Path "$root\bin" -Directory | Sort-Object LastWriteTime)[-1].Name

#Git commit on GH
Set-Location $root
git add .
git commit -S -m $version
git push

# Create a release on GitHub
gh release create $version -R $devName/$modpackName -t $version -d -n ""

# Iterate through all the mrpack files in the latest version folder and upload them to the release
Get-ChildItem -Path "$root\bin\$version" -Include "*.mrpack","*.md" -Recurse | ForEach-Object {
	gh release upload $version $_.FullName
}

Write-Host "`n`n All done!" -ForegroundColor Green
