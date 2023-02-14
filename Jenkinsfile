pipeline{
    agent any
    environment {
        IMG_TAG="${BUILD_NUMBER}"
        DOCKER_REPO=''
    }
    stages{
        stage(build){
            steps{
                dir('/argo/my-argo-webapp'){
                    sh "ls"
                    echo '${IMG_TAG}'
                }
            }
        }
    }
}