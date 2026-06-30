pipeline {
    agent any

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