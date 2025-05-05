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
        stage('Cloning Git') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],  // Changed from master to main (GitHub default)
                    extensions: [], 
                    userRemoteConfigs: [[
                        credentialsId: 'gittoken', 
                        url: 'https://github.com/awstrainersz/jenkins-docker-image-ecr-push.git'
                    ]]
                ])     
            }
        }

        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                        docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}", "."
                }
            }
        }

        stage('Pushing to ECR') {
            steps {
                script {
                    dockerImage.push("${IMAGE_TAG}")
                }
            }
        }
    }
}
