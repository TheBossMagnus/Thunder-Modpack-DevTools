# Get the root folder and editions from the command line arguments
$root = $args[5]
$editions = $args[7..($args.Length - 1)]

# Prompt the user to enter the command to run
$command = Read-Host "Enter the command to run in all selected subfolders:"


foreach ($edition in $editions) {
        # Get the path of the selected subfolder
        Write-Host "Running command in $($edition)..."
        Set-Location "$root\src\$edition"
        Invoke-Expression $command
    }
