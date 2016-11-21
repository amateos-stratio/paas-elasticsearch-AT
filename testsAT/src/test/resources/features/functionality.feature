@rest
Feature: ElasticSearch functionality
  Background:
    Given I want to authenticate in DCOS cluster '${DCOS_CLUSTER}' with email '${DCOS_EMAIL}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    And I obtain mesos master in cluster '${DCOS_CLUSTER}' and store it in environment variable 'mesosMaster'
    And I send requests to '!{mesosMaster}:${MESOS_API_PORT}'
    And I send a 'GET' request to '/frameworks'
    And I save element in position '0' in '$.frameworks[?(@.name == "elasticsearch")].tasks[0].statuses[0].container_status.network_infos[0].ip_addresses[0].ip_address' in environment variable 'esHost'
    And I save element in position '0' in '$.frameworks[?(@.name == "elasticsearch")].tasks[0].discovery.ports.ports[?(@.name == "TRANSPORT_PORT")].number' in environment variable 'esPort'
    And I save element in position '0' in '$.frameworks[?(@.name == "elasticsearch")].tasks[0].discovery.ports.ports[?(@.name == "CLIENT_PORT")].number' in environment variable 'esPortApi'

    Given I obtain elasticsearch cluster name in '!{esHost}:!{esPortApi}' and save it in environment variable 'esClusterName'
    When I connect to Elasticsearch cluster at host '!{esHost}' using native port '!{esPort}' using cluster name '!{esClusterName}'

  Scenario: [ES-Functional-Spec-01] - Create index
    When I create an elasticsearch index named '${ELASTIC_INDEX}1' removing existing index if exist
    Then An Elasticsearch index named '${ELASTIC_INDEX}1' exists

  Scenario: [ES-Functional-Spec-02] & [ES-Functional-Spec-03] - Index a document & Perform a text query
    When I create an elasticsearch index named '${ELASTIC_INDEX}2' removing existing index if exist
    And I index a document in the index named '${ELASTIC_INDEX}2' using the mapping named '${ELASTIC_MAPPING}1' with key 'name' and value 'test'
    When I wait '3' seconds
    Then The Elasticsearch index named '${ELASTIC_INDEX}2' and mapping '${ELASTIC_MAPPING}1' contains a column named 'name' with the value 'test'

  Scenario: [ES-Functional-Spec-05] - Delete index
    When I create an elasticsearch index named '${ELASTIC_INDEX}3' removing existing index if exist
    And I drop an elasticsearch index named '${ELASTIC_INDEX}3'
    Then An Elasticsearch index named '${ELASTIC_INDEX}3' does not exist