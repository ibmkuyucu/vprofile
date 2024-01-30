def slack_colors = [
    "SUCCESS": "good",
    "FAILURE": "danger",
]
pipeline {
    agent any
    tools {
        maven "Maven3"
        jdk "OpenJDK17"
    }

    environment {
        NEXUS_USER = "admin"
        NEXUS_PASS = "0f51c7a8-641e-4ed7-ae1b-5791a33c80b9"
        NEXUSIP = "127.0.0.1"
        NEXUSPORT = "8081"
        NEXUS_LOGIN = "nexuslogin"
        RELEASE_REPO = "vprofile-release"
        SNAP_REPO = "vprofile-snapshot"
        CENTRAL_REPO = "vpro-maven-central"
        NEXUS_GRP_REPO = "vpro-maven-group"
        SONARSERVER = "SonarCloud"
        SONARSCANNER = "sonarscanner4"
    }

    stages {
        stage('Fetch') {
            steps {
                git branch: 'main', url: "https://github.com/ibmkuyucu/vprofile.git"
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: "**/*.war"
                }
            }
        }
        stage('Test') {
            steps {
                sh "mvn -s settings.xml test"
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh "mvn -s settings.xml checkstyle:checkstyle"
            }
        }
        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=deneme33 \
                    -Dsonar.organization=hprofile33 \
                    -Dsonar.projectVersion=1 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }
        // stage('Quality Gate') {
        //   steps {
        //     timeout(time: 10, unit: 'MINUTES') {
        //        waitForQualityGate abortPipeline: true
        //     }
        //   }
        // }
        stage("Upload Artifact") {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                    groupId: "QA",
                    version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                    repository: "${RELEASE_REPO}",
                    credentialsId: "${NEXUS_LOGIN}",
                    artifacts: [
                        [artifactId: "vproapp",
                        classifier: '',
                        file: 'target/vprofile-v2.war',
                        type: 'war']
                    ]
                )
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