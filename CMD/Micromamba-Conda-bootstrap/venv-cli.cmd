@echo off

set "ENV_DIR=%~dp0\venv"

if not exist "%ENV_DIR%\condabin\conda.bat" ( echo. && echo Conda not found. && goto end )
call "%ENV_DIR%\condabin\conda.bat" activate "%ENV_DIR%"

cmd /k %*

:end
pause