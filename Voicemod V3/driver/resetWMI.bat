@echo off
cd /D "%~dp0"
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Start-Process 'resetWMIAdmin.bat' -Verb runAs -WindowStyle Hidden -Wait"
