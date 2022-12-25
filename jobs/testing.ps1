Write-Output "Hello! I'm being executed from a file"

For ($i = 0; $i -lt 10; $i++) {
  Start-Sleep -Seconds 1
  Write-Output "This is my number $i"
}
