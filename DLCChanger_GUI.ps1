# Made by Vosmyerka
# Version r23.9.18

Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
    using System.Drawing;
"@

$form = New-Object Windows.Forms.Form
$form.Text = "DLC Changer"
$form.Size = New-Object Drawing.Size(650, 450)
$form.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28)
$form.ForeColor = [System.Drawing.Color]::White

$sourceLabel = New-Object Windows.Forms.Label
$sourceLabel.Text = "Source Directory:"
$sourceLabel.Location = New-Object Drawing.Point(100, 10)
$sourceLabel.Size = New-Object Drawing.Size(120, 20)
$sourceLabel.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($sourceLabel)

$destinationLabel = New-Object Windows.Forms.Label
$destinationLabel.Text = "Destination Directory:"
$destinationLabel.Location = New-Object Drawing.Point(400, 10)
$destinationLabel.Size = New-Object Drawing.Size(120, 20)
$destinationLabel.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($destinationLabel)

$sourceTextBox = New-Object Windows.Forms.TextBox
$sourceTextBox.Location = New-Object Drawing.Point(10, 40)
$sourceTextBox.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($sourceTextBox)

$destinationTextBox = New-Object Windows.Forms.TextBox
$destinationTextBox.Location = New-Object Drawing.Point(310, 40)
$destinationTextBox.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($destinationTextBox)

$saveButton = New-Object Windows.Forms.Button
$saveButton.Text = "Save Directories"
$saveButton.Location = New-Object Drawing.Point(250, 10)
$saveButton.Size = New-Object Drawing.Size(100, 20)
$form.Controls.Add($saveButton)

$sourceListBox = New-Object Windows.Forms.ListBox
$sourceListBox.Location = New-Object Drawing.Point(10, 70)
$sourceListBox.Size = New-Object Drawing.Size(280, 280)
$sourceListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$sourceListBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$sourceListBox.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($sourceListBox)

$destinationListBox = New-Object Windows.Forms.ListBox
$destinationListBox.Location = New-Object Drawing.Point(310, 70)
$destinationListBox.Size = New-Object Drawing.Size(280, 280)
$destinationListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$destinationListBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$destinationListBox.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($destinationListBox)

$moveToDestinationButton = New-Object Windows.Forms.Button
$moveToDestinationButton.Text = "Turn DLCs OFF"
$moveToDestinationButton.Location = New-Object Drawing.Point(10, 360)
$moveToDestinationButton.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($moveToDestinationButton)

$moveToSourceButton = New-Object Windows.Forms.Button
$moveToSourceButton.Text = "Turn DLCs ON"
$moveToSourceButton.Location = New-Object Drawing.Point(310, 360)
$moveToSourceButton.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($moveToSourceButton)

$dlcFileNames = @(
    @{ FileName = "dlc_balkan_e.scs"; Description = "Road to the Black Sea" },
    @{ FileName = "dlc_balt.scs"; Description = "Beyond the Baltic Sea" },
    @{ FileName = "dlc_east.scs"; Description = "Going East!" },
    @{ FileName = "dlc_feldbinder.scs"; Description = "Feldbinder Trailer Pack" },
    @{ FileName = "dlc_fr.scs"; Description = "Vive la France !" },
    @{ FileName = "dlc_iberia.scs"; Description = "Iberia" },
    @{ FileName = "dlc_it.scs"; Description = "Italia" },
    @{ FileName = "dlc_krone.scs"; Description = "Krone Trailer Pack" },
    @{ FileName = "dlc_north.scs"; Description = "Scandinavia" }
)
function Update-DLCList {
    $sourceListBox.Items.Clear()
    $destinationListBox.Items.Clear()
    
    $sourceDir = $sourceTextBox.Text
    $destinationDir = $destinationTextBox.Text

    if ($sourceDir -ne "" -and $destinationDir -ne "") {
        foreach ($dlc in $dlcFileNames) {
            $fileName = $dlc.FileName
            $sourceFile = Join-Path -Path $sourceDir -ChildPath $fileName
            $destinationFile = Join-Path -Path $destinationDir -ChildPath $fileName

            $sourceExists = $false
            $destinationExists = $false

            if (Test-Path -Path $sourceFile -PathType Leaf) {
                $sourceExists = $true
            }

            if (Test-Path -Path $destinationFile -PathType Leaf) {
                $destinationExists = $true
            }

            if ($sourceExists) {
                $sourceListBox.Items.Add($dlc.Description)
            }

            if ($destinationExists) {
                $destinationListBox.Items.Add($dlc.Description)
            }
        }
    }
}

$saveButton.Add_Click({
    $sourceDir = $sourceTextBox.Text
    $destinationDir = $destinationTextBox.Text
    "$sourceDir`n$destinationDir" | Out-File -FilePath "directories.txt"
    Update-DLCList
})

$moveToDestinationButton.Add_Click({
    $selectedItems = $sourceListBox.SelectedItems
    if ($selectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Select files to move to the destination directory.", "No Files Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    foreach ($item in $selectedItems) {
        $selectedFileName = $item -replace " \(Source Directory\)$"
        $selectedDLC = $dlcFileNames | Where-Object { $_.Description -eq $selectedFileName }

        if ($selectedDLC -ne $null) {
            $sourceFile = Join-Path -Path $sourceTextBox.Text -ChildPath $selectedDLC.FileName
            $destinationFile = Join-Path -Path $destinationTextBox.Text -ChildPath $selectedDLC.FileName
            
            if (Test-Path -Path $sourceFile -PathType Leaf) {
                Move-Item -Path $sourceFile -Destination $destinationFile -Force
            }
        }
    }

    Update-DLCList
})

$moveToSourceButton.Add_Click({
    $selectedItems = $destinationListBox.SelectedItems
    if ($selectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Select files to move to the source directory.", "No Files Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    foreach ($item in $selectedItems) {
        $selectedFileName = $item -replace " \(Destination Directory\)$"
        $selectedDLC = $dlcFileNames | Where-Object { $_.Description -eq $selectedFileName }

        if ($selectedDLC -ne $null) {
            $sourceFile = Join-Path -Path $sourceTextBox.Text -ChildPath $selectedDLC.FileName
            $destinationFile = Join-Path -Path $destinationTextBox.Text -ChildPath $selectedDLC.FileName
            
            if (Test-Path -Path $destinationFile -PathType Leaf) {
                Move-Item -Path $destinationFile -Destination $sourceFile -Force
            }
        }
    }

    Update-DLCList
})

if (Test-Path -Path "directories.txt") {
    $savedDirs = Get-Content -Path "directories.txt" -TotalCount 2
    if ($savedDirs.Count -eq 2) {
        $dirs = $savedDirs -split "`n"
        $sourceTextBox.Text = $dirs[0]
        $destinationTextBox.Text = $dirs[1]
    }
}

Update-DLCList

$form.ShowDialog()