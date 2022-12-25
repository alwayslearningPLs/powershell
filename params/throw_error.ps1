Param (
  [int] $FirstParam
)

Try {
  If ($FirstParam -le 10) {
    Throw "`$FirstParam can't be less or equal than 10. Actual: $FirstParam"
  }
} Catch [System.IO.IOException] {
  Write-Host "Something IO went wrong: $($_.Exception.Message)"
} Catch {
  Write-Host "Something about `$FirstParam went wrong: $($_.Exception.Message)"
  Write-Host $_.ScriptStackTrace
}

Try {
  Get-Content '.\file.txt' -ErrorAction Stop
} Catch {
  Write-Host "$($_.Exception.Message))"
}