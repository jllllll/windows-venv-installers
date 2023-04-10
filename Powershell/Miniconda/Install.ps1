[string]$minicondaDir= "$PSScriptRoot\venv\miniconda"
[string]$installerEnvDir = "$PSScriptRoot\venv\env"
[string]$minicondaDownloadUrl = 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe'

# Desired version of Python to install   leave blank for latest
[string]$pythonVersion = ''

# Packages to install and channels to install from   comma-seperated
[string[]]$packages = "python=$pythonVersion",'git'
[string[]]$packageChannels = 'conda-forge'




function DoTask
{
    # Task-specific commands go here
}




if ($PSScriptRoot.Contains(' ')) {Write-Error 'This script relies on Miniconda which can not be installed under a path with spaces'}
Write-Warning 'This script relies on Miniconda which may have issues on some systems when installed under a long path'

$condaExe = $minicondaDir + '\Scripts\conda.exe'

# Figure out whether Miniconda needs to be installed and download Miniconda
if (!(Test-Path $minicondaDir)) {mkdir $minicondaDir > $null}
if (!(Test-Path $condaExe))
{
    Write-Progress "Installing Miniconda to: $minicondaDir" "Downloading..."

    $ProgressPreference = 'SilentlyContinue'
    Invoke-RestMethod $minicondaDownloadUrl -OutFile ($PSScriptRoot + '\Miniconda3-latest-Windows-x86_64.exe')
    $ProgressPreference = 'Continue'

    Write-Progress "Installing Miniconda to: $minicondaDir" "Installing..."

    start -Wait '.\Miniconda3-latest-Windows-x86_64.exe' ("/InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /NoRegistry=1 /S /D=$minicondaDir").split(' ')
    
    Write-Progress "Installing Miniconda to: $minicondaDir" -completed
}
if (!(Test-Path $condaExe)) {Write-Error 'Failed to download or install Miniconda.';pause;exit}
else {rm '.\Miniconda3-latest-Windows-x86_64.exe'}

$condaHook = $minicondaDir + '\shell\condabin\conda-hook.ps1'
# create Conda Powershell hook if missing for some reason   should be there by default
if (!(Test-Path $condaHook))
{
    . $condaExe init --no-user powershell > $null
}
. $condaHook

# create virtual environment
if (!(Test-Path ($installerEnvDir + '\python.exe')))
{
    conda create -y -p $installerEnvDir $packageChannels.foreach({$_.Trim(' ')}).foreach({'-c',$_}) $packages
}

# activate virtual env
if (Test-Path ($installerEnvDir + '\python.exe')) {conda activate $installerEnvDir}
else {Write-Error 'Conda environment is empty.';pause;exit}

# check that the Conda environment is properly activated
$condaInfo = conda info
if ($condaInfo[2].Split(' ')[-1] -ne $installerEnvDir) {Write-Error 'Conda environment could not be activated.';pause;exit}

DoTask

pause