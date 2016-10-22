# Upload all files from current folder to destination

$Username = "Name"
$Password = "Pass"
$Target = "https://share.example.com/dav/folder"

function Upload-Document([string]$baseUrl){
    $wc = New-Object System.Net.WebClient
    $wc.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
    $input | % {
        if($_.Length -ne $null){
            $fullpath = $_.FullName
            $file = $_.Name
            $targetUrl = "$baseUrl/$file"
            Write-Host "Uploading $_ to $baseUrl/..." –NoNewline
            $wc.UploadFile($targetUrl, "PUT", "$fullpath")
            Write-Host "Done!"
        }
    }
}

function Upload-Documents([string]$baseUrl){
    dir -recurse | Upload-Document $baseUrl
}

Upload-Documents $Target