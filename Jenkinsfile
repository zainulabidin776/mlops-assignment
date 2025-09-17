pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "itsmezayynn/heart-disease-api"
        DOCKERHUB_CREDS = "dockerhub-credentials"
        EMAIL = "itsmezayynn@gmail.com"
    }
    
    stages {
        stage('Checkout') {
             steps {
        git branch: 'main',
            url: 'https://github.com/zainulabidin776/mlops-assignment.git'
    }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'python -m pip install --upgrade pip'
                sh 'pip install -r app/requirements.txt'
                echo "✅ Dependencies installed"
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'pip install pytest'
                sh 'pytest tests/ -v'
                echo "✅ Tests passed"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def imageName = "${DOCKER_IMAGE}:${tag}"
                    def latestImage = "${DOCKER_IMAGE}:latest"
                    
                    echo "Building Docker image: ${imageName}"
                    dockerImage = docker.build(imageName)
                    echo "✅ Docker image built successfully"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDS}", usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
                        sh "echo ${DOCKERHUB_TOKEN} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                        dockerImage.push()
                        dockerImage.push("latest")
                        echo "✅ Docker image pushed to Docker Hub"
                    }
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    sh "docker run -d -p 5000:5000 --name test-container ${DOCKER_IMAGE}:latest"
                    sleep(10)
                    sh "curl -f http://localhost:5000/ || exit 1"
                    sh "docker stop test-container && docker rm test-container"
                    echo "✅ Docker image test passed"
                }
            }
        }
    }
    
    post {
        success {
            emailext (
                subject: "✅ SUCCESS: MLOps Pipeline - Build ${env.BUILD_NUMBER}",
                body: """
                🎉 MLOps Pipeline Execution Successful!
                
                📊 Project: Heart Disease Prediction API
                🚀 Build Number: ${env.BUILD_NUMBER}
                📦 Docker Image: ${DOCKER_IMAGE}:latest
                🔗 Repository: ${env.JOB_URL}
                👤 Triggered by: ${env.CHANGE_AUTHOR}
                ⏰ Timestamp: ${new Date()}
                
                ✅ All stages completed successfully:
                - Code checkout ✅
                - Dependencies installation ✅
                - Unit tests ✅
                - Docker build ✅
                - Docker Hub push ✅
                - Docker image test ✅
                
                🐳 Docker image is now available on Docker Hub!
                
                Best regards,
                MLOps Pipeline Bot
                """,
                to: "${EMAIL}"
            )
            echo "✅ Success notification sent"
        }
        failure {
            emailext (
                subject: "❌ FAILURE: MLOps Pipeline - Build ${env.BUILD_NUMBER}",
                body: """
                ❌ MLOps Pipeline Execution Failed!
                
                📊 Project: Heart Disease Prediction API
                🚀 Build Number: ${env.BUILD_NUMBER}
                �� Build URL: ${env.BUILD_URL}
                👤 Triggered by: ${env.CHANGE_AUTHOR}
                ⏰ Timestamp: ${new Date()}
                
                Please check the build logs for more details.
                
                Best regards,
                MLOps Pipeline Bot
                """,
                to: "${EMAIL}"
            )
            echo "❌ Failure notification sent"
        }
        always {
            cleanWs()
            echo "🧹 Workspace cleaned"
        }
    }
}






/*
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

*/

