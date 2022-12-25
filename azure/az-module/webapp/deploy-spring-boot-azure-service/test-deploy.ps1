# Testing after everything is deployed
$ResourceGroupName  = 'test-ivan'
$BaseDir            = 'azure-spring-workshop'
$AppName            = (yq --input-format xml '.project.build.plugins.plugin[] | select(.artifactId == "azure-webapp-maven-plugin") | .configuration.appName' $BaseDir\pom.xml)
$FullyQualifiedDNS  = (Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppName).DefaultHostName

Write-Host "Get https://$FullyQualifiedDNS/" -ForegroundColor Green

Invoke-WebRequest -Uri "https://$FullyQualifiedDNS/" `
  -Method Post `
  -ContentType "application/json" `
  -Body (@{
    id = "1";
    description = "configuration";
    details = "Congratulations, you have set up your Sprint Boot application correctly!";
    done = "true";
  } | ConvertTo-Json)

(Invoke-WebRequest -Uri https://$FullyQualifiedDNS/ -Method Get | Where-Object StatusCode -eq 200).Content | jq .
