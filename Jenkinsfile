pipeline {
    agent any
    tools {
        maven 'M3'
        jdk 'jdk17'
    }
    
    environment {
        DOCKER_IMAGE = 'docexp1-spring'
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
                stash includes: 'target/*.jar', name: 'app-jar'
            }
        }

        stage('Docker Build') {
            steps {
                unstash 'app-jar'
                script {
                    docker.build("${env.DOCKER_IMAGE}")
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose down --remove-orphans || true'
                    sh 'docker-compose up -d --build'
                    sh '''
                    attempt=0
                    while [ $attempt -lt 10 ]; do
                        if docker-compose ps | grep spring-boot-app | grep Up; then
                            break
                        fi
                        attempt=$((attempt+1))
                        sleep 10
                    done
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker-compose logs --no-color --tail=100 spring-boot-app'
        }
    }
}
