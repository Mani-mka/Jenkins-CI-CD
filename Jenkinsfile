// running a pipeline script
pipeline {
    // run on any available agent
    agent any

    stages {
            // git checkout stage
            stage('Checkout') {
                steps {
                    git 'https://github.com/Mani-mka/Jenkins-CI-CD.git'
                }
            }
            // Maven build stage with clean and package goals
            stage('Build') {
                steps {

                    // Run Maven on a Unix agent.
                    sh "mvn -Dmaven.test.failure.ignore=true clean package"

                    // To run Maven on a Windows agent, use
                    // bat "mvn -Dmaven.test.failure.ignore=true clean package"
            }
            
        }   // copy .war file and Dockerfile onto ansible server
            stage('Copy .war file and Dockerfile') {
                steps {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible-controller', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'playbooks', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/target/*.war, **/Dockerfile')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                }
            }
            // build docker image from the copied Dockerfile and push it to dockerhub
            stage('Build Docker image and push') {
                steps {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible-controller', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 
                                         '''cd playbooks;
                                            sudo docker build -t ci-cd-app:$BUILD_ID .;
                                            sudo docker tag ci-cd-app:$BUILD_ID manidockermka/ci-cd-app:$BUILD_ID;
                                            sudo docker tag ci-cd-app:$BUILD_ID manidockermka/ci-cd-app:latest;
                                            sudo docker push manidockermka/ci-cd-app:$BUILD_ID;
                                            sudo docker push manidockermka/ci-cd-app:latest;
                                            sudo docker rmi ci-cd-app:$BUILD_ID manidockermka/ci-cd-app:$BUILD_ID manidockermka/ci-cd-app:latest''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
                }
            }
            // running a playbook that creates a container of our application by pulling the image that we built and pushed to dockerhub
            stage('Run playbook to create a container') {
                steps {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'Ansible-controller', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 
                                         '''cd playbooks;
                                            ansible-playbook create_container.yaml''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])

            }
        }
    }
}
