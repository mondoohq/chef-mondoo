# Copyright :: Mondoo, Inc. 2024, 2026
# SPDX-License-Identifier: BUSL-1.1

require 'spec_helper'

describe 'mondoo::default' do
  # Behavior that is identical on every supported platform.
  shared_examples 'a mondoo install' do
    it { is_expected.to install_package('mondoo') }
    it { is_expected.to create_directory('/etc/opt/mondoo/') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }

    # cnspec_login presence is covered by the more specific command assertion below.
    it 'logs in with the registration token' do
      expect(chef_run).to run_execute('cnspec_login').with(
        command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me'
      )
    end

    it 'marks the login as sensitive so the token is not logged' do
      expect(chef_run.find_resource(:execute, 'cnspec_login').sensitive).to be true
    end
  end

  context 'on Ubuntu' do
    platform 'ubuntu', '22.04'

    it_behaves_like 'a mondoo install'

    it { is_expected.to add_apt_repository('mondoo') }
    it { is_expected.not_to create_yum_repository('mondoo') }

    it 'removes any api_proxy line when no proxy is configured' do
      expect(chef_run.find_resource(:delete_lines, 'remove api_proxy from config file')).not_to be_nil
      expect(chef_run.find_resource(:replace_or_add, 'add api_proxy to config file')).to be_nil
    end

    context 'with proxy attribute set' do
      override_attributes['mondoo']['api_proxy'] = 'example.com:3128'

      it 'passes the proxy to cnspec login' do
        expect(chef_run).to run_execute('cnspec_login').with(
          command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me --api-proxy example.com:3128'
        )
      end

      it 'writes the api_proxy line into the config file' do
        expect(chef_run.find_resource(:replace_or_add, 'add api_proxy to config file')).not_to be_nil
        expect(chef_run.find_resource(:delete_lines, 'remove api_proxy from config file')).to be_nil
      end
    end
  end

  context 'on Debian' do
    platform 'debian', '12'

    it_behaves_like 'a mondoo install'

    it { is_expected.to add_apt_repository('mondoo') }
    it { is_expected.not_to create_yum_repository('mondoo') }
  end

  context 'on RHEL' do
    platform 'redhat', '9'

    it_behaves_like 'a mondoo install'

    it { is_expected.to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end

  # Fedora shares the rpm/yum code path exercised by the RHEL and Amazon
  # contexts above (the recipe routes 'rhel', 'fedora', and 'amazon' families
  # to mondoo::rpm). It is not given its own context because fauxhai-chef only
  # ships Fedora data below this cookbook's supported floor (fedora >= 34).

  context 'on SUSE' do
    platform 'opensuse', '15'

    it_behaves_like 'a mondoo install'

    it { is_expected.to create_zypper_repository('mondoo') }
    it { is_expected.not_to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end

  context 'on Amazon Linux' do
    platform 'amazon', '2023'

    it_behaves_like 'a mondoo install'

    it { is_expected.to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end
end
