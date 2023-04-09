@echo off

set "MINICONDA_DIR=%~dp0\venv\miniconda3"
set "ENV_DIR=%~dp0\venv\env"

if not exist "%MINICONDA_DIR%\Scripts\activate.bat" ( echo Miniconda not found. && goto end )
call "%MINICONDA_DIR%\Scripts\activate.bat" activate "%ENV_DIR%"

cmd /k %*

:end
pause