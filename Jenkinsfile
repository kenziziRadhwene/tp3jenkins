pipeline {
    agent any
    tools {
        maven 'maven'
    }

    stages {
        stage('Clean') {
            steps {
                sh 'docker-compose down --remove-orphans || true'
                deleteDir()
            }
        }

        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/MaBouz/tp3jenkins.git'
            }
        }

        stage('Build') {
            steps {
                dir('tp3jenkins') {
                    sh 'mvn clean package -DskipTests'
                    sh 'docker build --no-cache -t tp3jenkins .'
                }
            }
        }

        stage('Deploy') {
            steps {
                dir('tp3jenkins') {
                    sh '''
                    # Solution spéciale pour v1.29.2
                    docker-compose down || true
                    docker rmi $$(docker images -q tp3jenkins) || true
                    docker-compose up -d --force-recreate --build
                    '''
                }
            }
        }
    }

    post {
        always {
            dir('tp3jenkins') {
                sh 'docker-compose logs --tail=50'
            }
        }
    }
}
