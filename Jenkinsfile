pipeline {
  agent any
  
  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }
    
    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }
    
    stage('Analyze') {
      steps {
        script {
          def scannerHome = tool 'sonarqube-scanner'
          withSonarQubeEnv('SonarQube') {
            sh "${scannerHome}/bin/sonar-scanner"
          }
        }
      }
    }
    
    stage('Deploy to Nexus') {
      steps {
        nexusArtifactUploader {
          nexusVersion('nexus3')
          protocol('http')
          nexusUrl('http://nexus:8081/nexus')
          groupId('com.example')
          version('1.0-SNAPSHOT')
          repositoryId('snapshots')
          credentialsId('nexus-credentials')
          artifacts {
            artifact {
              artifactId('myapp')
              type('war')
              classifier('')
              fileLocation('target/myapp.war')
              pomDir('')
              version('1.0-SNAPSHOT')
            }
          }
        }
      }
    }
    
    stage('Deploy to Tomcat') {
      steps {
        sh 'curl -T target/myapp.war "http://tomcat:8080/manager/text/deploy?path=/myapp&update=true" --user "admin:admin"'
      }
    }
  }
}
