require 'colorize'
require 'puppet_acceptance_spec_helper/rake_task'

PuppetAceptanceTasks.new do |t|
  t.specs_and_contexts = {
      'spec/acceptance/monitoring/zabbix/server_spec.rb' => [
          "without parameters",
          "{ database_user => 'zabbix_test_user' }",
          "{ database_user => 'zabbix_test_user', database_password => 'zabbix_test_password' }"
      ],
      'spec/acceptance/monitoring/zabbix/agent_spec.rb' => [
          "without parameters",
      ],
      'spec/acceptance/mail/gmail_send_only_spec.rb' => [
          "without parameters",
      ]
  }
end