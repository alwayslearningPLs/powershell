
# Standard For loop
For ($i = 0; $i -le 2; $i++) {
  Write-Host "This is the actual number $i" -ForegroundColor Green
}

# Comma separated
For (($i = 0), ($j = 10); $i -lt $j; ($i++), ($j--)) {
  Write-Host "$i + $j = $($i + $j)" -ForegroundColor Green
}

# Sub-Expression
For ($($i = 0; $j = 10); $i -lt $j; $($i++; $j--)) {
  Write-Host "$i + $j = $($i + $j)" -ForegroundColor Green
}

For (($i = 0), ($j = 10); $i -lt $j; $i++, $j--) {
  Write-Host "$i + $j = $($i + $j)" -ForegroundColor Green
}

function IsPalindrome ([string] $str) {
  $result = $True
  For (($i = 0), ($j = $str.Length - 1); $i -lt $j; ($i++), ($j--)) {
    If ($str[$i] -notlike $str[$j]) {
      return $False
    }
  }
  return $result
}

@("notpalindrome", "wow", "noon") | ForEach-Object { Write-Host "The word `"$_`" is palindrome or not? $(IsPalindrome($_))" }
