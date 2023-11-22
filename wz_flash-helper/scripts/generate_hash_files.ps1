#
# Windows Powershell script to generate hash files
#

Write-Host "Generating hash files for partition images"
Write-Host ""

foreach($file in dir .\* -include ('*.bin', '*.tar.gz') ){
    $hash = (Get-FileHash $file -Algorithm SHA256).Hash
    $hash_lowercase = $hash.ToLower()

    $file_basename = (Split-Path $file -leaf)
    
    $hash_file = "$($file).sha256sum"
    $hash_file_contents = "$hash_lowercase","  ","$file_basename"

    Write-Host $hash_file_contents
    $hash_file_contents | Out-File -encoding ascii $hash_file -NoNewline
}

Write-Host ""
Write-Host "Done!"
Start-Sleep 2
