require 'spec_helper'

include SpecHelper::Monitoring::Zabbix

describe 'admin::monitoring::zabbix::server class:' do

  context "without parameters" do
    describe "puppet manifest" do
      it "should run without errors" do
        shell Params.clean_cmd

        apply_manifest(Manifest.server_pp, :expect_changes => true)
        apply_manifest(Manifest.server_pp)
        apply_manifest(Manifest.server_pp, :catch_changes => true)
      end
    end

    describe "zabbix server application" do
      it_should_behave_like "an application", Params.zabbix_server_application
    end

    describe "apache application" do
      it_should_behave_like "an application", Params.apache_application
    end

    describe "mysql zabbix database" do
      it_should_behave_like "an accessible database", Params.mysql_default_params
    end

    describe "zabbix frontend" do
      it_should_behave_like "a responsible url from guest", "http://#{Params.zabbix_frontend_hostname}"
    end
  end

  context "{ database_user => '#{Params.database_test_user}' }" do
    describe "puppet manifest" do
      it "should run without errors" do
        shell Params.clean_cmd

        pp = Manifest.server_pp(database_user: Params.database_test_user)

        apply_manifest(pp, :expect_changes => true)
        apply_manifest(pp)
        apply_manifest(pp, :catch_changes => true)
      end
    end

    describe "zabbix server application" do
      it_should_behave_like "an application", Params.zabbix_server_application
    end

    describe "apache application" do
      it_should_behave_like "an application", Params.apache_application
    end

    describe "mysql zabbix database" do
      mysql_database_params = Params.mysql_default_params
      mysql_database_params[:user] = Params.database_test_user
      it_should_behave_like "an accessible database", mysql_database_params
    end

    describe "zabbix frontend" do
      it_should_behave_like "a responsible url from guest", "http://#{Params.zabbix_frontend_hostname}"
    end
  end

  context "{ database_user => '#{Params.database_test_user}', database_password => '#{Params.database_test_password}' }" do
    describe "puppet manifest" do
      it "should run without errors" do
        shell Params.clean_cmd

        pp = Manifest.server_pp(database_user: Params.database_test_user, database_password: Params.database_test_password)

        apply_manifest(pp, :expect_changes => true)
        apply_manifest(pp)
        apply_manifest(pp, :catch_changes => true)
      end
    end

    describe "zabbix server application" do
      it_should_behave_like "an application", Params.zabbix_server_application
    end

    describe "apache application" do
      it_should_behave_like "an application", Params.apache_application
    end

    describe "mysql zabbix database" do
      mysql_database_params = Params.mysql_default_params
      mysql_database_params[:user] = Params.database_test_user
      mysql_database_params[:password] = Params.database_test_password

      it_should_behave_like "an accessible database", mysql_database_params
    end

    describe "zabbix frontend" do
      it_should_behave_like "a responsible url from guest", "http://#{Params.zabbix_frontend_hostname}"
    end
  end
end
