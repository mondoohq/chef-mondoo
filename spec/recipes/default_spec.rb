<<<<<<< HEAD
# Copyright:: Mondoo, Inc.
=======
# Copyright (c) Mondoo, Inc.
>>>>>>> 8309bcbf980064d3bab9236e47d293ef8d4639bd
# SPDX-License-Identifier: BUSL-1.1

require 'spec_helper'

describe 'mondoo::default' do
  context 'with no attributes set' do
    describe 'installs mondoo and sets up cnspec service' do
      it { is_expected.to install_package('mondoo') }
      it { is_expected.to enable_service('cnspec.service') }
      it { is_expected.to start_service('cnspec.service') }
    end

    describe 'runs cnspec login with just config & token flags' do
      it { is_expected.to run_execute('cnspec_login').with(command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me') }
    end
  end

  context 'with proxy attribute set' do
    describe 'runs cnspec login with config, token, and api-proxy flags' do
      override_attributes['mondoo']['api_proxy'] = 'example.com:3128'

      it { is_expected.to run_execute('cnspec_login').with(command: 'cnspec login --config /etc/opt/mondoo/mondoo.yml --token change_me --api-proxy example.com:3128') }
    end
  end
end
