$ErrorActionPreference = 'Stop';

$installDir     = "$env:ChocolateyInstall\lib\$env:ChocolateyPackageName"
$version        = '7.1.0'
$mainURL        = "https://download.picpick.app"
$url            = "$mainURL/$version/picpick_portable.zip"

$packageArgs = @{
    PackageName     = $env:ChocolateyPackageName
    url             = $url
    UnzipLocation   = $installDir
    checksum        = '1a302381e6ddb427a6a77f42e2a9594783ab0d195c8eb95a0752e0c5967c8183'
    checksumType    = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
