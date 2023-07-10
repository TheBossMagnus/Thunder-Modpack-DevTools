# Get the root folder and editions from the command line arguments
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Copy the config folder to each edition folder
foreach ($configFolder in $editions) {
    Copy-Item "$root\src\config" $root\src\$configFolder -Recurse -Force
}

Write-Host "Mirroring complete!" -ForegroundColor Green