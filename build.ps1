param(
    [Parameter(Mandatory=$true)][string]$Stage,
    [string]$Base,
    [string]$PythonPath,
    [string]$AllowNew,
    [string]$AllowRemoved
)
$ErrorActionPreference = 'Stop'
if (-not $PythonPath) {
    $bundledPython = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
    if (Test-Path -LiteralPath $bundledPython) { $PythonPath = $bundledPython }
    elseif (Get-Command python -ErrorAction SilentlyContinue) { $PythonPath = 'python' }
    else { throw 'Python 3 is required. Supply -PythonPath with its executable path.' }
}
$buildArgs = @((Join-Path $PSScriptRoot 'tools\build_stage.py'), $Stage)
if ($Base) { $buildArgs += @('--base', $Base) }
if ($AllowNew) { $buildArgs += @('--allow-new', $AllowNew) }
if ($AllowRemoved) { $buildArgs += @('--allow-removed', $AllowRemoved) }
& $PythonPath @buildArgs
exit $LASTEXITCODE
