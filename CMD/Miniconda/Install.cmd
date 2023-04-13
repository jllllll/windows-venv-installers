@echo off

echo "%~dp0"| findstr /C:" " >nul && echo This script relies on Miniconda which can not be installed under a path with spaces.&& goto end
echo WARNING: This script relies on Miniconda which may have issues on some systems when installed under a long path.&& echo.

set "MINICONDA_DIR=%~dp0\venv\miniconda"
set "ENV_DIR=%~dp0\venv\env"
set MINICONDA_DOWNLOAD_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe

@rem packages and channels to install   must be space seperated   leave blank for empty environment
set "PACKAGES=python git"
set "CHANNELS=conda-forge"

@rem automatically prepend channel names with -c for use as arguments
if "%PACKAGES:~0,1%" == " " set "PACKAGES=%PACKAGES:~1%"
if "%CHANNELS:~0,1%" == " " set "CHANNELS=%CHANNELS:~1%"
set CHANNELS=-c %CHANNELS: = -c %

if not exist "%MINICONDA_DIR%\Scripts\conda.exe" (
    @rem download miniconda
    echo Downloading Miniconda installer from %MINICONDA_DOWNLOAD_URL%
    mkdir "%MAMBA_ROOT_PREFIX%"
    call curl -LOk "%MINICONDA_DOWNLOAD_URL%"
    echo.

    call :InstallMiniconda
)

@rem activate miniconda
call "%MINICONDA_DIR%\Scripts\activate.bat" || ( echo Miniconda hook not found. && goto end )

@rem create the virtual env
if not exist "%ENV_DIR%" (
    echo Packages to install: %PACKAGES%
    echo.
    call conda create --no-shortcuts -y -p "%ENV_DIR%" %CHANNELS% %PACKAGES%
)

@rem activate virtual env
call conda activate "%ENV_DIR%" || ( echo Conda environment activation failed. && goto end )


@rem task-specific commands go here


goto end


:InstallMiniconda
echo. && echo Installing Miniconda To "%MINICONDA_DIR%" && echo Please Wait... && echo.
start "" /W /D "%~dp0" "Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /NoShortcuts=1 /AddToPath=0 /RegisterPython=0 /NoRegistry=1 /S /D=%MINICONDA_DIR% || ( echo Miniconda installer not found. && goto end )
del /q "Miniconda3-latest-Windows-x86_64.exe"
if not exist "%MINICONDA_DIR%\Scripts\conda.exe" ( echo Miniconda install failed. && goto end )
exit /b

:end
pause
exit