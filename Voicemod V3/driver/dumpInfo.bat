@echo off
setlocal enabledelayedexpansion

:: Get CPU name, remove trailing new line
for /f "delims=" %%i in ('wmic cpu get Name /value ^| findstr /V "^$"') do (
    set "cpu_name=%%i"
    set "cpu_name=!cpu_name:Name=!"
    set "cpu_name=!cpu_name:~1,-1!"
)

:: Get memory size in GB using PowerShell, to avoid arithmetic overflow
for /f %%i in ('powershell -Command "[math]::truncate((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)"') do set "memory_size_gb=%%i"

:: Get antivirus name, remove trailing new line
for /f "delims=" %%i in ('wmic /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct get displayName /value ^| findstr /V "^$"') do (
    set "antivirus_name=%%i"
    set "antivirus_name=!antivirus_name:displayName=!"
    set "antivirus_name=!antivirus_name:~1,-1!"
)

:: Get audio devices, properly format them, ensuring quotes are correct
set "audio_devices="
for /f "delims=" %%i in ('wmic path Win32_SoundDevice get Name /value ^| findstr /V "^$"') do (
    set "device=%%i"
    set "device=!device:Name=!"
    set "device=!device:~1,-1!"
    if defined audio_devices (
        set "audio_devices=!audio_devices!,\\\"!device!\\\""
    ) else (
        set "audio_devices=\\\"!device!\\\""
    )
)

:: Ensure audio devices are correctly formatted without leading and trailing commas
set "audio_devices=[!audio_devices!]"

:: Output information as a single line JSON
>%temp%\sysinfo.err (
    echo \"cpu_name\": \"!cpu_name!\", \"memory_size\": \"!memory_size_gb! GB\", \"antivirus_name\": \"!antivirus_name!\", \"audio_devices\": \"!audio_devices!\"
)

endlocal
