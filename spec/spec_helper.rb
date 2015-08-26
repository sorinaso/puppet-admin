require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'puppet_acceptance_environment'
require 'puppet_acceptance_spec_helper/shared_examples'

PuppetAcceptanceEnvironment.start do

end

module SpecHelper
  module Mail
    module GmailSendOnly
      module Params
        def self.send_mail_cmd; "echo 'test mail' | sendmail #{self.admin_address}" end

        def self.clean_cmd; "echo '' > #{self.mail_log_file} && apt-get -y purge nullmailer" end

        def self.mail_log_file; "/var/log/mail.log" end

        def self.admin_address; 'alesouto.tests@gmail.com' end

        def self.gmail_user; 'alesouto.tests' end

        def self.gmail_password; 'tests123' end

        def self.nullmailer_application
          { :package => 'nullmailer', :service => 'nullmailer' }
        end
      end

      module Manifest
        def self.pp
          <<-EOS
            class {'apt': }

            package { ['python-software-properties', 'software-properties-common']: } ->

            class {'admin::mail::gmail_send_only':
              admin_address   => '#{::Params.admin_address}',
              gmail_user      => '#{::Params.gmail_user}',
              gmail_password  => '#{::Params.gmail_password}',
            }
          EOS
        end
      end
    end
  end

  module Monitoring
    module Zabbix
      module Params
        def self.zabbix_server_application
          { :package => 'zabbix-server-mysql', :service => 'zabbix-server', :port => 10051 }
        end

        def self.zabbix_agent_application
          { :package => 'zabbix-agent', :service => 'zabbix-agent', :port => 10050 }
        end

        def self.apache_application
          { :package => 'apache2', :service => 'apache2', :port => 80 }
        end

        def self.mysql_default_params
          { :database => "zabbix_server", :user => "zabbix_server", :password => "zabbix_server" }
        end

        def self.zabbix_frontend_hostname; 'zabbix.example.com' end

        def self.database_type; 'mysql' end

        def self.database_test_user; 'zabbix_test_user' end

        def self.database_test_password; 'zabbix_test_password' end

        def self.clean_cmd
          <<-EOS
          apt-get -y -q remove zabbix-agent zabbix-frontend-php --purge &&
          rm -rf /etc/zabbix/.*.done &&
          rm -rf /etc/apache2/sites-available/*#{zabbix_frontend_hostname}* &&
          rm -rf /etc/apache2/sites-enabled/*#{zabbix_frontend_hostname}* &&
          (echo "drop database zabbix_server" | mysql -u root) || echo "no existe la base de datos"
          EOS
        end
      end

      module Manifest
        def self.server_pp(database_user: nil, database_password: nil)
          extra_params = ''
          extra_params += "database_user => '#{database_user}',\n" unless database_user.nil?
          extra_params += "database_password => '#{database_password}',\n" unless database_password.nil?

          <<-EOS
            class { 'apt': }

            class { 'mysql::server': }

            class { 'apache':
              mpm_module => 'prefork',
            }

            class { 'apache::mod::php': } ->

            class {'admin::monitoring::zabbix::server':
              zabbix_url        => '#{::Params.zabbix_frontend_hostname}',
              database_type     => '#{::Params.database_type}',#{extra_params}
            }
          EOS
        end

        def self.agent_pp
          <<-EOS
            class { 'apt': }

            class {'admin::monitoring::zabbix::agent':
              server_ip => '127.0.0.1',
            }
          EOS
        end
      end
    end
  end
end
