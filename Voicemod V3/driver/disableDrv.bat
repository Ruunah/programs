@echo off
setlocal enabledelayedexpansion

SET ERROR_CODE=0,1003
SET VM_DEV_MIC_ID=
FOR /F %%I IN ('AudioEndPointTool.exe get --name=Voicemod --flow=Capture --format=Raw --fields=ID') DO SET "VM_DEV_MIC_ID=%%I"
IF NOT "%VM_DEV_MIC_ID%"=="" (
	AudioEndPointTool.exe setvisibility --id="%VM_DEV_MIC_ID%" --visible=false
	>%temp%\AudioEndPointTool_COMM.err echo !ERROR_CODE!
	set ERROR_CODE=!ERROR_CODE!,%errorlevel%
)

>%temp%\disabledrv.err echo !ERROR_CODE!

SET ERROR_CODE=0,1003
SET VM_DEV_MIC_ID=
FOR /F %%I IN ('AudioEndPointTool.exe get --name=Voicemod --flow=Render --format=Raw --fields=ID') DO SET "VM_DEV_MIC_ID=%%I"
IF NOT "%VM_DEV_MIC_ID%"=="" (
	AudioEndPointTool.exe setvisibility --id="%VM_DEV_MIC_ID%" --visible=false
	>%temp%\AudioEndPointTool_COMM.err echo !ERROR_CODE!
	set ERROR_CODE=!ERROR_CODE!,%errorlevel%
)

>%temp%\disabledrv.err echo !ERROR_CODE!

