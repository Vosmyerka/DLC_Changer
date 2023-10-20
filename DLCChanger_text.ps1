# Made by Vosmyerka
# Version r23.9.21

# Variables for storing directories
$source_dir = ""
$destination_dir = ""

# Check if there is a file with saved directories
if (Test-Path -Path "directories.txt") {
    $savedDirs = Get-Content "directories.txt"
    $source_dir = $savedDirs[0]
    $destination_dir = $savedDirs[1]
} else {
    # If the file does not exist, request directories from the user
    Write-Output "Example of INPUT directory: C:\SteamLibrary\steamapps\common\Euro Truck Simulator 2"
    $source_dir = Read-Host "Enter INPUT directory:"
    Write-Output ""
    Write-Output "Example of OUTPUT directory: C:\Users\YOURNAME\Desktop\DLCChanger\ets2dlc"
    $destination_dir = Read-Host "Enter OUTPUT directory:"
    "$source_dir`n$destination_dir" | Out-File -FilePath "directories.txt"
}

# Function to move a DLC file
function Move-DLCFile($fileName, $source, $destination) {
    $sourceFile = Join-Path -Path $source -ChildPath $fileName
    $destinationFile = Join-Path -Path $destination -ChildPath $fileName

    if (Test-Path -Path $sourceFile -PathType Leaf) {
        Move-Item -Path $sourceFile -Destination $destination -Force
    } elseif (Test-Path -Path $destinationFile -PathType Leaf) {
        Move-Item -Path $destinationFile -Destination $source -Force
    }
}

# Function to display the list of files and handle user input
function Show-Menu {
    Clear-Host
    Write-Host "DLCs List in Source Directory ($source_dir) and Destination Directory ($destination_dir):"
    Write-Output "------------------"
    $dlcFiles = @(
        "dlc_balkan_e.scs",
        "dlc_balkan_w.scs",
        "dlc_balt.scs",
        "dlc_east.scs",
        "dlc_feldbinder.scs",
        "dlc_fr.scs",
        "dlc_iberia.scs",
        "dlc_it.scs",
        "dlc_krone.scs",
        "dlc_north.scs"
    )

    $existingDLCs = @()
    foreach ($file in $dlcFiles) {
        $sourceFile = Join-Path -Path $source_dir -ChildPath $file
        $destinationFile = Join-Path -Path $destination_dir -ChildPath $file

        $sourceExists = Test-Path -Path $sourceFile -PathType Leaf
        $destinationExists = Test-Path -Path $destinationFile -PathType Leaf

        if ($sourceExists) {
            Write-Host "$($existingDLCs.Count + 1). $file (SOURCE)"
            $existingDLCs += $file
        }
        
        if ($destinationExists) {
            Write-Host "$($existingDLCs.Count + 1). $file (DESTINATION)"
            $existingDLCs += $file
        }
    }

    Write-Host "$($existingDLCs.Count + 1). Return files to Source Directory"
    Write-Host "$($existingDLCs.Count + 2). Exit"

    # Requesting user selection
    $choice = Read-Host "Choose DLCs to move (1-$($existingDLCs.Count + 2)):" -ErrorAction SilentlyContinue

    # User selection processing
    switch ($choice) {
        "10" {
            $destinationFiles = Get-ChildItem -Path $destination_dir
            foreach ($file in $destinationFiles) {
                Move-DLCFile $file.Name $destination_dir $source_dir
            }
        }
        "11" {
            # Exit the program
            exit
        }
        default {
            if ($choice -ge 1 -and $choice -le $existingDLCs.Count) {
                $selectedFile = $existingDLCs[$choice - 1]
                Move-DLCFile $selectedFile $source_dir $destination_dir
            }
        }
    }
}

# Main loop
do {
    Show-Menu
} while ($true)

# Ending the script
Write-Host "Done."
