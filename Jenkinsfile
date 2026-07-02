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
        sh '''
        docker build -t vipintomar/employee-management-app:latest .
        docker tag vipintomar/employee-management-app:latest vipintomar/employee-management-app:${BUILD_NUMBER}
        '''
    }
}

stage('Docker Login') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_USER',
            passwordVariable: 'DOCKER_PASS'
        )]) {
            sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            '''
        }
    }
}

stage('Docker Push') {
    steps {
        sh '''
        docker push vipintomar/employee-management-app:latest
        docker push vipintomar/employee-management-app:${BUILD_NUMBER}
        '''
    }
}


        stage('Deploy') {
            steps {
                sh '''
                docker rm -f employee-app || true
                docker run -d --name employee-app -p 8083:8080  vipintomar/employee-management-app:latest
                '''
            }
        }
    }
}
