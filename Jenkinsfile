pipeline {
  agent any
  environment {
    IMAGE = "itsmezayynn/heart-disease-api"
    DOCKERHUB_CREDS = "Complicated@1"
    EMAIL = "itsmezayynn@gmail.com"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build Docker') {
      steps {
        script {
          def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          dockerImage = docker.build("${IMAGE}:${tag}")
        }
      }
    }
    stage('Push Docker') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDS) {
            dockerImage.push()
            dockerImage.push("latest")
          }
        }
      }
    }
  }
  post {
    success {
      emailext (
        subject: "SUCCESS: Jenkins build ${env.BUILD_NUMBER}",
        body: "Docker image pushed to ${IMAGE}:latest",
        to: env.EMAIL
      )
    }
    failure {
      emailext (
        subject: "FAILURE: Jenkins build ${env.BUILD_NUMBER}",
        body: "Check logs: ${env.BUILD_URL}",
        to: env.EMAIL
      )
    }
  }
}
