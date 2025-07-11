@echo off
setlocal enabledelayedexpansion

set ERROR_DIR=%temp%
rem set ERROR_DIR=.

del %temp%\AudioEndPointTool.err
del %temp%\voicemodcon.err
del %ERROR_DIR%\AudioEndPointTool_COMM.err
del %ERROR_DIR%\AudioEndPointTool_MULT.err
del %ERROR_DIR%\AudioEndPointTool_CONS.err
del %ERROR_DIR%\UninstallDriver.err
del %ERROR_DIR%\InstallDriver.err

pushd "%CD%"
CD /D "%~dp0"

REM Reset ERRORLEVEL
ver > nul

REM net stop audiosrv /y
set UNINSTALL_ERROR_CODE=%errorlevel%

REM Reset ERRORLEVEL
ver > nul

REM net stop AudioEndpointBuilder /y
set UNINSTALL_ERROR_CODE=!UNINSTALL_ERROR_CODE!, %errorlevel%

REM Reset ERRORLEVEL
ver > nul

call uninstalldriver.bat
set LAST_ERROR_CODE=%errorlevel%
set /p TRACE_CODE=<%temp%\voicemodcon.err
set UNINSTALL_ERROR_CODE=!UNINSTALL_ERROR_CODE!, !TRACE_CODE!, !LAST_ERROR_CODE!

REM Reset ERRORLEVEL
ver > nul

REM net start audiosrv
REM Final error format: stop_srv_error, stop_endpoint_error, voicemodcon_trace, voicemodcon_error, start_srv_error
>%ERROR_DIR%\UninstallDriver.err echo !UNINSTALL_ERROR_CODE!, %errorlevel%

SET DEF_COMM_DEV_ID=
SET DEF_MULTIMEDIA_DEV_ID=
SET DEF_CONSOLE_DEV_ID=

del >%ERROR_DIR%\AudioEndPointToolID.err
REM Reset ERRORLEVEL
ver > nul

AudioEndPointTool.exe get --default --flow=Capture --role=Communications --format=Raw --fields=ID > %ERROR_DIR%\AudioEndPointToolID.err 
set LAST_ERROR_CODE=%errorlevel%
set /p DEF_COMM_DEV_ID=<%ERROR_DIR%\AudioEndPointToolID.err
set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
>%ERROR_DIR%\AudioEndPointTool_COMM.err echo !TRACE_CODE!,!LAST_ERROR_CODE!


del >%ERROR_DIR%\AudioEndPointToolID.err
del %temp%\AudioEndPointTool.err
REM Reset ERRORLEVEL
ver > nul

AudioEndPointTool.exe get --default --flow=Capture --role=Multimedia --format=Raw --fields=ID > %ERROR_DIR%\AudioEndPointToolID.err 
set LAST_ERROR_CODE=%errorlevel%
set /p DEF_MULTIMEDIA_DEV_ID=<%ERROR_DIR%\AudioEndPointToolID.err
set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
>%ERROR_DIR%\AudioEndPointTool_MULT.err echo !TRACE_CODE!,!LAST_ERROR_CODE!

del >%ERROR_DIR%\AudioEndPointToolID.err
del %temp%\AudioEndPointTool.err
REM Reset ERRORLEVEL
ver > nul

AudioEndPointTool.exe get --default --flow=Capture --role=Console --format=Raw --fields=ID > %ERROR_DIR%\AudioEndPointToolID.err 
set LAST_ERROR_CODE=%errorlevel%
set /p DEF_CONSOLE_DEV_ID=<%ERROR_DIR%\AudioEndPointToolID.err
set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
>%ERROR_DIR%\AudioEndPointTool_CONS.err echo !TRACE_CODE!,!LAST_ERROR_CODE!

del %temp%\AudioEndPointTool.err
del %temp%\voicemodcon.err
REM Reset ERRORLEVEL
ver > nul

REM net stop audiosrv /y
set INSTALL_ERROR_CODE=%errorlevel%

REM Reset ERRORLEVEL
ver > nul

REM net stop AudioEndpointBuilder /y
set INSTALL_ERROR_CODE=!INSTALL_ERROR_CODE!, %errorlevel%

REM Reset ERRORLEVEL
ver > nul

voicemodcon install mvvad.inf *VMDriver
set LAST_ERROR_CODE=%errorlevel%
set /p TRACE_CODE=<%temp%\voicemodcon.err
set INSTALL_ERROR_CODE=!INSTALL_ERROR_CODE!, !TRACE_CODE!, !LAST_ERROR_CODE!

REM Reset ERRORLEVEL
ver > nul

REM net start audiosrv
REM Final error format: stop_srv_error, stop_endpoint_error, voicemodcon_trace, voicemodcon_error, start_srv_error
>%ERROR_DIR%\InstallDriver.err echo !INSTALL_ERROR_CODE!, %errorlevel%

echo DEF_CONSOLE_DEV_ID = !DEF_CONSOLE_DEV_ID!
echo DEF_MULTIMEDIA_DEV_ID = !DEF_MULTIMEDIA_DEV_ID!
echo DEF_CONSOLE_DEV_ID = !DEF_CONSOLE_DEV_ID!

IF NOT "%DEF_COMM_DEV_ID%"=="" (
	del %ERROR_DIR%\AudioEndPointTool_COMM.err
	del %temp%\AudioEndPointTool.err
	REM Reset ERRORLEVEL
	ver > nul

	AudioEndPointTool.exe setdefault --id="%DEF_COMM_DEV_ID%" --flow=Capture --role=Communications

	set LAST_ERROR_CODE=%errorlevel%
	set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
	>%ERROR_DIR%\AudioEndPointTool_COMM.err echo !TRACE_CODE!,!LAST_ERROR_CODE!
)

IF NOT "%DEF_MULTIMEDIA_DEV_ID%"=="" (
	del %ERROR_DIR%\AudioEndPointTool_MULT.err
	del %temp%\AudioEndPointTool.err
	REM Reset ERRORLEVEL
	ver > nul

	AudioEndPointTool.exe setdefault --id="%DEF_MULTIMEDIA_DEV_ID%" --flow=Capture --role=Multimedia

	set LAST_ERROR_CODE=%errorlevel%
	set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
	>%ERROR_DIR%\AudioEndPointTool_MULT.err echo !TRACE_CODE!,!LAST_ERROR_CODE!
)

IF NOT "%DEF_CONSOLE_DEV_ID%"=="" (
	del %ERROR_DIR%\AudioEndPointTool_CONS.err
	del %temp%\AudioEndPointTool.err
	REM Reset ERRORLEVEL
	ver > nul

	AudioEndPointTool.exe setdefault --id="%DEF_CONSOLE_DEV_ID%" --flow=Capture --role=Console

	set LAST_ERROR_CODE=%errorlevel%
	set /p TRACE_CODE=<%temp%\AudioEndPointTrace.err
	>%ERROR_DIR%\AudioEndPointTool_CONS.err echo !TRACE_CODE!,!LAST_ERROR_CODE!
)



