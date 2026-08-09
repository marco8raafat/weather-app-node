#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@main', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'https://github.com/MennaHamouda/jenkins-shares-library',
     credentialsId: 'gitHub'])
pipeline {

    agent any

    stages {

        stage("Build") {
            steps {
                buildNode()
            }
        }

        stage("Test") {
            steps {
                test()
            }
        }

        stage("Docker Build") {
            steps {
                dockerBuild()
            }
        }

        stage("Docker Push") {
            steps {
                dockerPush()
            }
        }

        stage("Terraform Deploy") {
            steps {
                terraformDeploy()
            }
        }

        stage("Configure EC2") {
            steps {
                ansibleConfigure()
            }
        }
    }

}