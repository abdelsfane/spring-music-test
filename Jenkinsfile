#!/usr/bin/env groovy

node {
  //Delete current directory
  deleteDir()

  checkout scm

// ------------------------------- Define Variables ------------------------------------------------
  
  ARTIFACT_URL = "http://3.17.145.188:8081/artifactory/chicago-workshop/"

// ------------------------------- Use Jenkins Credential Store ------------------------------------------------

  withCredentials([
        [
        $class          : 'StringBinding',
        credentialsId   : 'sonarqube',
        variable        : 'SONARQUBE_TOKEN'
        ],[
        $class          : 'UsernamePasswordMultiBinding',
        credentialsId   : 'abdel_pcf_user',
        passwordVariable: 'PCF_PASSWORD',
        usernameVariable: 'PCF_USERNAME'
        ],[
        $class          : 'UsernamePasswordMultiBinding',
        credentialsId   : 'abdel_art_user',
        passwordVariable: 'ART_PASSWORD',
        usernameVariable: 'ART_USERNAME'
        ]]){

// ------------------------------- Spin Up Docker Container ------------------------------------------------

  docker.image('alpine').withRun('-u root'){
    withEnv(['HOME=.']) {
      env.APPLICATION_NAME = APPLICATION_NAME
      env.PCF_ENDPOINT = PCF_ENDPOINT
      env.DEPLOY_SPACE = DEPLOY_SPACE
      env.PCF_ORG = PCF_ORG
      env.ARTIFACT_URL = ARTIFACT_URL
      env.PCF_USERNAME = PCF_USERNAME
      env.PCF_PASSWORD = PCF_PASSWORD
      env.ART_USERNAME = ART_USERNAME
      env.ART_PASSWORD = ART_PASSWORD
      env.SONARQUBE_TOKEN = SONARQUBE_TOKEN
  
// ------------------------------- Run Jenkins Stages ------------------------------------------------
    stage("Pull Spring Music Artifacts") {
      sh '''
        curl -u${ART_USERNAME}:${ART_PASSWORD} -O "${ARTIFACT_URL}/spring-music-app.zip"
        unzip spring-music-app.zip
        '''
    }
    stage('SonarQube analysis') {
        withSonarQubeEnv() { // Will pick the global server connection you have configured
            sh '''
              ./gradlew sonarqube
             '''
        }
      }
    }
  }
 }
}
