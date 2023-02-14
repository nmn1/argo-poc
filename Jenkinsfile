pipeline{
    agent any
    environment {
        IMG_TAG="V-${BUILD_NUMBER}"
    }
    stages{
        stage("build"){
           
            steps{
                dir("./argo/my-argo-webapp"){
                    sh "docker build -t naman01/web-app-berlin:${IMG_TAG} ."
                }
            }    
        }
        stage("push image to dockerhub"){

             environment{
                DOCKER_CRED=credentials('docker')
            }
            steps{
               
                   sh "docker login --username $DOCKER_CRED_USR --password $DOCKER_CRED_PSW && docker push naman01/web-app-berlin:${IMG_TAG}"
                
            }
        }
    }
}