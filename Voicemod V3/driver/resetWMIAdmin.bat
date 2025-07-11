@echo off

setlocal 
pushd

winmgmt /verifyrepository
winmgmt /salvagerepository
net stop winmgmt /y
set LAST_ERROR_CODE=%errorlevel%

rem Added trace code = 1 to unify format 
>%temp%\wmistop.err echo %LAST_ERROR_CODE%, 1

if not %ERRORLEVEL% == 0 (
    popd
    endlocal
    exit /b %LAST_ERROR_CODE%
)


cd c:\Windows\System32\wbem
ren repository repositoryOLD
net start winmgmt /y
for /f %%s in ('dir /b *.mof') do mofcomp %%s
for /r %%d in (*.mfl) do mofcomp "%%d"

popd
endlocal