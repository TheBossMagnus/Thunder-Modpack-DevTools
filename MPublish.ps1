$version = (Get-ChildItem -Path "C:\Users\User\GitHub\Thunder\bin" -Directory | Sort-Object LastWriteTime)[-1].Name   #get latest version

#Create a draft realase on github
gh release create $version -R TheBossMagnus/Thunder -t $version -d -n ""

#iterate through all the mrpack files in the latest version folder and upload them to the release
Get-ChildItem -Path "C:\Users\User\GitHub\Thunder\bin\$version" -Include "*.mrpack", "*.md" -Recurse | ForEach-Object {
    gh release upload $version $_.FullName
}

Write-Host "`n`n All done!" -ForegroundColor Green
Pause