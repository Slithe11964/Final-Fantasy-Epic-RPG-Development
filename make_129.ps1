param(
    [string]$Map,
    [string]$Out,
    [string]$PythonPath
)
$ErrorActionPreference = 'Stop'
if (-not $PythonPath) {
    $bundledPython = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
    if (Test-Path -LiteralPath $bundledPython) { $PythonPath = $bundledPython }
    elseif (Get-Command python -ErrorAction SilentlyContinue) { $PythonPath = 'python' }
    else { throw 'Python 3 is required. Supply -PythonPath with its executable path.' }
}
if (-not $Map) { $Map = Join-Path $PSScriptRoot 'baseline\Reforged\FFERPG_0.9.7.3-r16.w3x' }
$Map = (Resolve-Path -LiteralPath $Map).Path
if (-not $Out) { $Out = Join-Path $PSScriptRoot ('release\1.29.2\' + [IO.Path]::GetFileName($Map)) }
if (Test-Path -LiteralPath $Out) { throw "Output already exists: $Out. Choose a new output or archive the existing copy." }
if (Test-Path -LiteralPath ($Out + '.tmp')) { throw "Temporary output already exists: $Out.tmp" }
$outputDirectory = Split-Path -Parent ([IO.Path]::GetFullPath($Out))
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$template = Join-Path $PSScriptRoot 'baseline\1.29.2\FFERPG_0.9.7.3-r16.w3x'
& $PythonPath (Join-Path $PSScriptRoot 'tools\downgrade.py') $Map $Out --w3i-template $template --fill-from $template --name ([IO.Path]::GetFileNameWithoutExtension($Map)) --fferpg-visuals
exit $LASTEXITCODE
