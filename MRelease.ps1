# Get the modpack name, developer name, root folder, and editions from the command line arguments
$modpackName = $args[1]
$devName = $args[3]
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Prompt the user to enter the release number
$release = Read-Host "Enter the release number"

# Get the second latest version from the bin folder
$olderVersion = (Get-ChildItem -Path "$root\bin" -Directory | Sort-Object LastWriteTime)[-1].Name

# Create folders for .mrpack files and changelogs
New-Item -Path "$root\bin\$release" -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path "$root\bin\$release" -Name "fabric" -ItemType "directory" | Out-Null
New-Item -Path "$root\bin\$release" -Name "changelog" -ItemType "directory" | Out-Null

# Iterate through all the editions and generate .mrpack files and changelogs
foreach ($edition in $editions) {
    # Go to the specific edition folder
    Set-Location -Path "$root\src\$edition"

    # Get the modloader and Minecraft version
    $loader = $edition.split("/")[0]
    $MCversion = $edition.split("/")[1]

    # Update pack.toml
    packwiz init -r --name $modpackName --author $devName --modloader $loader --$loader-latest --version $release --mc-version $MCversion | Out-Null

    # Export .mrpack
    packwiz mr export | Out-Null

    # Rename .mrpack and move it to the bin folder
    Move-Item -Path "$modpackName-$release.mrpack" -destination "$root\bin\$release\$loader\$modpackName-$release for $Loader $MCversion.mrpack" | Out-Null

    # Generate the paths of the current and older .mrpack files
    $currentPack = "$root\bin\$release\$loader\$modpackName-$release for $loader $MCversion.mrpack"
    $oldPack = "$root\bin\$olderVersion\$loader\$modpackName-$olderVersion for $loader $MCversion.mrpack"

    # Create a blank changelog file
    New-Item -Path "$root\bin\$release\changelog" -Name "$Loader $MCversion Changelog.md" -ItemType "file" | Out-Null

    if ((Test-Path -Path $oldPack) -and (Test-Path -Path $currentPack)) {
        # Generate the changelog
        java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "$root\bin\$release\changelog\$Loader $MCversion Changelog.md"
    }
    else {
        # If the .mrpack file doesn't exist, write "No changelog available" and print a warning
        Set-Content "$root\bin\$release\changelog\$Loader $MCversion Changelog.md" -Value "No changelog available"
        Write-Warning "No changelog was available"
    }

    Write-Host "`n$modpackName-$release for $loader $MCversion done" -ForegroundColor Green
}

# Add the changelog to the global changelog with a date timestamp
$newchangelog = Get-Content "$root\bin\$release\Changelog\Fabric 1.20.1 changelog.md"
$globalchangelog = Get-Content "$root\Changelog.md"
$date = "> " + (Get-Date -Format "dd/MM/yyyy")
Set-Content "$root\Changelog.md" -Value ($newchangelog + $date + "`n---`n" + $globalchangelog)

Write-Host "`n`nAll done!" -ForegroundColor Green