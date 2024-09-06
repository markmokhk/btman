@echo off
setlocal enabledelayedexpansion

REM Get the current directory
set "current_dir=%~dp0"

REM Get the parent folder name
for %%I in ("%current_dir:~0,-1%") do set "parent_folder=%%~nxI"

REM Get the root folder name
for %%I in ("%current_dir:~0,-1%\..\..") do set "root_folder=%%~nxI"

REM Create a sanitized name for the shortcut
set "sanitized_name=%root_folder%_%parent_folder%"
set "sanitized_name=%sanitized_name: =%"
set "sanitized_name=%sanitized_name:&=%"
set "sanitized_name=%sanitized_name:(=%"
set "sanitized_name=%sanitized_name:)=%"
set "sanitized_name=%sanitized_name:,=%"

REM Create the shortcut in the same directory
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%current_dir%%sanitized_name%_Terminal.lnk'); $Shortcut.TargetPath = '%current_dir%terminal.exe'; $Shortcut.Arguments = '/portable'; $Shortcut.WorkingDirectory = '%current_dir%'; $Shortcut.IconLocation = '%current_dir%terminal.ico'; $Shortcut.Save()"

echo Shortcut created in the current directory.

