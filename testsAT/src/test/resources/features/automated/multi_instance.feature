@rest
@ignore @unimplemented
Feature: Multi-instance testing

  Background: Setup PaaS REST client
    Given I obtain mesos master in cluster '${DCOS_CLUSTER}' and store it in environment variable 'mesosMaster'


  Scenario: MultiInstance-Spec-01 - Scheduler MUST support a custom FrameworkInfo.name.
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}'
    When I execute command 'dcos package install ${SERVICE} --yes --app-id=${SERVICE}2' in remote ssh connection
    Then in less than '120' seconds, checking each '20' seconds, the command output 'dcos marathon task list' contains '/${SERVICE}2'

    #Checking service is fully up & running
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'
    Then in less than '120' seconds, checking each '20' seconds, I send a 'GET' request to '/mesos_dns/v1/services/_${SERVICE}2._tcp.marathon.mesos' so that the response contains '"service": "_${SERVICE}2._tcp.marathon.mesos"'

    #Checking Mesos framework info
    Given I send requests to '!{mesosMaster}:${MESOS_API_PORT}'
    And I send a 'GET' request to '/frameworks'
    Then the service response status must be '200'.
    And I save element in position '0' in '$.frameworks[?(@.name == "marathon")].tasks[?(@.name == "${SERVICE}")].name' in environment variable 'name1'
    And I save element in position '0' in '$.frameworks[?(@.name == "marathon")].tasks[?(@.name == "${SERVICE}2")].name' in environment variable 'name2'

    #Unisntalling service second instance
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}'
    When I execute command 'dcos package uninstall ${SERVICE} --app-id=${SERVICE}2' in remote ssh connection
    And I execute command 'dcos marathon task list' in remote ssh connection
    Then the command output does not contain '${SERVICE}2'

    #Checking service first instance is fully up & running
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'
    Then in less than '120' seconds, checking each '20' seconds, I send a 'GET' request to '/mesos_dns/v1/services/_${SERVICE}._tcp.marathon.mesos' so that the response contains '"service": "_${SERVICE}._tcp.marathon.mesos"'

    Given I open remote ssh connection to host '${DCOS_CLUSTER}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    When I execute command 'docker run mesosphere/janitor /janitor.py -r ${SERVICE}2-role -p ${SERVICE}2-principal -z ${SERVICE}2' in remote ssh connection
    Then the command output contains 'Cleanup completed successfully.'

#  Scenario: MultiInstance-Spec-01 - Scheduler MUST support a custom FrameworkInfo.role.
#    Given a running service
#    When we start a second instance of the same service with different role
#    Then each instance will have its own resources

#    Given a running service
#    When we start a second instance of the same service
#    Then resource allocation can be different among services

#    Given a running service
#    When we start a second instance of the same service with the same role
#    Then both instances can share certain resources

#    Given two running services sharing resources
#    When one of them is killed
#    Then remaining service can still access the shared resources created by the killed one
#
#  Scenario: MultiInstance-Spec-01 - Executors of the same Service type MUST safely co-exist on a given node._ (note that this is not only related to multi-instance)
#    Given a service in our universe
#    When the service is launched twice (possibly with different configuration)
#    Then two independent instances of the service should run in the same node simultaneously without conflict.
