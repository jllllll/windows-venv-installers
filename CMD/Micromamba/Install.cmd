@echo off

echo WARNING: This script relies on Micromamba which may have issues on some systems when installed under a path with spaces.
echo          May also have issues with long paths.&& echo.

set "MAMBA_ROOT_PREFIX=%~dp0\venv\mamba"
set "ENV_DIR=%~dp0\venv\env"
set MICROMAMBA_DOWNLOAD_URL=https://github.com/mamba-org/micromamba-releases/releases/download/1.4.1-0/micromamba-win-64

@rem packages and channels to install   must be space seperated   leave blank for empty environment
set "PACKAGES=python git"
set "CHANNELS=anaconda"

@rem automatically prepend channel names with -c for use as arguments
if "%PACKAGES:~0,1%" == " " set "PACKAGES=%PACKAGES:~1%"
if "%CHANNELS:~0,1%" == " " set "CHANNELS=%CHANNELS:~1%"
set CHANNELS=-c %CHANNELS: = -c %

@rem download micromamba
if not exist "%MAMBA_ROOT_PREFIX%\micromamba.exe" call :DownloadMicromamba

@rem create micromamba hook
if not exist "%MAMBA_ROOT_PREFIX%\condabin\micromamba.bat" call "%MAMBA_ROOT_PREFIX%\micromamba.exe" shell hook >nul 2>&1

@rem create the virtual env
if not exist "%ENV_DIR%" (
    echo Packages to install: %PACKAGES%
    echo.
    call "%MAMBA_ROOT_PREFIX%\micromamba.exe" create -y --prefix "%ENV_DIR%" %CHANNELS% %PACKAGES%
)

@rem activate virtual env
call "%MAMBA_ROOT_PREFIX%\condabin\micromamba.bat" activate "%ENV_DIR%" || goto end


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

:end
pause
exit