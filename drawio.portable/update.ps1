import-module au

$releases = "https://github.com/jgraph/drawio-desktop/releases"

function Get-RemoteFile {
    param (
        [string] $url,
        [string] $file)
    Remove-Item -Force $file -ea ignore
    try {
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $file)
    }
    catch {
        throw $_
    }
    finally {
        $client.Dispose()
    }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]drawioversion\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
      "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    ".\tools\VERIFICATION.txt" = @{
      "(^\s*Source:\s+)(.*)" = "`$1'$($Latest.Dir)/$($Latest.File)'"
      "(^\s*File Hash.*:\s+)(.*)" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $regex   = 'draw\.io-[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}-windows-no-installer\.exe$'
    
    $url     = $download_page.links |
      Where-Object href -match $regex |
      Select-Object -First 1 -expand href

    $version = $url -split '\/|-' |
      Select-Object -Last 1 -Skip 3

    $urlDir = "$releases/download/v$version"
    $urlFile = "draw.io-$version-windows-no-installer.exe"
    
    return @{ Version = $version;
              Dir = $urlDir;
              FileName = $urlFile;
              ChecksumType32 = 'sha256';}
}

function global:au_BeforeUpdate() {
    $hashDir = Resolve-Path tools
    $hashFile = "Files-SHA256-Hashes.txt"
    $hashPath = "$hashDir\$hashFile"

    Get-RemoteFile "$($Latest.Dir)/$hashFile" "$hashPath"

    $regex = "$($Latest.FileName)"
    $regex = $regex.replace('.','\.')
    $regex = "$regex[ ]+(.*)"
    $checkSum = Select-String -Path $hashPath -Pattern $regex
    $checkSum = $checkSum.Matches.Groups[1].Value

    Write-Host "Saving Hash" 
    $global:Latest.Checksum32 = $checkSum
}

Update-Package -ChecksumFor none

