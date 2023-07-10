$root = $args[5]
$editions = $args[7..($args.Length - 1)]

foreach ($configFolder in $editions) {
    Copy-Item "$root\src\config" $root\src\$configFolder -Recurse -Force
}

Write-Host "Mirroring complete!" -f Green