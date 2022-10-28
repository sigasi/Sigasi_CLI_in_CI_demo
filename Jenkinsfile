#!groovy

String sigasiCli = '/home/wmeeus/product/veresta-current/veresta'

pipeline {
    agent 'any'

    environment {
        SIGASI_LM_LICENSE_FILE = '27040@elvis'
    }

    stages {
        stage('Build') {
            steps {
                // Verify project
                sh "${sigasiCli} verify --warnings-ng -o sigasi-verify.xml ."
                // Have the job fail if errors are found
                sh "if grep '<severity>ERROR</severity>' sigasi-verify.xml ; then exit 1; fi"
            }
        }
        
    }

    post {
        always {
            archiveArtifacts artifacts: 'sigasi-verify.xml'
            recordIssues(
                enabledForFailure: true,
                aggregatingResults: true,
                tool: issues(pattern: 'sigasi-verify.xml', analysisModelId: 'sigasi')
            )
        }
    }
}
