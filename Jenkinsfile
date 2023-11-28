pipeline {
    agent any
    tools {
        maven "Maven3"
        jdk "JDK8"
    }

    environment {
        NEXUS_USER = "admin"
        NEXUS_PASS = "admin123"
        NEXUSIP = "192.168.229.13"
        NEXUSPORT = "8081"
        NEXUS_LOGIN = "nexuslogin"
        RELEASE_REPO = "vprofile-release"
        SNAP_REPO = "vprofile-snapshot"
        CENTRAL_REPO = "vpro-maven-central"
        NEXUS_GRP_REPO = "vpro-maven-group"
        SONARSERVER = "sonarserver"
        SONARSCANNER = "sonarscanner"
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
                    -Dsonar.projectKey=vprofile \
                    -Dsonar.projectName=vprofile \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }
            }
        }
    }
}