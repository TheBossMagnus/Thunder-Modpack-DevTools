$release = Read-Host "release number"

New-Item -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\" -Name "$release" -ItemType "directory" | Out-Null

Set-Location -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\src\1.18.2"
$version = Split-Path -Leaf (Get-Location)
packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader Quilt --quilt-latest  --version $release --mc-version $version | Out-Null
packwiz mr export
Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release\Quilt Optimized-$release for $version.mrpack"
write-host "`n Quilt Optimized-$release for $version.mrpack done" -ForegroundColor Green

Set-Location -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\src\1.19.2"
$version = Split-Path -Leaf (Get-Location)
packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader Quilt --quilt-latest  --version $release --mc-version $version | Out-Null
packwiz mr export
Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release\Quilt Optimized-$release for $version.mrpack"
write-host "`n Quilt Optimized-$release for $version.mrpack done" -ForegroundColor Green

Set-Location -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\src\1.19.3"
$version = Split-Path -Leaf (Get-Location)
packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader Quilt --quilt-latest  --version $release --mc-version $version | Out-Null
packwiz mr export
Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release\Quilt Optimized-$release for $version.mrpack"
write-host "`n Quilt Optimized-$release for $version.mrpack done" -ForegroundColor Green

Set-Location -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\src\1.19.4"
$version = Split-Path -Leaf (Get-Location)
packwiz init -r --name "Quilt Optimized" --author TheBossMagnus --modloader Quilt --quilt-latest  --version $release --mc-version $version | Out-Null
packwiz mr export
Move-Item -Path "Quilt Optimized-$release.mrpack" -destination "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$release\Quilt Optimized-$release for $version.mrpack"
write-host "`n Quilt Optimized-$release for $version.mrpack done" -ForegroundColor Green

Write-Host "`nExport done!" -ForegroundColor Green -BackgroundColor White



#====================================================================================================
# Changelog
#====================================================================================================

Set-Location "C:\Users\tbmag\GitHub\Quilt-Optimized\bin"

#get most recent and second most recent version using folder creation date
$latest_version = $release
$secondlatest_version = Get-ChildItem -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object lastwritetime | Select-Object -Last 2 | Select-Object -First 1



$old = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$secondlatest_version\Quilt Optimized-$secondlatest_version for 1.19.4.mrpack"

$new = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Quilt Optimized-$latest_version for 1.19.4.mrpack"


Write-Host "generating changelog between $latest_version and $secondlatest_version"
java -jar C:\Users\tbmag\GitHub\Quilt-Optimized\DevTools\ModListCreator.jar changelog -old $old -new $new -out "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Changelog.md"

#add to global changelog
$verchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Changelog.md"
$globalchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md"
$date = "> " + (Get-Date -Format "dd/MM/yyyy")
Set-Content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md" -Value ($verchangelog + $date + "---" + $globalchangelog)

Write-Host "`nChangelog done!" -ForegroundColor Green -BackgroundColor White
Pause