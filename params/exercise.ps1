Param (
  [Parameter(Mandatory, HelpMessage="Directory that you want to compress")]
  [string] $From,
  [Parameter(Mandatory, HelpMessage="File path where you want the compressed file")]
  [string] $To
)

If (-Not (Test-Path -Path $From)) {
  Write-Host "Creating the whole web structure under $From directory" -ForegroundColor Green
  New-Item -Path $From -ItemType Directory
  @("index.html", "app.js") | ForEach-Object { New-Item -Path $From\$_ }
}

If (-Not ("$((Get-ChildItem -Path $From).Extension | Sort-Object -Unique)" -match '\.js|\.htm|\.css')) {
  Write-Error -Message "This folder is not a web app" -ErrorAction Stop
}

$date = Get-Date -Format "yyyy-MM-dd"
Compress-Archive -Path $From -CompressionLevel 'Fastest' -DestinationPath "./$To-$date"
Write-Host "Created backup at $($To + '-' + $date + '.zip')"

# To remove the files that you have created, use: Remove-Item -Force -Recurse -Path <ParentFolder>