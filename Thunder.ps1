# Define modpack name, developer name, root directory, and editions array
$modpackName = "Thunder"
$devName = "TheBossMagnus"
$root = "D:\Thunder"
$editions = @(
	"1.16.5\fabric",
	"1.18.2\fabric",
	"1.19.2\quilt",
	"1.19.2\fabric",
	"1.20.1\quilt",
	"1.20.1\fabric",
	"1.20.4\quilt",
	"1.20.4\fabric",
	"1.20.6\quilt",
	"1.20.6\fabric",
	"1.21\quilt",
	"1.21\fabric"
)


# Get the name of the sub-script to run from the command line arguments and the target edition
$script = $args[0]
$Target = $args[1]

# If a target edition was specified, filter the editions array to only include the target edition
if ($Target -ne "") {
	$editions = $editions | Where-Object { $_ -like "$Target*" }
}

# Define arguments to pass to sub-scripts
$arguments = @("-modpackName $modpackName -devName $devName -root $root -editions $editions")

# Call the appropriate sub-script based on the command line argument
if ($script -eq "Update" -or $script -eq "u") {
	Invoke-Expression "& `"MUpdate.ps1`" $arguments"

} elseif ($script -eq "Update-List" -or $script -eq "ul") {
	Invoke-Expression "& `"MUpdateList.ps1`" $arguments"

} elseif ($script -eq "Publish" -or $script -eq "p") {
	Invoke-Expression "& `"MPublish.ps1`" $arguments"

} elseif ($script -eq "Bulk-Run" -or $script -eq "br") {
	Invoke-Expression "& `"MBulkRun.ps1`" $arguments"

} elseif ($script -eq "build" -or $script -eq "b") {
	Invoke-Expression "& `"MBuild.ps1`" $arguments"

} elseif ($script -eq "Help" -or $script -eq "h" -or $script -eq "?") {
	Invoke-Expression "& `"Help.ps1`" $arguments"
} elseif ($script -eq "realease" -or $script -eq "r") {
	Invoke-Expression "& `"MUpdate.ps1`" $arguments"
	Invoke-Expression "& `"MBuild.ps1`" $arguments"
	Invoke-Expression "& `"MPublish.ps1`" $arguments"
} else {
	Write-Warning "Invalid argument"
}
