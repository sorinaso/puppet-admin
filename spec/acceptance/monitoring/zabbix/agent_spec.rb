require 'spec_helper'

include SpecHelper::Monitoring::Zabbix

describe 'admin::monitoring::zabbix::agent class:' do

  context "without parameters" do
    describe "puppet manifest" do
      it "should run without errors" do
        shell Params.clean_cmd

        apply_manifest(Manifest.agent_pp, :expect_changes => true)
        apply_manifest(Manifest.agent_pp, :catch_changes => true)
      end
    end

    describe "zabbix agent application" do
      it_should_behave_like "an application", Params.zabbix_agent_application
    end
  end
end
