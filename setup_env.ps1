# Setup local Python virtual environment and install project dependencies.
# Run this from PowerShell in the folder that contains this script.

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

function Get-PythonCommand {
    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($null -eq $pythonCmd) {
        $pythonCmd = Get-Command py -ErrorAction SilentlyContinue
    }
    if ($null -eq $pythonCmd) {
        throw 'Python executable not found on PATH. Install Python or use the Microsoft Store/uv environment path manually.'
    }
    return $pythonCmd.Source
}

$pythonExe = Get-PythonCommand
Write-Host "Using Python: $pythonExe"

$venvDir = Join-Path $projectRoot '.venv'
if (-not (Test-Path $venvDir)) {
    Write-Host 'Creating virtual environment .venv ...'
    & $pythonExe -m venv $venvDir
    if ($LASTEXITCODE -ne 0) {
        throw 'Failed to create virtual environment.'
    }
} else {
    Write-Host 'Virtual environment .venv already exists.'
}

$venvPython = Join-Path $venvDir 'Scripts\python.exe'
if (-not (Test-Path $venvPython)) {
    throw "Virtual environment Python not found at $venvPython"
}

Write-Host 'Upgrading pip, setuptools, and wheel...'
& $venvPython -m pip install --upgrade pip setuptools wheel
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to upgrade pip/setuptools/wheel.'
}

function Find-ProjectFile($fileName) {
    $rootPath = Join-Path $projectRoot $fileName
    if (Test-Path -LiteralPath $rootPath) {
        return $rootPath
    }

    $found = Get-ChildItem -Path $projectRoot -Recurse -File -Filter $fileName -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\.venv\\' -and $_.FullName -notmatch '\\.git\\' } |
        Select-Object -First 1

    if ($found) {
        return $found.FullName
    }

    # explicit nested folder fallback for this workspace
    $nestedPath = Join-Path $projectRoot "AI_Chatbot_for_Mentsl_health-\$fileName"
    if (Test-Path -LiteralPath $nestedPath) {
        return $nestedPath
    }

    return $null
}

$requirementsFile = Find-ProjectFile 'requirements.txt'
$appFile = Find-ProjectFile 'app.py'

if (-not $requirementsFile) {
    throw 'Could not find requirements.txt in the project root or nested subfolders.'
}
if (-not $appFile) {
    Write-Host 'Warning: app.py not found in the project. Install dependencies first and then run the correct app file manually.'
}

Write-Host "Installing dependencies from $requirementsFile ..."
& $venvPython -m pip install -r $requirementsFile
if ($LASTEXITCODE -ne 0) {
    throw 'Dependency installation failed. Check your network connection and retry.'
}

Write-Host '`nSetup complete.`n'
Write-Host 'Activate the environment with:'
Write-Host '    .\.venv\Scripts\Activate.ps1'
Write-Host 'Then run:'
Write-Host "    python -m pip list --format=columns"
if ($appFile) {
    Write-Host "    python $appFile"
} else {
    Write-Host '    streamlit run <path-to-app.py>'
}
