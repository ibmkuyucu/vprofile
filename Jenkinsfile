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
        NEXUS_PASS = "admin123"
        NEXUSIP = "nexus.kuyucu.online"
        NEXUSPORT = "443"
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
                sh 'mvn -DskipTests install'
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
                sh "mvn test"
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh "mvn checkstyle:checkstyle"
            }
        }
        stage('Sonar Analysis') {
            environment {
                scannerHome = tool "${SONARSCANNER}"
            }
            steps {
                withSonarQubeEnv("${SONARSERVER}") {
                    sh '''${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=vprofile33 \
                    -Dsonar.organization=hprofile33 \
                    -Dsonar.projectVersion=1.0 \
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
                    protocol: 'https',
                    nexusUrl: "${NEXUSIP},
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