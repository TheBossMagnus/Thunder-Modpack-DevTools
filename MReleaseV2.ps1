$release = Read-Host "release number" #get release number
$olderVersion = (Get-ChildItem -Path "C:\Users\User\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object LastWriteTime)[-2].Name   #get second latest version

#create folder for .mrpack for each modloader
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "fabric" -ItemType "directory" | Out-Null
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "changelog" -ItemType "directory" | Out-Null


#contains the list of all the supported editions
$editions = @(
    "fabric/1.16.5","fabric/1.17.1","fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4",
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4"
    )

Set-Location "C:\Users\User\GitHub\Quilt-Optimized\src"    #go to global src folder


foreach ($edition in $editions) {
    Set-Location -Path $edition    #go to a specific edition folder

    $loader =  $edition.split("/")[0]   #get modloader
    $MCversion =  $edition.split("/")[1]    #get MC version

    packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader $loader --$loader-latest  --version $release --mc-version $MCversion | Out-Null   #update pack.toml
    packwiz mr export | Out-Null    #export .mrpack
    Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\$loader\Quilt Optimized-$release for $Loader $MCversion.mrpack" | Out-Null   #rename .mrpack and move it to bin folder
    Set-Location "..\.."    #go back to global src folder
    write-host "`n Quilt Optimized-$release for $loader $MCversion done" -ForegroundColor Green

    $currentPack = "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\$loader\Quilt Optimized-$release for $loader $MCversion.mrpack"    #generate .mrpack's path of the current version
    $oldPack = "C:\Users\User\GitHub\Quilt-Optimized\bin\$olderVersion\$loader\Quilt Optimized-$olderVersion for $loader $MCversion.mrpack"    #generate .mrpack's path of the older version
    New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog" -Name "$Loader $MCversion Changelog.md" -ItemType "file" | Out-Null #create blank changelog file

    if ((test-path -Path $oldPack) -and (test-path -Path $currentPack)) {    #check if .mrpack exist

        java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog\$Loader $MCversion Changelog.md"   #generate changelog
    }
    else { #if .mrpack doesn't exist write "No changelog available" and print a warning
        Set-Content "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog\$Loader $MCversion Changelog.md" -Value "No changelog available"
        Write-Warning "No changelog available for $loader $MCversion"
    }

}

#add to global changelog
$newchangelog = get-content "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\Changelog\Quilt 1.19.4 changelog.md"    #get content current changelog
$globalchangelog = get-content "C:\Users\User\GitHub\Quilt-Optimized\Changelog.md"   #get content of the global changelog(Changelog.md)
$date = "> " + (Get-Date -Format "dd/MM/yyyy")  #add date to current changelog
Set-Content "C:\Users\User\GitHub\Quilt-Optimized\Changelog.md" -Value ($newchangelog + $date + "---" + $globalchangelog)  #add current changelog to global changelog

Write-Host "`n`n`nDone!" -ForegroundColor Green