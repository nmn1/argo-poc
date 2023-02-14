pipeline{
    agent any
    environment {
        IMG_TAG="V-${BUILD_NUMBER}"
        DOCKER_REPO=''
    }
    stages{
        stage("build"){
            steps{
                cleanWs()
                dir("./argo/my-argo-webapp"){
                    sh "docker build -t naman01/web-app-berlin:${IMG_TAG} ."
                }
            }    
        }
        stage("push image to dockerhub"){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]) {
                   sh "docker push naman01/web-app-berlin:${IMG_TAG}"
                }
            }
        }
    }
}