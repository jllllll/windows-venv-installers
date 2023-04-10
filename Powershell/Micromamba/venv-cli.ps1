[string]$env:MAMBA_ROOT_PREFIX= "$PSScriptRoot\venv\mamba"
[string]$installerEnvDir = "$PSScriptRoot\venv\env"

$micromambaExe = $env:MAMBA_ROOT_PREFIX + '\micromamba.exe'
if (!(Test-Path $micromambaExe)) {Write-Error 'Micromamba not found.';pause;exit}

# Micromamba hook
. $micromambaExe shell hook -s powershell | Out-String | Invoke-Expression

# activate virtual env
if (Test-Path ($installerEnvDir + '\python.exe')) {micromamba activate $installerEnvDir}
else {Write-Error 'Conda environment is empty.';pause;exit}

# check that the Micromamba environment is properly activated
$mambaInfo = . $micromambaExe info
if ($mambaInfo[10].Split(' ')[-1] -ne $installerEnvDir) {Write-Error 'Micromamba environment could not be activated.';pause;exit}

if ($PSEdition -eq 'Desktop') {. powershell}
else {. pwsh}