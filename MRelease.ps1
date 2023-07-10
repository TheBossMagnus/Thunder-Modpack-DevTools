$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Get release number
$release = Read-Host "release number"

# Get second latest version
$olderVersion = (Get-ChildItem -Path "$root\bin" -Directory | Sort-Object LastWriteTime)[-1].Name

# Create folder for .mrpack for each modloader and one for changelogs
New-Item -Path "$root\bin\$release" -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path "$root\bin\$release" -Name "fabric" -ItemType "directory" | Out-Null
New-Item -Path "$root\bin\$release" -Name "changelog" -ItemType "directory" | Out-Null

# Go to global src folder
Set-Location "$root\src"

foreach ($edition in $editions) {
   # Go to a specific edition folder
Set-Location -Path $edition

# Get modloader and MC version
$loader =  $edition.split("/")[0]
$MCversion =  $edition.split("/")[1]

# Update pack.toml
packwiz init -r --name $modpackName --author $devName --modloader $loader --$loader-latest  --version $release --mc-version $MCversion | Out-Null

# Export .mrpack
packwiz mr export | Out-Null

# Rename .mrpack and move it to bin folder
Move-Item -Path "$modpackName-$release.mrpack" -destination "$root\bin\$release\$loader\$modpackName-$release for $Loader $MCversion.mrpack" | Out-Null

# Go back to global src folder
Set-Location "..\.."


# Generate .mrpack's path of the current and older version
$currentPack = "$root\bin\$release\$loader\$modpackName-$release for $loader $MCversion.mrpack"
$oldPack = "$root\bin\$olderVersion\$loader\$modpackName-$olderVersion for $loader $MCversion.mrpack"

# Create blank changelog file
New-Item -Path "$root\bin\$release\changelog" -Name "$Loader $MCversion Changelog.md" -ItemType "file" | Out-Null
    if ((test-path -Path $oldPack) -and (test-path -Path $currentPack)) {
        # Generate changelog
        java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "$root\bin\$release\changelog\$Loader $MCversion Changelog.md"
    }
    else {
        # If .mrpack doesn't exist write "No changelog available" and print a warning
        Set-Content "$root\bin\$release\changelog\$Loader $MCversion Changelog.md" -Value "No changelog available"
        Write-Warning "No changelog was available"
    }
Write-Host "`n$modpackName-$release for $loader $MCversion done" -ForegroundColor Green
}

# Add to global changelog
$newchangelog = get-content "$root\bin\$release\Changelog\Fabric 1.20.1 changelog.md"    # Get content current changelog
$globalchangelog = get-content "$root\Changelog.md"   # Get content of the global changelog(Changelog.md)
$date = "> " + (Get-Date -Format "dd/MM/yyyy")  # Add date to current changelog
Set-Content "$root\Changelog.md" -Value ($newchangelog + $date + "`n---`n" + $globalchangelog)  # Add current changelog to global changelog

Write-Host "`n`nAll Done!" -ForegroundColor Green