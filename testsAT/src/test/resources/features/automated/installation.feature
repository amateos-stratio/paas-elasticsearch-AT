@rest
Feature: Installing / uninstalling testing with ${SERVICE}

  Background: Setup PaaS REST client
  Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}'

  Scenario: InstallUninstall-Spec-01. A service CAN be installed from the CLI
    When I execute command 'dcos package install ${SERVICE} --yes' in remote ssh connection
    Then in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep ${SERVICE} | grep R | wc -l' contains '1'
    Then in less than '500' seconds, checking each '20' seconds, the command output 'dcos task | grep ${SERVICE}-executor | grep R | wc -l' contains '3'

  Scenario: InstallUninstall-Spec-02. A service CAN be uninstalled from the CLI
    Given I execute command 'dcos package uninstall ${SERVICE}' in remote ssh connection
    Then in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep ${SERVICE} | wc -l' contains '0'

    And I open remote ssh connection to host '${DCOS_CLUSTER}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}' using pem file '${DCOS_PEM}'
    When I execute command 'docker run mesosphere/janitor /janitor.py -r ${SERVICE}-role -p ${SERVICE}-principal -z ${SERVICE}' in remote ssh connection
    Then the command output contains 'Cleanup completed successfully.'
