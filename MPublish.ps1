$version = (Get-ChildItem -Path "C:\Users\User\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object LastWriteTime)[-1].Name   #get latest version

#Create a draft realase on github
gh release create $version -R TheBossMagnus/Quilt-Optimized -t $version -d

#iterate through all the mrpack files in the latest version folder and upload them to the release
Get-ChildItem -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$version" -Filter "*.mrpack" -Recurse | ForEach-Object {
    gh release upload $version $_.FullName
}

Write-Host "`n`n All done!" -ForegroundColor Green
Pause