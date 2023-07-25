# Define modpack name, developer name, root directory, and editions array
$modpackName = "Storm"
$devName = "TheBossMagnus"
$root = "C:\Users\User\GitHub\Storm"
$editions = @(
    "fabric/1.20.1"
)

# Define arguments to pass to sub-scripts
$arguments = @("-modpackName $modpackName -devName $devName -root $root -editions $editions")

# Get the name of the sub-script to run from the command line arguments
$script = $args[0]

# Call the appropriate sub-script based on the command line argument
if ($script -eq "Update" -or $script -eq "u") {
    Invoke-Expression "& `"MUpdate.ps1`" $arguments"

} elseif ($script -eq "Publish" -or $script -eq "p") {
    Invoke-Expression "& `"MPublish.ps1`" $arguments"

} elseif ($script -eq "Bulk-Run" -or $script -eq "br") {
    Invoke-Expression "& `"MBulkRun.ps1`" $arguments"

} elseif ($script -eq "Release" -or $script -eq "r") {
    Invoke-Expression "& `"MRelease.ps1`" $arguments"

} elseif ($script -eq "Mirror-Config"  -or $script -eq "mc") {
    Invoke-Expression "& `"MMirrorConfig.ps1`" $arguments"

} elseif ($script -eq "Help"  -or $script -eq "h" -or $script -eq "?") {
    Invoke-Expression "& `"Help.ps1`" $arguments"

} else {
    Write-Warning "Invalid argument"
}