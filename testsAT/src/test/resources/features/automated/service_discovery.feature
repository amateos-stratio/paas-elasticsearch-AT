@rest
Feature: Service discovery testing

  Background: Mesos-DNS must know the service info
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}'

  Scenario: ServiceDiscovery-Spec-01 - Mesos-DNS MUST create the service
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'
    Then in less than '120' seconds, checking each '20' seconds, I send a 'GET' request to '/mesos_dns/v1/services/_${SERVICE}._tcp.marathon.mesos' so that the response contains '"service": "_${SERVICE}._tcp.marathon.mesos"'

  Scenario: ServiceDiscovery-Spec-01.01 - Mesos-DNS MUST register the service executor
    Then in less than '120' seconds, checking each '20' seconds, the command output 'dcos task' contains 'elasticsearch-executor'
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'
    Then in less than '120' seconds, checking each '20' seconds, I send a 'GET' request to '/mesos_dns/v1/services/_elasticsearch-executor._tcp.elasticsearch.mesos' so that the response contains '"service": "_elasticsearch-executor._tcp.elasticsearch.mesos"'

  Scenario: ServiceDiscovery-Spec-02 - A Service with DCOS CLI MUST be driven by HTTP APIs.
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I send requests to '${DCOS_CLUSTER}:${DCOS_CLUSTER_PORT}'
    Then in less than '30' seconds, checking each '5' seconds, I send a 'GET' request to '/service/${SERVICE}/' so that the response contains 'Elasticsearch Mesos Framework'
