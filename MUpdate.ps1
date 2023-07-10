$root = $args[5]
$editions = $args[7..($args.Length - 1)]

write-host $root
write-host $editions

foreach ($edition in $editions) {
    Set-Location -path "$root\src\$edition"     #go to a specific edition folder
    packwiz.exe update --all    #update all mods with packwiz
    Write-Host "`n"  #go back to global src folder
}

Write-Host "All done!" -ForegroundColor Green