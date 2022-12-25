# Follow this tutorial, awesome: https://learn.microsoft.com/en-us/training/modules/deploy-java-spring-boot-app-service-mysql/3-exercise-build
Param (
  [Parameter(Mandatory=$True, HelpMessage="Specify here the name of the MySQL server")]
  [string] $DatabaseName,
  [Parameter(Mandatory=$True, HelpMessage="Specify here the name of the ResourceGroupName where you have your MySQL server")]
  [string] $ResourceGroupName
)

$BaseDir        = "azure-spring-workshop"
$OutputZipFile  = "response.zip"
$Port           = 8080

Try {
  Get-Item -Path $BaseDir -ErrorAction Stop
  Remove-Item -Path $BaseDir -Recurse -Force
} Catch [System.Management.Automation.ItemNotFoundException] {
  Write-Host "We are not removing anything because the folder $BaseDir does not exists" -ForegroundColor Green
}

# At the end of the URL specify the compress type: zip,tgz 
Invoke-WebRequest -Uri https://start.spring.io/starter.zip `
  -Method Post `
  -Headers @{ 'Content-Type' = 'application/x-www-form-urlencoded' } `
  -Body @{
    type          = 'maven-project';
    dependencies  = 'web,data-jpa,mysql';
    baseDir       = $BaseDir;
    bootVersion   = '2.7.2';
    javaVersion   = '11';
  } `
  -OutFile $OutputZipFile

Expand-Archive -Path $OutputZipFile -DestinationPath .

Remove-Item -Path $OutputZipFile -Force

Set-Content -Path $BaseDir\src\main\resources\application.properties -Value @"
logging.level.org.hibernate.SQL=DEBUG

spring.datasource.url=jdbc:mysql://$((Get-AzMySqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName).FullyQualifiedDomainName):3306/tasks?serverTimezone=UTC
spring.datasource.username=$((Get-AzMySqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName).AdministratorLogin)@$DatabaseName
spring.datasource.password=Thisisnotmyrealpassword69

spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=create-drop

server.port=$Port
"@

yq -i --output-format=xml --input-format=xml '(.project.dependencies.dependency[] | select (.artifactId == "mysql-connector-j") | .version) = "8.0.31"' $BaseDir\pom.xml

yq -i --output-format=xml --input-format=xml '.project.dependencies.dependency |= (. + [{ "groupId": "org.projectlombok", "artifactId": "lombok", "version": "1.18.24", "scope": "provided" }])' $BaseDir\pom.xml

Set-Content -Path $BaseDir\src\main\java\com\example\demo\Todo.java -Value @"
package com.example.demo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Todo {

  @Id
  @GeneratedValue
  private Long id;

  private String description;

  private String details;

  private boolean done;
}
"@

Set-Content -Path $BaseDir\src\main\java\com\example\demo\TodoRepository.java -Value @"
package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;

public interface TodoRepository extends JpaRepository<Todo, Long> {

}
"@

Set-Content -Path $BaseDir\src\main\java\com\example\demo\TodoController.java -Value @"
package com.example.demo;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/")
public class TodoController {

  private final TodoRepository todoRepository;

  @PostMapping("/")
  @ResponseStatus(HttpStatus.CREATED)
  public Todo createTodo(@RequestBody Todo todo) {
    return todoRepository.save(todo);
  }

  @GetMapping("/")
  public Iterable<Todo> getTodos() {
    return todoRepository.findAll();
  }
}
"@

Start-Job -ScriptBlock { mvn -f $using:BaseDir\pom.xml spring-boot:run -DskipTests=true } -Name 'azure-spring'

do {
  Write-Host -Message "Waiting until the web is up and running" -ForegroundColor Green
  Start-Sleep -Seconds 2
} until ((Test-NetConnection -ComputerName localhost -Port $Port -InformationLevel Quiet).TcpTestSucceeded)

Write-Host "Here is the job information: $jobInfo"

$Uri = "http://localhost:$Port"
Invoke-WebRequest -Uri $Uri `
  -Method Post `
  -ContentType "application/json" `
  -Body (@{
    id = "1";
    description = "configuration";
    details = "Congratulations, you have set up your Sprint Boot application correctly!";
    done = "true";
  } | ConvertTo-Json)

(Invoke-WebRequest -Uri $Uri -Method Get | Where-Object StatusCode -eq 200).Content | jq .

Stop-Job -Name 'azure-spring'
Remove-Job -Name 'azure-spring'

Exit

# mvn com.microsoft.azure:azure-webapp-maven-plugin:2.5.0:config
# mvn package com.microsoft.azure:azure-webapp-maven-plugin:2.5.0:deploy
