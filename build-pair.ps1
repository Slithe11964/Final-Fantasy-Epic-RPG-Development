param(
    [string]$Map = 'editor\FFERPG-Editor-Master.w3x',
    [string]$Stage = ('EDIT' + (Get-Date -Format 'yyyyMMddHHmmss')),
    [string]$PythonPath
)
$ErrorActionPreference = 'Stop'
if (-not [System.IO.Path]::IsPathRooted($Map)) { $Map = Join-Path $PSScriptRoot $Map }
if (-not $PythonPath) {
    $pairPython = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
    if (Test-Path -LiteralPath $pairPython) { $PythonPath = $pairPython }
    elseif (Get-Command python -ErrorAction SilentlyContinue) { $PythonPath = 'python' }
    else { throw 'Python 3 is required. Supply -PythonPath with its executable path.' }
}
& $PythonPath (Join-Path $PSScriptRoot 'tools\build_pair.py') --map $Map --stage $Stage
exit $LASTEXITCODE
