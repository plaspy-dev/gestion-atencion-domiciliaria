param([Parameter(Mandatory)][string]$Output)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$siteSource = [IO.Path]::GetFullPath((Join-Path $root '.'))
$target = [IO.Path]::GetFullPath($Output)
if (Test-Path -LiteralPath $target) { throw 'Use a new output directory.' }
if ($target.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Use a temporary directory outside the checkout.'
}
$site = Join-Path $target 'site'
New-Item -ItemType Directory -Path $site -Force | Out-Null
Get-ChildItem -LiteralPath $siteSource -Force | Where-Object {
    $_.Name -notin @('.git', 'demo', 'vendor', 'bin', 'obj', '.vs')
} | Copy-Item -Destination $site -Recurse -Force
if (Test-Path -LiteralPath (Join-Path $siteSource 'Bin')) {
    Copy-Item -LiteralPath (Join-Path $siteSource 'Bin') -Destination (Join-Path $site 'Bin') -Recurse
}

Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Web.config.example') -Destination (Join-Path $site 'Web.config') -Force
$library = Join-Path $target 'componentes'
$references = Join-Path $library 'references'
New-Item -ItemType Directory -Path $references -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $root 'vendor/componentes') -Destination (Join-Path $library 'source') -Recurse
Copy-Item -LiteralPath (Join-Path $site 'Bin/MySql.Data.dll') -Destination $references
$project = Get-ChildItem -LiteralPath (Join-Path $library 'source') -Filter '*.csproj'
if (@($project).Count -ne 1) { throw 'The recovered library project was not found.' }
dotnet build $project.FullName --configuration Release -m:1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Copy-Item -LiteralPath (Join-Path $library 'source/bin/Release/net48/SDG.Componentes.dll') -Destination (Join-Path $site 'Bin')
$compiler = Join-Path $env:WINDIR 'Microsoft.NET/Framework/v4.0.30319/aspnet_compiler.exe'
& $compiler -v / -p $site -f (Join-Path $target 'compiled')
exit $LASTEXITCODE
