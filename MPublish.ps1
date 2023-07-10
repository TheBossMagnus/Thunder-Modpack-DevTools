$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]

$version = (Get-ChildItem -Path "$root\bin" -Directory | Sort-Object LastWriteTime)[-1].Name   #get latest version

#Create a draft realase on github
gh release create $version -R $devName/$modpackName -t $version -d -n ""

#iterate through all the mrpack files in the latest version folder and upload them to the release
Get-ChildItem -Path "$root\bin\$version" -Include "*.mrpack", "*.md" -Recurse | ForEach-Object {
    gh release upload $version $_.FullName
}

Write-Host "`n`n All done!" -ForegroundColor Green