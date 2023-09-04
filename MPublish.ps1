# Get the modpack name, developer name, and root folder from the command line arguments
$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

$MCversion, $loader = $editions[0].Split('\')

$version = (Get-ChildItem -Path "$root\bin\$MCversion" -Directory | Sort-Object LastWriteTime)[-1].Name


#Git commit on GH
Set-Location $root
#git add .
#git commit -S -m "$version+$mcversion"
#git push

# Create a release on GitHub
gh release create "$version+$mcversion" -R $devName/$modpackName -t "Thunder $version for $mcversion" -d -n ""

# Iterate through all the mrpack files in the latest version folder and upload them to the release
Get-ChildItem -Path "$root\bin\$mcversion\$version" -Include "*.mrpack","*.md" -Recurse | ForEach-Object {
	gh release upload "$version+$mcversion" $_.FullName
}

Write-Host "`n`n All done!" -ForegroundColor Green
