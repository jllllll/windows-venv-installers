[string]$env:MAMBA_ROOT_PREFIX= "$PSScriptRoot\venv\mamba"
[string]$installerEnvDir = "$PSScriptRoot\venv\env"
[string]$micromambaDownloadUrl = 'https://github.com/mamba-org/micromamba-releases/releases/download/1.4.1-0/micromamba-win-64'

# Desired version of Python to install   leave blank for latest
[string]$pythonVersion = ''

# Packages to install and channels to install from   comma-seperated
[string[]]$packages = "python=$pythonVersion",'git'
[string[]]$packageChannels = 'conda-forge'




function DoTask
{
    # Task-specific commands go here
}




Write-Warning 'This script relies on Micromamba which may have issues on some systems when installed under a long path'

$ProgressPreference = 'SilentlyContinue'
$micromambaExe = $env:MAMBA_ROOT_PREFIX + '\micromamba.exe'

# Figure out whether Micromamba needs to be installed and download Micromamba
if (!(Test-Path $env:MAMBA_ROOT_PREFIX)) {mkdir $env:MAMBA_ROOT_PREFIX > $null}
if (!(Test-Path $micromambaExe)) {Invoke-RestMethod $micromambaDownloadUrl -OutFile $micromambaExe}
if (!(Test-Path $micromambaExe)) {Write-Error 'Unable to download Micromamba.';pause;exit}

# Micromamba hook
. $micromambaExe shell hook -s powershell | Out-String | Invoke-Expression

# create the virtual env if missing
if (!(Test-Path ($installerEnvDir + '\python.exe')))
{
	micromamba create -y --prefix $installerEnvDir $packageChannels.foreach({$_.Trim(' ')}).foreach({'-c',$_}) $packages
}

# activate virtual env
if (Test-Path ($installerEnvDir + '\python.exe')) {micromamba activate $installerEnvDir}
else {Write-Error 'Micromamba environment is empty.';pause;exit}

# check that the Micromamba environment is properly activated
$mambaInfo = . $micromambaExe info
if ($mambaInfo[10].Split(' : ')[1] -ne $installerEnvDir) {Write-Error 'Micromamba environment could not be activated.';pause;exit}

DoTask

pause