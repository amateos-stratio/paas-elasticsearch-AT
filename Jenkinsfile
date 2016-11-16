@Library('libpipelines@feature/multibranch') _

hose {
    EMAIL = 'qa'
    SLACKTEAM = 'stratioqa'
    MODULE = 'paasesAT'
    
    ATTIMEOUT = 30
    
    ATSERVICES = [
            ['DCOSCLI':   ['image': 'stratio/dcos-cli:0.4.11',
                           'env':    ['DCOS_URL=http://10.200.1.11',
                                      'SSH=true',
                                      'TOKEN_AUTHENTICATION=true',
                                      'DCOS_USER=admin@demo.stratio.com',
                                      'DCOS_PASSWORD=stratiotest',
                                      'REMOTE_USER=root',
                                      'REMOTE_PASSWORD=stratio',
                                      'MASTER_MESOS=10.200.1.11',],
                           'sleep':  10]]
        ]

    ATPARAMETERS = """
                    | -DDCOS_CLI_HOST=%%DCOSCLI#0
                    | -DSERVICE=elasticsearch
                    | -DDCOS_CLUSTER=10.200.1.11
                    | -DDCOS_USER=root
                    | -DDCOS_PASSWORD=stratio
                    | -DDCOS_PEM=none
                    | -DDCOS_EMAIL=admin@demo.stratio.com
                    | -DDCOS_CLUSTER_PORT=80
                    | -DMESOS_API_PORT=5050
                    | -DEXHIBITOR_API_PORT=8181
                    | -DDCOS_ZK_PORT=2181
                    | -DELASTIC_INDEX=stratio
                    | -DELASTIC_MAPPING=mola
                    | """.stripMargin().stripIndent()


    AT = { conf ->
        doAT(conf)                
    }
}
