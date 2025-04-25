pipeline {
    agent any
    tools {
        maven 'M3'
        jdk 'jdk17'  # Doit correspondre au Dockerfile
    }
    
    environment {
        DOCKER_IMAGE = 'docexp1-spring'
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'  # Construction sans tests pour la démo
                stash includes: 'target/*.jar', name: 'app-jar'  # Conservation du JAR
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
                    // Arrêt propre des conteneurs existants
                    sh 'docker-compose down --remove-orphans || true'
                    
                    // Démarrage avec build forcé et logs détaillés
                    sh 'docker-compose up -d --build'
                    
                    // Attente intelligente
                    sh '''
                    attempt=0
                    while [ $attempt -lt 10 ]; do
                        if docker-compose ps | grep spring-boot-app | grep Up; then
                            echo "Application démarrée!"
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
