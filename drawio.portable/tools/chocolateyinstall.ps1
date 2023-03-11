$ErrorActionPreference = 'Stop';

$installDir     = "$env:ChocolateyInstall\lib\$env:ChocolateyPackageName"
$drawioversion  = '20.8.16'
$mainURL        = "https://github.com/jgraph/drawio-desktop/releases/download"
$url            = "$mainURL/v$drawioversion/draw.io-$drawioversion-windows-no-installer.exe"

$packageArgs = @{
    PackageName     = $env:ChocolateyPackageName
    FileFullPath    = "$installDir/drawio.exe"
    url             = $url
    checksum        = '7f784e240b122cf74103e67bb0e474c929c4b4116ff58383c6c09c560fd6f59e'
    checksumType    = 'sha256'
}

Get-ChocolateyWebFile @packageArgs
