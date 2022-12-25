Get-Module -Name Az

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery

# If Import-Module CMDlet fails, then execute 
# Get-ExecutionPolicy (If it returns Restricted, then you should execute the next line)
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
If ((Get-ExecutionPolicy) -like 'Restricted') {
  Write-Host "We need to add permissions"
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
}

# How to update the module? Update-Module -Name Az