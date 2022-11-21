pipeline {
    environment {
        ProjectDir = '/var/lib/jenkins/workspace/proj@2'
        registry = 'elhananw/final_project'
        GitCredentials = 'aebc3017-b153-49e8-92b7-bf84dba51b27'
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Build') {
            steps {
                echo "=======  building in Jenkins  ======="
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: GitCredentials, url: 'https://github.com/ElhananW/jenk']]])
                script {
                    dockerImage = docker.build registry + "latest"
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) { dockerImage.push() }
                }
            }
        }
        stage('Test'){
            steps {
                echo '=======  Deploying to test  ======='
                 sh "[ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh "
                 sh "ssh-keyscan -t rsa test >> ~/.ssh/known_hosts"
                sshagent(['ssh-key']) {
                    sh 'chmod u+x $ProjectDir/deploy.sh'
                    sh 'echo im here'
                    sh 'bash ./deploy.sh test'                   
                }
            }
        }
        stage('Deploy'){
            steps {
                echo '=======  Deploying to prod  ======='
                 sh "[ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh "
                 sh "ssh-keyscan -t rsa prod >> ~/.ssh/known_hosts"
                sshagent(['ssh-key']) {
                   sh 'sudo chmod -R 755 ./deploy.sh'
                   sh 'bash ./deploy.sh prod'
                }
            }
        }
        
    }
}
