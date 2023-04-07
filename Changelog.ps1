Set-Location "C:\Users\tbmag\GitHub\Quilt-Optimized\bin"

#get most recent and second most recent version using folder creation date
$latest_version = Get-ChildItem -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object lastwritetime | Select-Object -Last 1
$secondlatest_version = Get-ChildItem -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object lastwritetime | Select-Object -Last 2 | Select-Object -First 1



$old = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$secondlatest_version\Quilt Optimized-$secondlatest_version for 1.19.4.mrpack"

$new = "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Quilt Optimized-$latest_version for 1.19.4.mrpack"

Write-Host  $old
Write-Host  $new

Write-Host "generating changelog between $latest_version and $secondlatest_version"
java -jar C:\Users\tbmag\GitHub\Quilt-Optimized\DevTools\ModListCreator.jar changelog -old $new -new $old -out "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$latest_version\Changelog.md"

#add to global changelog
$verchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$secondlatest_version\Changelog.md"
$globalchangelog = get-content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md"
$date = "> " + (Get-Date -Format "dd/MM/yyyy")
Set-Content "C:\Users\tbmag\GitHub\Quilt-Optimized\Changelog.md" -Value ($verchangelog + $date + "---" + $globalchangelog)
Pause