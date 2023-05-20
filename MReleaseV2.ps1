# Get release number
$release = Read-Host "release number"

# Get second latest version
$olderVersion = (Get-ChildItem -Path "C:\Users\User\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object LastWriteTime)[-2].Name

# Create folder for .mrpack for each modloader and one for changelogs
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "quilt" -ItemType "directory" | Out-Null
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "fabric" -ItemType "directory" | Out-Null
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release" -Name "changelog" -ItemType "directory" | Out-Null

# Contains the list of all the supported editions
$editions = @(
    "fabric/1.16.5", "fabric/1.17.1", "fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4",
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4"
)

# Go to global src folder
Set-Location "C:\Users\User\GitHub\Quilt-Optimized\src"

foreach ($edition in $editions) {
   # Go to a specific edition folder
Set-Location -Path $edition

# Get modloader and MC version
$loader =  $edition.split("/")[0]
$MCversion =  $edition.split("/")[1]

# Update pack.toml
packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader $loader --$loader-latest  --version $release --mc-version $MCversion | Out-Null

# Export .mrpack
packwiz mr export | Out-Null

# Rename .mrpack and move it to bin folder
Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\$loader\Quilt Optimized-$release for $Loader $MCversion.mrpack" | Out-Null

# Go back to global src folder
Set-Location "..\.."

Write-Host "`nQuilt Optimized-$release for $loader $MCversion done" -ForegroundColor Green

# Generate .mrpack's path of the current and older version
$currentPack = "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\$loader\Quilt Optimized-$release for $loader $MCversion.mrpack"
$oldPack = "C:\Users\User\GitHub\Quilt-Optimized\bin\$olderVersion\$loader\Quilt Optimized-$olderVersion for $loader $MCversion.mrpack"

# Create blank changelog file
New-Item -Path "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog" -Name "$Loader $MCversion Changelog.md" -ItemType "file" | Out-Null
    if ((test-path -Path $oldPack) -and (test-path -Path $currentPack)) {
        # Generate changelog
        java -jar "C:\Users\User\GitHub\Modpack DevTools\ModListCreator.jar" changelog -old $oldPack -new $currentPack -out "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog\$Loader $MCversion Changelog.md"
    }
    else {
        # If .mrpack doesn't exist write "No changelog available" and print a warning
        Set-Content "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\changelog\$Loader $MCversion Changelog.md" -Value "No changelog available"
        Write-Warning "No changelog was available"
    }
}

# Add to global changelog
$newchangelog = get-content "C:\Users\User\GitHub\Quilt-Optimized\bin\$release\Changelog\Quilt 1.19.4 changelog.md"    # Get content current changelog
$globalchangelog = get-content "C:\Users\User\GitHub\Quilt-Optimized\Changelog.md"   # Get content of the global changelog(Changelog.md)
$date = "> " + (Get-Date -Format "dd/MM/yyyy")  # Add date to current changelog
Set-Content "C:\Users\User\GitHub\Quilt-Optimized\Changelog.md" -Value ($newchangelog + $date + "`n---`n" + $globalchangelog)  # Add current changelog to global changelog

Write-Host "`n`n`nDone!" -ForegroundColor Green