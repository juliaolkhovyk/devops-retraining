def POSTGRES_DB
def POSTGRES_USER
def POSTGRES_PASSWORD
def POSTGRES_HOST
def REDIS_HOST

pipeline  {
    tools {
        terraform 'terraform'
    }

    environment {
        dockerHubCredentials = 'docker-hub-credentials'
        dockerHubUsername = "juliaolkhovyk"
        dockerImageTag = "latest"
        imageName = "$dockerHubUsername/misago:$dockerImageTag"
    }

    stages {
        stage('Clone git repository') {
            steps {
                git url: 'https://github.com/juliaolkhovyk/devops-retraining.git', branch: 'main'
            }
        }

        stage('Build a docker image') {
            steps {
                dir('Misago') {
                    script {
                        dockerImage = docker.build(imageName, '.')
                    }
                }

            }
        }

        stage('Push the image to Docker Hub registry') {
            steps {
                script {
                    docker.withRegistry('', dockerHubCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws_credentials') {
                        sh 'terraform init'
                    }
                }
            }
        }
    }
}