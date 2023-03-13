import-module au

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.Version)'"
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"}
        
        ".\tools\VERIFICATION.txt" = @{
            "(^\s*Source:\s+)(.*)"      = "`$1'$($Latest.URL32)'"
            "(^\s*File Hash.*:\s+)(.*)" = "`$1'$($Latest.Checksum32)'"}
    }
}


function global:au_GetLatest {
    $releases = 'https://picpick.app/en/changelog'
    $response = Invoke-WebRequest -URI $releases
    $HTML = New-Object -Com "HTMLFile"
    $HTML.IHTMLDocument2_write($response.Content)
    
    $version = $HTML.all.tags("h2") |
      ForEach-Object{$_.innerHTML} |
      Select-Object -First 1
    $version = $version -split ' ' |
      Select-Object -First 1

    $mainURL        = "https://download.picpick.app"
    $url            = "$mainURL/$version/picpick_portable.zip"
    
    return @{
        Version         = $version;
        URL32           = $url;
        ChecksumType32  = 'sha256';}
}

Update-Package -ChecksumFor 32
