require 'spec_helper'

include SpecHelper::Mail::GmailSendOnly

describe 'admin::mail::gmail_send_only class:' do
  context "without parameters" do
    describe "manifest" do
      it "should run without errors" do
        # CLeanup
        shell Params.clean_cmd

        apply_manifest(Manifest.pp, :expect_changes => true)
        apply_manifest(Manifest.pp, :catch_changes => true)

        # Send test mail and wait for 5 seconds.
        shell Params.send_mail_cmd
        sleep 5
      end
    end

    describe "nullmailer application" do
      it_should_behave_like "an application", Params.nullmailer_application
    end

    describe "sent e-mail" do
      describe file(Params.mail_log_file) do
        it { should contain 'smtp: Succeeded: 250 2.0.0 OK' }
      end
    end
  end
end
