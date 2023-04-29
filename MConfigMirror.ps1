Set-Location "C:\Users\User\GitHub\Quilt-Optimized\src"
$destinationFolders = @(
    "fabric/1.16.5","fabric/1.17.1","fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4",
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4"
)

foreach ($destinationFolder in $destinationFolders) {
    Copy-Item ".\config" $destinationFolder -Recurse -Force
}

Write-Host "Mirroring complete!" -f Green
Pause