pipeline{
    agent any
    environment {
        IMG_TAG="V-${BUILD_NUMBER}"
        IMAGE="web-app-berlin:${IMG_TAG}"
    }
    stages{
        stage("build"){
           
            steps{
                dir("./argo/my-argo-webapp"){
                    sh "docker build -t naman01\\/${IMAGE} ."
                }
            }    
        }
        stage("push image to dockerhub"){

             environment{
                DOCKER_CRED=credentials('docker')
            }
            steps{
               
                   sh "echo $DOCKER_CRED_PSW | docker login --username $DOCKER_CRED_USR --password-stdin  && docker push naman01/web-app-berlin:${IMG_TAG}"
                
            }
        }
        stage("Update Git Manifest"){
            steps{
                dir("./argo/my-argo-webapp/manifest"){
                    sh "sed -i 's/image\\:.*/image\\: naman01\\/$IMAGE/g' app-server.yaml"
                }
                sh "git add ."
                sh "git commit -m 'Update image tag to ${IMG_TAG}'"

                script{
                    if (env.BRANCH_NAME == 'main') {
                       sh "git push origin main"
                    } else {
                        sh "git push origin feature "
                    }
                }

            }
        }
        stage("Sync ArgoCD"){
            steps{
                echo "hello argo"
            }
        }

    }
}