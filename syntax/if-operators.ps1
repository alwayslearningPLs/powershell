$FirstNumber = 1
$SecondNumber = 2

# operators:
#   - lt, le
#   - gt, ge
#   - eq, ne
#   - like, notlike
#   - match, notmatch
#   - contains, notcontains
#   - in, notin
#   - is, isnot

If ($FirstNumber -lt $SecondNumber) {
  Write-Host "$FirstNumber < $SecondNumber" -ForegroundColor Blue
}

If ($FirstNumber -gt $SecondNumber) {
  Write-Host "$FirstNumber > $SecondNumber" -ForegroundColor Red
}

If ($FirstNumber -le $SecondNumber) {
  Write-Host "$FirstNumber <= $SecondNumber" -ForegroundColor Blue
}

If ($FirstNumber -ge $SecondNumber) {
  Write-Host "$FirstNumber >= $SecondNumber" -ForegroundColor Red
}

If ($FirstNumber -eq $SecondNumber) {
  Write-Host "$FirstNumber = $SecondNumber" -ForegroundColor Green
}

If ($FirstNumber -ne $SecondNumber) {
  Write-Host "$FirstNumber != $SecondNumber" -ForegroundColor Green
}

If ("Hello world" -like 'Hello *') {
  Write-Host "The string matches the like wildcard expression" -ForegroundColor Cyan
}

If ("Bye World" -notlike 'Hello *') {
  Write-Host "The string doesn't match the like wildcard expression" -ForegroundColor Gray
}

If ("0123456789" -match '[0-9]+') {
  Write-Host "The string matches the regex" -ForegroundColor Red
}

If ("0123456789" -notmatch '[a-z]+') {
  Write-Host "The string does not match the regex" -ForegroundColor Red
}

If (@("hello", "world") -contains "world") {
  Write-Host "The collection contains the desired string" -ForegroundColor DarkBlue
}

If ("Bye", "World" -notcontains "Hello") {
  Write-Host "The collection does not contains the desired string" -ForegroundColor DarkGreen
}
