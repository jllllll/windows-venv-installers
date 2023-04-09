[string]$env:MAMBA_ROOT_PREFIX= "$PSScriptRoot\mamba"
[string]$installerEnvDir = "$PSScriptRoot\venv"
[string]$micromambaDownloadUrl = 'https://github.com/mamba-org/micromamba-releases/releases/download/1.4.1-0/micromamba-win-64'

# Desired version of Python to install   leave blank for latest   Required dependency for Conda
[string]$pythonVersion = ''

# Packages to install and channels to install from   comma-seperated
[string[]]$packages = 'git'
[string[]]$packageChannels = 'conda-forge'




function DoTask
{
    # Task-specific commands go here
}




Write-Warning 'This script relies on Micromamba which may have issues on some systems when installed under a long path or under a path with spaces'

$ProgressPreference = 'SilentlyContinue'
$micromambaExe = $env:MAMBA_ROOT_PREFIX + '\micromamba.exe'

# Figure out whether Micromamba needs to be installed and download Micromamba
if (!(Test-Path $env:MAMBA_ROOT_PREFIX)) {mkdir $env:MAMBA_ROOT_PREFIX > $null}
if (!(Test-Path $micromambaExe)) {Invoke-RestMethod $micromambaDownloadUrl -OutFile $micromambaExe}
if (!(Test-Path $micromambaExe)) {Write-Error 'Unable to download Micromamba.';pause;exit}

# Micromamba hook
. $micromambaExe shell hook -s powershell | Out-String | Invoke-Expression

$condaExe = $installerEnvDir + '\Scripts\conda.exe'
# create virtual environment containing Conda and desired version of python
if (!(Test-Path $condaExe))
{
    micromamba create -y --always-copy --prefix $installerEnvDir -c conda-forge conda "python=$pythonVersion"
}

# delete Micromamba as it is no longer needed
if (Test-Path $env:MAMBA_ROOT_PREFIX) {rm $env:MAMBA_ROOT_PREFIX -recurse}

$condaHook = $installerEnvDir + '\shell\condabin\conda-hook.ps1'
# regenerate conda hooks to ensure portability
. $condaExe init --no-user > $null

# execute hook
. $condaHook

# activate virtual env
if (Test-Path ($installerEnvDir + '\python.exe')) {conda activate $installerEnvDir}
else {Write-Error 'Conda environment is empty.';pause;exit}

# check that the Conda environment is properly activated
$condaInfo = conda info
if ($condaInfo[2].Split(' : ')[1] -ne $installerEnvDir) {Write-Error 'Conda environment could not be activated.';pause;exit}

# install packages using Conda
conda install -y $packageChannels.foreach({$_.Trim(' ')}).foreach({'-c',$_}) $packages

DoTask

pause