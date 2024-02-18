def slack_colors = [
    "SUCCESS": "good",
    "FAILURE": "danger",
]
pipeline {
    agent any
    tools {
        maven "Maven3"
        jdk "OpenJDK11"
    }

    environment {
        registry = "localhost:5000"
        repository = "vproappdock"
        registryCredential = 'ocidockerhub'
        SONARSERVER = "SonarCloud"
        SONARSCANNER = "sonarscanner4"
    }

    stages {
        // stage('Fetch Code') {
        //     steps {
        //         cleanWs()
        //         git branch: 'main', url: "https://github.com/ibmkuyucu/vprofile.git"
        //     }
        // }
        // stage('Build') {
        //     steps {
        //         sh 'mvn install -DskipTests'
        //     }
        //     post {
        //         success {
        //             echo "Now Archiving."
        //             archiveArtifacts artifacts: "**/*.war"
        //         }
        //     }
        // }
        // stage('Unit Test') {
        //     steps {
        //         sh "mvn test"
        //     }
        // }
        // stage('Integration Test') {
        //     steps {
        //         sh "mvn verify -DskipUnitTests"
        //     }
        // }
        // stage('Checkstyle Analysis') {
        //     steps {
        //         sh "mvn checkstyle:checkstyle"
        //     }
        // }
        // stage('Sonar Analysis') {
        //     tools {
        //         jdk "OpenJDK17"
        //     }
        //     environment {
        //         scannerHome = tool "${SONARSCANNER}"
        //     }
        //     steps {
        //         withSonarQubeEnv("${SONARSERVER}") {
        //             sh '''${scannerHome}/bin/sonar-scanner \
        //             -Dsonar.projectKey=deneme33 \
        //             -Dsonar.organization=hprofile33 \
        //             -Dsonar.projectVersion=1 \
        //             -Dsonar.sources=src/ \
        //             -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
        //             -Dsonar.junit.reportsPath=target/surefire-reports/ \
        //             -Dsonar.jacoco.reportsPath=target/jacoco.exec \
        //             -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
        //         }
        //     }
        // }
        // stage('Quality Gate') {
        //   steps {
        //     timeout(time: 10, unit: 'MINUTES') {
        //        waitForQualityGate abortPipeline: true
        //     }
        //   }
        // }
        stage('Fetch Dockerfile') {
            steps {
                cleanWs()
                git branch: 'ci-docker', url: "https://github.com/ibmkuyucu/vprofile.git"
            }
        }
        stage('Build Image') {
            steps {
                sh "docker build -t $registry/$repository:$BUILD_NUMBER -t $registry/$repository:latest ."
            }
        }
        stage('Deploy Image') {
            steps {
                sh "docker push --all-tags $registry/$repository:$BUILD_NUMBER"
            }
        }
        stage('Remove Unused Image') {
            steps {
                sh "docker rmi -f $registry/$repository:$BUILD_NUMBER"
            }
        }
    }

    // post {
    //     always {
    //         echo "Slack Notifications."
    //         slackSend channel: "#jenkins",
    //         color: slack_colors[currentBuild.currentResult],
    //         message: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n For more info visit: ${env.BUILD_URL}"
    //     }
    // }
}