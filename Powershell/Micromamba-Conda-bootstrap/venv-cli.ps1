[string]$installerEnvDir = "$PSScriptRoot\venv"

$condaExe = $installerEnvDir + '\Scripts\conda.exe'
if (!(Test-Path $condaExe)) {Write-Error 'Conda not found.';pause;exit}

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

if ($PSEdition -eq 'Desktop') {. powershell}
else {. pwsh}