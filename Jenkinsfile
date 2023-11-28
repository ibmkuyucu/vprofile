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
                sh "mvn test"
            }
        }
        stage('Checkstyle Analysis') {
            steps {
                sh "mvn checkstyle:checkstyle"
            }
        }
    }
}