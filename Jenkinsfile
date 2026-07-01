pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'SonarQube'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x gradlew'
                sh './gradlew clean build'
            }
        }

        stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('Sonar_Qube') {
            sh '''
            echo "Host: $SONAR_HOST_URL"
            echo "Token length: ${#SONAR_AUTH_TOKEN}"
            env | grep SONAR
            ./gradlew sonar --info
            '''
        }
    }
}
        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t employee-management-app:v1 .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f employee-app || true
                docker run -d --name employee-app -p 8083:8080 employee-management-app:v1
                '''
            }
        }
    }
}
