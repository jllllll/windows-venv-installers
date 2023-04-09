@echo off

set "ENV_DIR=%~dp0\venv"

if not exist "%ENV_DIR%\Scripts\conda.exe" ( echo. && echo Conda not found. && goto end )

@rem regenerate conda hooks to ensure portability
call "%ENV_DIR%\Scripts\conda.exe" init --no-user >nul 2>&1

call "%ENV_DIR%\condabin\conda.bat" activate "%ENV_DIR%"

cmd /k %*

:end
pause