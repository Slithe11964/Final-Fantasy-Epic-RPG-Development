$ErrorActionPreference = 'Stop'
$editorProjectRoot = Split-Path -Parent $PSScriptRoot
& (Join-Path $editorProjectRoot 'build-pair.ps1') -Map (Join-Path $PSScriptRoot 'FFERPG-Editor-Master.w3x')
exit $LASTEXITCODE
