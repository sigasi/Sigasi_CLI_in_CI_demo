#!groovy

String sigasiCli = '/home/wmeeus/product/sigasi-cli/sigasi-cli'

pipeline {
    agent 'any'

    stages {
        stage('Build') {
            steps {
                // Verify project
                sh "${sigasiCli} verify --warnings-ng -o sigasi-verify.xml ."
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