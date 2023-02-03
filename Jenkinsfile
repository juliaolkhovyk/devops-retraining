def POSTGRES_DB
def POSTGRES_USER
def POSTGRES_PASSWORD
def POSTGRES_HOST
def REDIS_HOST

pipeline  {
    agent any
    environment {
        dockerHubCredentials = 'docker-hub-credentials'
        dockerHubUsername = "juliaolkhovyk"
        dockerImageTag = "latest"
        imageName = "$dockerHubUsername/misago:$dockerImageTag"
        name = "demo"
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
        
        stage('Terraform Plan') {
                steps {
                    dir('terraform') {
                        withAWS(credentials: 'aws_credentials') {
                            sh 'terraform validate'
                        }
                    }
                }
            }

        stage('User Approval For Provisioning Infrastructure') {
            steps {
                echo "Proceed applying terraform options?:"
                input(message: 'Proceed applying terraform options?', ok: 'Yes', 
                parameters: [booleanParam(defaultValue: true, 
                description: 'This will apply changes in terraform',name: 'Yes?')])
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws_credentials') {
                        sh "terraform apply -input=false  -auto-approve"
                    }
                }
            }
        }
        
        stage('Update kubeconfig') {
            steps {
                withAWS(credentials: 'aws_credentials') {
                    sh "aws eks update-kubeconfig --name $name --region eu-central-1"
                }
            }
        }
        
        stage('Export env variables for RDS and Redis') {
            steps {
                dir('terraform') {
                    withAWS(credentials: 'aws_credentials') {
                        script {
                            sh "export AWS_DEFAULT_OUTPUT=text"
                            POSTGRES_DB = returnEnvForRDS("POSTGRES_DB")
                            POSTGRES_HOST = returnEnvForRDS("POSTGRES_HOST")
                            POSTGRES_USERE = returnEnvForRDS("POSTGRES_USER")
                            POSTGRES_PASSWORD = returnEnvForRDS("POSTGRES_PASSWORD")
                            REDIS_HOST = returnEnvForRDS("REDIS_HOST")
                            sh "echo ${POSTGRES_PASSWORD}"
                            sh "echo ${POSTGRES_HOST}"
                            sh "echo ${POSTGRES_USER}"
                            sh "echo ${POSTGRES_DB}"
                            sh "echo ${REDIS_HOST}"
                        }
                    }
                }
            }
        }
        
        stage('Deploy project through helm') {
            steps {
                dir('helm') {
                    withAWS(credentials: 'aws_credentials') {
                        script {
                            sh (
                                script: """helm install demo-chart ./demo \
                                --set POSTGRES_USER=$POSTGRES_USER --set POSTGRES_DB=$POSTGRES_DB \
                                --set POSTGRES_HOST=$POSTGRES_HOST --set POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
                                --set REDIS_HOST=$REDIS_HOST
                                """
                            )
                        }
                    }
                }
            }
        }
    }
}

def returnEnvForRDS(parameter) {
    return sh(script: """echo \$(terraform output --raw ${parameter}) | tr -d '"'""", returnStdout: true).trim()
}
