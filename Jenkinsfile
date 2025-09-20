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
                checkout scm
                echo "✅ Code checked out successfully"
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                    if command -v python3 &> /dev/null; then
                        echo "🐍 Using Python3"
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r app/requirements.txt
                    elif command -v python &> /dev/null; then
                        echo "🐍 Using Python"
                        python -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r app/requirements.txt
                    else
                        echo "❌ Python not installed on Jenkins agent"
                        exit 1
                    fi
                '''
                echo "✅ Dependencies installed in venv"
            }
        }
        
        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pip install pytest
                    pytest tests/ -v
                '''
                echo "✅ Tests passed"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def imageName = "${DOCKER_IMAGE}:${tag}"
                    
                    echo "🐳 Building Docker image: ${imageName}"
                    
                    sh """
                        docker build -t ${imageName} .
                        docker tag ${imageName} ${DOCKER_IMAGE}:latest
                    """
                    
                    env.DOCKER_TAG = tag
                    echo "✅ Docker image built successfully"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDS}", usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
                        sh """
                            echo ${DOCKERHUB_TOKEN} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                            docker push ${DOCKER_IMAGE}:${env.DOCKER_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                        """
                        echo "✅ Docker image pushed to Docker Hub"
                    }
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    sh """
                        # Clean up any existing test containers
                        docker rm -f test-container || true
                        
                        # Run the container WITHOUT host port mapping (no -p)
                        docker run -d --name test-container ${DOCKER_IMAGE}:latest
                        
                        # Wait for container to start
                        sleep 15
                        
                        echo "🔍 Running API health check..."
                        docker exec test-container curl -f http://localhost:5000/ || exit 1
                        
                        echo "🔍 Running prediction test..."
                        docker exec test-container curl -s -X POST http://localhost:5000/predict \
                            -H "Content-Type: application/json" \
                            -d '{
                                "age": 50,
                                "sex": 1,
                                "cp": 2,
                                "trestbps": 130,
                                "chol": 250,
                                "fbs": 0,
                                "restecg": 1,
                                "thalach": 160,
                                "exang": 0,
                                "oldpeak": 1.0,
                                "slope": 2,
                                "ca": 0,
                                "thal": 2
                            }' || exit 1
                        
                        # Clean up
                        docker stop test-container
                        docker rm test-container
                    """
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
                
                ✅ All stages completed successfully!
                """,
                to: "${env.EMAIL}"
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
                🔗 Build URL: ${env.BUILD_URL}
                👤 Triggered by: ${env.CHANGE_AUTHOR}
                ⏰ Timestamp: ${new Date()}
                
                Please check the build logs for more details.
                """,
                to: "${env.EMAIL}"
            )
            echo "❌ Failure notification sent"
        }
        always {
            sh '''
                docker rm -f test-container || true
                docker system prune -f || true
            '''
            cleanWs()
            echo "🧹 Workspace cleaned"
        }
    }
}
