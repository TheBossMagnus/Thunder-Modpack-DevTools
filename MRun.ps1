# Define the subfolders to search for
$editions = @(
    "fabric/1.16.5", "fabric/1.17.1", "fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4", "fabric/1.20.1",
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4", "quilt/1.20.1"
)

# Define the root folder to search in
$rootFolder = "C:\Users\user\GitHub\Thunder\src"

# Generate the list of subfolders to search in
$subfolders = $editions | ForEach-Object { Join-Path $rootFolder $_ }

# Print the available subfolders to the console
Write-Host "Available subfolders:"
$counter = 1
$editions | ForEach-Object { Write-Host "$counter. $_"; $counter++ }

# Prompt the user to select subfolders to run the command in
$selectedSubfolders = Read-Host "Enter the subfolder numbers separated by commas (or 'a' for all subfolders):"
$selectedSubfolderNumbers = $selectedSubfolders.Split(",")

# Prompt the user to enter the command to run
$command = Read-Host "Enter the command to run in all selected subfolders:"

# If the user selected all subfolders, run the command in all subfolders
if ($selectedSubfolders -eq "a") {
    Write-Host "Running command in all subfolders..."
    foreach ($subfolder in $subfolders) {
        Write-Host "Running command in $($subfolder)..."
        Set-Location $subfolder
        Invoke-Expression $command
    }
}
# Otherwise, run the command in the selected subfolders
else {
    foreach ($number in $selectedSubfolderNumbers) {
        $subfolderPath = $subfolders[$number.Trim() - 1]
        Write-Host "Running command in $($subfolderPath)..."
        Set-Location $subfolderPath
        Invoke-Expression $command
    }
}