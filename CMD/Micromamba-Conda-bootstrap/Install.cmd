@echo off

echo WARNING: This script relies on Micromamba which may have issues on some systems when installed under a path with spaces.
echo          May also have issues with long paths.&& echo.

set "MAMBA_ROOT_PREFIX=%~dp0\mamba"
set "ENV_DIR=%~dp0\venv"
set MICROMAMBA_DOWNLOAD_URL=https://github.com/mamba-org/micromamba-releases/releases/download/1.4.1-0/micromamba-win-64
@rem desired python version   leave blank for latest
set PYTHON_VERSION=3.10.9

@rem packages and channels to install   must be space seperated   leave blank for empty environment   python will be installed automatically
set "PACKAGES=git"
set "CHANNELS=conda-forge"

@rem automatically prepend channel names with -c for use as arguments
if "%PACKAGES:~0,1%" == " " set "PACKAGES=%PACKAGES:~1%"
if "%CHANNELS:~0,1%" == " " set "CHANNELS=%CHANNELS:~1%"
set "CHANNELS=-c %CHANNELS: = -c %"

@rem download micromamba
if not exist "%MAMBA_ROOT_PREFIX%\micromamba.exe" call :DownloadMicromamba

@rem create virtual environment containing Conda and desired version of python
if not exist "%ENV_DIR%\condabin\conda.bat" call :InstallConda

@rem activate virtual env
call "%ENV_DIR%\condabin\conda.bat" activate "%ENV_DIR%" || goto end

@rem install packages using Conda
call conda install %CHANNELS% %PACKAGES%


@rem task-specific commands go here


goto end


:DownloadMicromamba
echo "Downloading Micromamba from %MICROMAMBA_DOWNLOAD_URL% to %MAMBA_ROOT_PREFIX%\micromamba.exe"
mkdir "%MAMBA_ROOT_PREFIX%"
call curl -Lk "%MICROMAMBA_DOWNLOAD_URL%" > "%MAMBA_ROOT_PREFIX%\micromamba.exe" || ( echo. && echo Micromamba could not be downloaded. && goto end )
echo. && echo Micromamba version:
call "%MAMBA_ROOT_PREFIX%\micromamba.exe" --version || ( echo. && echo Micromamba not found. && goto end )
echo.
exit /b

@rem notice the usage of --always-copy this is necessary for a portable installation of Conda
:InstallConda
call "%MAMBA_ROOT_PREFIX%\micromamba.exe" create -y --always-copy --prefix "%ENV_DIR%" -c conda-forge conda "python=%PYTHON_VERSION%"
echo. && echo Removing Micromamba && echo.
del /q /s "%MAMBA_ROOT_PREFIX%" >nul
rd /q /s "%MAMBA_ROOT_PREFIX%" >nul
if not exist "%ENV_DIR%\condabin\conda.bat" ( echo. && echo Conda install failed. && goto end )
exit /b

:end
pause
exit