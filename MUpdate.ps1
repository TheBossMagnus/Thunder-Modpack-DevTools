#contains the list of all the supported editions
$editions = @(
    "fabric/1.16.5","fabric/1.17.1","fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4","fabric/1.20.1",
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4","quilt/1.20.1"
    )


Set-Location "C:\Users\User\GitHub\Thunder\src"    #go to global src folder
foreach ($edition in $editions) {
    Set-Location -path $edition     #go to a specific edition folder
    packwiz.exe update --all    #update all mods with packwiz
    Write-Host "`n"
    Set-Location "..\.."    #go back to global src folder
}

Write-Host "All done!" -ForegroundColor Green