@echo off

set "MAMBA_ROOT_PREFIX=%~dp0\venv\mamba"
set "ENV_DIR=%~dp0\venv\env"

if not exist "%MAMBA_ROOT_PREFIX%\micromamba.exe" ( echo. && echo Micromamba not found && goto end )
if not exist "%MAMBA_ROOT_PREFIX%\condabin\micromamba.bat" call "%MAMBA_ROOT_PREFIX%\micromamba.exe" shell hook >nul 2>&1
call "%MAMBA_ROOT_PREFIX%\condabin\micromamba.bat" activate "%ENV_DIR%" || goto end

cmd /k %*

:end
pause