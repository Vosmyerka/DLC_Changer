# Made by Vosmyerka
# Version r25.2.6

Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
    using System.Drawing;
"@

$form = New-Object Windows.Forms.Form
$form.Text = "Vosmyerka's DLCChanger"
$form.Size = New-Object Drawing.Size(620, 550)
$form.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28)
$form.ForeColor = [System.Drawing.Color]::White

$defaultFont = [System.Windows.Forms.Control]::DefaultFont

$sourceLabel = New-Object Windows.Forms.Label
$sourceLabel.Text = "Source Directory:"
$sourceLabel.Location = New-Object Drawing.Point(100, 17)
$sourceLabel.Size = New-Object Drawing.Size(150, 20)
$sourceLabel.ForeColor = [System.Drawing.Color]::White
$sourceLabel.Font = New-Object Drawing.Font($defaultFont.FontFamily, 10)
$form.Controls.Add($sourceLabel)

$destinationLabel = New-Object Windows.Forms.Label
$destinationLabel.Text = "Destination Directory:"
$destinationLabel.Location = New-Object Drawing.Point(400, 17)
$destinationLabel.Size = New-Object Drawing.Size(150, 20)
$destinationLabel.ForeColor = [System.Drawing.Color]::White
$destinationLabel.Font = New-Object Drawing.Font($defaultFont.FontFamily, 10)
$form.Controls.Add($destinationLabel)

$sourceTextBox = New-Object Windows.Forms.TextBox
$sourceTextBox.Location = New-Object Drawing.Point(10, 50)
$sourceTextBox.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($sourceTextBox)

$destinationTextBox = New-Object Windows.Forms.TextBox
$destinationTextBox.Location = New-Object Drawing.Point(310, 50)
$destinationTextBox.Size = New-Object Drawing.Size(280, 20)
$form.Controls.Add($destinationTextBox)

$saveButton = New-Object Windows.Forms.Button
$saveButton.Text = "Save Directories"
$saveButton.Location = New-Object Drawing.Point(250, 10)
$saveButton.Size = New-Object Drawing.Size(105, 30)
$saveButton.Font = New-Object Drawing.Font($defaultFont.FontFamily, 8)
$saveButton.BackColor = [System.Drawing.Color]::DarkGoldenrod
$form.Controls.Add($saveButton)

$sourceListBox = New-Object Windows.Forms.ListBox
$sourceListBox.Location = New-Object Drawing.Point(10, 80)
$sourceListBox.Size = New-Object Drawing.Size(280, 280)
$sourceListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$sourceListBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$sourceListBox.ForeColor = [System.Drawing.Color]::White
$sourceListBox.Font = New-Object Drawing.Font($defaultFont.FontFamily, 9)

$form.Controls.Add($sourceListBox)

$destinationListBox = New-Object Windows.Forms.ListBox
$destinationListBox.Location = New-Object Drawing.Point(310, 80)
$destinationListBox.Size = New-Object Drawing.Size(280, 280)
$destinationListBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$destinationListBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$destinationListBox.ForeColor = [System.Drawing.Color]::White
$destinationListBox.Font = New-Object Drawing.Font($defaultFont.FontFamily, 9)

$form.Controls.Add($destinationListBox)

$moveToDestinationButton = New-Object Windows.Forms.Button
$moveToDestinationButton.Text = "Turn DLCs OFF"
$moveToDestinationButton.Location = New-Object Drawing.Point(10, 365)
$moveToDestinationButton.Size = New-Object Drawing.Size(280, 30)
$moveToDestinationButton.BackColor = [System.Drawing.Color]::DarkRed
$form.Controls.Add($moveToDestinationButton)

$moveToSourceButton = New-Object Windows.Forms.Button
$moveToSourceButton.Text = "Turn DLCs ON"
$moveToSourceButton.Location = New-Object Drawing.Point(310, 365)
$moveToSourceButton.Size = New-Object Drawing.Size(280, 30)
$moveToSourceButton.BackColor = [System.Drawing.Color]::DarkGreen
$form.Controls.Add($moveToSourceButton)

$devSectionLabel = New-Object Windows.Forms.Label
$devSectionLabel.Text = "DEVELOPER SECTION / DANGER ZONE"
$devSectionLabel.Location = New-Object Drawing.Point(180, 410)
$devSectionLabel.Size = New-Object Drawing.Size(300, 20)
$devSectionLabel.ForeColor = [System.Drawing.Color]::White
$devSectionLabel.Font = New-Object Drawing.Font($defaultFont.FontFamily, 10)
$form.Controls.Add($devSectionLabel)

$moveAllToDestinationButton = New-Object Windows.Forms.Button
$moveAllToDestinationButton.Text = "Turn All DLCs OFF"
$moveAllToDestinationButton.Location = New-Object Drawing.Point(10, 440)
$moveAllToDestinationButton.Size = New-Object Drawing.Size(280, 30)
$moveAllToDestinationButton.BackColor = [System.Drawing.Color]::DarkBlue
$form.Controls.Add($moveAllToDestinationButton)

$moveAllToSourceButton = New-Object Windows.Forms.Button
$moveAllToSourceButton.Text = "Turn All DLCs ON"
$moveAllToSourceButton.Location = New-Object Drawing.Point(310, 440)
$moveAllToSourceButton.Size = New-Object Drawing.Size(280, 30)
$moveAllToSourceButton.BackColor = [System.Drawing.Color]::DarkCyan
$form.Controls.Add($moveAllToSourceButton)

$dlcFileNames = @(
    @{ FileName = "dlc_balt.scs"; Description = "Beyond the Baltic Sea" },
    @{ FileName = "dlc_east.scs"; Description = "Going East!" },
    @{ FileName = "dlc_greece.scs"; Description = "Greece" },
    @{ FileName = "dlc_iberia.scs"; Description = "Iberia" },
    @{ FileName = "dlc_it.scs"; Description = "Italia" },
    @{ FileName = "dlc_balkan_e.scs"; Description = "Road to the Black Sea" },
    @{ FileName = "dlc_north.scs"; Description = "Scandinavia" },
    @{ FileName = "dlc_fr.scs"; Description = "Vive la France !" },
    @{ FileName = "dlc_balkan_w.scs"; Description = "West Balkans"},
    @{ FileName = "dlc_krone.scs"; Description = "Krone Trailer Pack" },
    @{ FileName = "dlc_feldbinder.scs"; Description = "Feldbinder Trailer Pack" }
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

$documentsFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
$filePath = Join-Path -Path $documentsFolder -ChildPath "dlcchangerdirs.txt"

$saveButton.Add_Click({
    $sourceDir = $sourceTextBox.Text
    $destinationDir = $destinationTextBox.Text
    $filePath = Join-Path -Path $documentsFolder -ChildPath "dlcchangerdirs.txt"
    "$sourceDir`n$destinationDir" | Out-File -FilePath $filePath
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

$moveAllToDestinationButton.Add_Click({
    $sourceDir = $sourceTextBox.Text
    $destinationDir = $destinationTextBox.Text

    if (-not (Test-Path -Path $sourceDir -PathType Container) -or -not (Test-Path -Path $destinationDir -PathType Container)) {
        [System.Windows.Forms.MessageBox]::Show("Source or Destination directory does not exist.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Get-ChildItem -Path $sourceDir -Filter "dlc_*.scs" | ForEach-Object {
        $destinationFile = Join-Path -Path $destinationDir -ChildPath $_.Name
        Move-Item -Path $_.FullName -Destination $destinationFile -Force
    }

    Update-DLCList
})

$moveAllToSourceButton.Add_Click({
    $sourceDir = $sourceTextBox.Text
    $destinationDir = $destinationTextBox.Text

    if (-not (Test-Path -Path $sourceDir -PathType Container) -or -not (Test-Path -Path $destinationDir -PathType Container)) {
        [System.Windows.Forms.MessageBox]::Show("Source or Destination directory does not exist.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    Get-ChildItem -Path $destinationDir -Filter "dlc_*.scs" | ForEach-Object {
        $sourceFile = Join-Path -Path $sourceDir -ChildPath $_.Name
        Move-Item -Path $_.FullName -Destination $sourceFile -Force
    }

    Update-DLCList
})

if (Test-Path -Path $filePath) {
    $savedDirs = Get-Content -Path $filePath -TotalCount 2
    if ($savedDirs.Count -eq 2) {
        $dirs = $savedDirs -split "`n"
        $sourceTextBox.Text = $dirs[0]
        $destinationTextBox.Text = $dirs[1]
    }
}

Update-DLCList

$form.ShowDialog()
