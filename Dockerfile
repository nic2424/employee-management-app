FROM eclipse-temurin:17-jre

WORKDIR /app

COPY build/libs/employee-management-app-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]

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

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t employee-management-app:v1 .'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker rm -f employee-app || true
                docker run -d --name employee-app -p 8083:8080 employee-management-app:v1
                '''
            }
        }

    }
}