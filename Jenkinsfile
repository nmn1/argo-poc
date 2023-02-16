pipeline{
    agent any
    options {
        ansiColor('xterm')
    }
    environment {
        IMG_TAG="V-${BUILD_NUMBER}"
        IMAGE="web-app-berlin:${IMG_TAG}"
    }
    stages{
        stage("build"){
           echo "\033[34m Starting image build... \033[0m"
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
        // stage("Update Git Manifest"){
        //     steps{
        //         dir("./argo/my-argo-webapp/manifest"){
        //             sh "sed -i 's/image\\:.*/image\\: naman01\\/$IMAGE/g' app-server.yaml"
        //         }
        //         sh "git add ."
        //         sh "git commit -m 'Update image tag to ${IMG_TAG}'"

        //         script{
        //             if (env.BRANCH_NAME == 'main') {
        //                 withCredentials([gitUsernamePassword(credentialsId: 'github_access', gitToolName: 'git-tool')]) {
        //                   sh "git push origin main"
        //                 }
        //             } else {
        //                 withCredentials([gitUsernamePassword(credentialsId: 'github_access', gitToolName: 'git-tool')]) {
        //                   sh "git push origin feature"
        //              }
        //             }
        //         }
        //     }
        // }
        stage("Sync ArgoCD Status"){
            steps{
                script{
                //     withCredentials([usernamePassword(credentialsId: 'argo_pass', passwordVariable: 'ARGO_PASS', usernameVariable: 'ARGO_USER')]) {
                //             sh "argocd login ${params.ARGO_URL} --name ${ARGO_USER} --password ${ARGO_PASS} --insecure"
                //         }
                    if(env.BRANCH_NAME == 'main'){
                        echo "##################################################"
                        echo "# \033[33m Sync ARGO Manually For Prod \033[33m  #"
                        echo "##################################################"

                    }else {
                        echo "argo Feature"
                    }
                }
            }
        }

    }
    post{
        success{
            cleanWs()
        }
    }
}