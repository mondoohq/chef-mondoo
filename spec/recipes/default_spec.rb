# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1

require 'spec_helper'

describe 'mondoo::default' do
  context 'on Ubuntu' do
    platform 'ubuntu', '22.04'

    it { is_expected.to install_package('mondoo') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }
    it { is_expected.to run_execute('cnspec_login').with(command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me') }

    it { is_expected.to add_apt_repository('mondoo') }
    it { is_expected.not_to create_yum_repository('mondoo') }

    context 'with proxy attribute set' do
      override_attributes['mondoo']['api_proxy'] = 'example.com:3128'

      it { is_expected.to run_execute('cnspec_login').with(command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me --api-proxy example.com:3128') }
    end
  end

  context 'on CentOS' do
    platform 'centos', '8'

    it { is_expected.to install_package('mondoo') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }
    it { is_expected.to run_execute('cnspec_login') }

    it { is_expected.to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end

  context 'on SUSE' do
    platform 'opensuse', '15'

    it { is_expected.to install_package('mondoo') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }
    it { is_expected.to run_execute('cnspec_login') }

    it { is_expected.to create_zypper_repository('mondoo') }
    it { is_expected.not_to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end

  context 'on Amazon Linux' do
    platform 'amazon', '2023'

    it { is_expected.to install_package('mondoo') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }

    it { is_expected.to create_yum_repository('mondoo') }
    it { is_expected.not_to add_apt_repository('mondoo') }
  end
end
