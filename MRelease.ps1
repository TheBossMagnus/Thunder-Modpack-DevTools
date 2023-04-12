$release = Read-Host "release number" #get release number(tag)

#create folder for .mrpack for each modloader
New-Item -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release" -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release" -Name "fabric" -ItemType "directory" | Out-Null


#contains the list of all the supported editions
$editions = @(
    #"fabric/1.16.5""fabric/1.17.2""fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4"
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4"
    )

Set-Location "C:\Users\tbmag\GitHub\Quilt-Optimized\src"    #go to global src folder


foreach ($edition in $editions) {
    Set-Location -Path $edition    #go to a specific edition folder

    $loader =  $edition.split("/")[0]   #get modloader
    $MCversion =  $edition.split("/")[1]    #get MC version

    packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader $loader --$loader-latest  --version $release --mc-version $MCversion | Out-Null   #update pack.toml
    packwiz mr export | Out-Null    #export .mrpack
    Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release\$loader\Quilt Optimized-$release for $Loader $MCversion.mrpack" | Out-Null   #rename .mrpack and move it to bin folder
    Set-Location "..\.."    #go back to global src folder
    write-host "`n Quilt Optimized-$release for $loader $MCversion done" -ForegroundColor Green
}


Write-Host "`n`n`nExport done!`n`n`n" -ForegroundColor Green



#====================================================================================================
# Changelog
#====================================================================================================

Set-Location "C:\Users\tbmag\GitHub\Quilt-Optimized\bin"

#get most recent and second most recent version using folder creation date
$latest_version = $release  #get latest version
$secondlatest_version = (Get-ChildItem -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object LastWriteTime)[-2].Name   #get second latest version



$oldPack = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$secondlatest_version\quilt\Quilt Optimized-$secondlatest_version for quilt 1.19.4.mrpack"    #generate .mrpack of old version path

$newPack = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\quilt\Quilt Optimized-$latest_version for quilt 1.19.4.mrpack"    #generate .mrpack of new version path


Write-Host "`n generating changelog from $secondlatest_version to $latest_version `n"
java -jar "C:\Users\tbmag\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $newPack -out "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Changelog.md"   #generate changelog

#add to global changelog
$verchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Changelog.md"    #get content current changelog
$globalchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md"   #get content of the global changelog(Changelog.md)
$date = "> " + (Get-Date -Format "dd/MM/yyyy")  #add date to current changelog
Set-Content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md" -Value ($verchangelog + $date + "---" + $globalchangelog)  #add current changelog to global changelog

Write-Host "`n`n`n Changelog done! `n`n`n" -ForegroundColor Green


Pause