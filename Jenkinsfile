pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "390403874276"
        AWS_DEFAULT_REGION = "us-east-1"
        IMAGE_REPO_NAME = "jenkins-docker-image-ecr-push"
        IMAGE_TAG = "latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages {
        stage('ECR Login') {
            steps {
                script {
                    // Authenticate with AWS ECR using standard login method
                    sh """
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    """
                }
            }
        }
        
        stage('Clone Repository') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    extensions: [],
                    userRemoteConfigs: [[
                        credentialsId: '58e927c8-f95a-4e09-8726-2fdbd63e6093',
                        url: 'https://github.com/awstrainersz/jenkins-docker-image-ecr-push.git'
                    ]]
                ])
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    // Build Docker image with cache optimization
                    dockerImage = docker.build("${IMAGE_REPO_NAME}:${IMAGE_TAG}", "--pull --no-cache .")
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    // Tag and push with explicit repository URI
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully! Image pushed to ECR.'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}
