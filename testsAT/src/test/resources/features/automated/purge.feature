Feature: Purge process after testing a framework

  Background: Connection to CLI
    Given I open remote ssh connection to host '${DCOS_CLI_HOST}' with user '${DCOS_USER}' and password '${DCOS_PASSWORD}'

  @include(feature:installation.feature,scenario:InstallUninstall-Spec-02. A service CAN be uninstalled from the CLI)
  Scenario: Uninstall framework after testing
    Given I wait '1' seconds
    When I wait '1' seconds
    Then I wait '1' seconds