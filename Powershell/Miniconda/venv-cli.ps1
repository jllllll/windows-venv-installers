[string]$minicondaDir= "$PSScriptRoot\venv\miniconda"
[string]$installerEnvDir = "$PSScriptRoot\venv\env"

$condaExe = $minicondaDir + '\Scripts\conda.exe'
if (!(Test-Path $condaExe)) {Write-Error 'Conda not found.';pause;exit}

$condaHook = $minicondaDir + '\shell\condabin\conda-hook.ps1'
# create Conda Powershell hook if missing for some reason   should be there by default
if (!(Test-Path $condaHook))
{
    . $condaExe init --no-user powershell > $null
}
. $condaHook

# activate virtual env
if (Test-Path ($installerEnvDir + '\python.exe')) {conda activate $installerEnvDir}
else {Write-Error 'Conda environment is empty.';pause;exit}

# check that the Conda environment is properly activated
$condaInfo = conda info
if ($condaInfo[2].Split(' : ')[1] -ne $installerEnvDir) {Write-Error 'Conda environment could not be activated.';pause;exit}

if ($PSEdition -eq 'Desktop') {. powershell}
else {. pwsh}