param([Parameter(Mandatory)][string]$Output)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$siteSource = [IO.Path]::GetFullPath((Join-Path $root 'OrganizationExample15.webforms'))
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
$package = $env:DOMICILIO_ITEXTSHARP_PACKAGE
if ([string]::IsNullOrWhiteSpace($package)) {
    $package = Join-Path $target 'itextsharp.5.4.4.nupkg'
    Invoke-WebRequest -Uri 'https://api.nuget.org/v3-flatcontainer/itextsharp/5.4.4/itextsharp.5.4.4.nupkg' -OutFile $package
}
$dependency = Join-Path $target 'itextsharp'
[IO.Compression.ZipFile]::ExtractToDirectory($package, $dependency)
$pdfLibrary = Join-Path $dependency 'lib/itextsharp.dll'
if ((Get-FileHash -LiteralPath $pdfLibrary -Algorithm SHA256).Hash.ToLowerInvariant() -ne
    '128edec9e2ab1cb4cf7e803fa08d3e84a40e3db94d4738be430b3817206279d3') {
    throw 'The package does not match the archived iTextSharp binary.'
}
Copy-Item -LiteralPath $pdfLibrary -Destination (Join-Path $site 'Bin')

Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Web.config.example') -Destination (Join-Path $site 'Web.config') -Force
$library = Join-Path $target 'componentes'
python (Join-Path $PSScriptRoot 'exclude-missing-controls.py') $site
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
python (Join-Path $PSScriptRoot 'build-componentes.py') --output $library
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Copy-Item -LiteralPath (Join-Path $library 'bin/SDG.Componentes.dll') -Destination (Join-Path $site 'Bin')
$compiler = Join-Path $env:WINDIR 'Microsoft.NET/Framework/v4.0.30319/aspnet_compiler.exe'
& $compiler -v / -p $site -f (Join-Path $target 'compiled')
exit $LASTEXITCODE
