# Copyright :: Mondoo, Inc. 2024, 2026
# SPDX-License-Identifier: BUSL-1.1

require 'spec_helper'

describe 'mondoo::default' do
  config_file = '/etc/opt/mondoo/mondoo.yml'
  base_cmd = ['cnspec', 'login', '--config', config_file, '--token', 'change_me']

  # Behavior that is identical on every supported platform.
  shared_examples 'a mondoo install' do
    it { is_expected.to install_package('mondoo') }
    it { is_expected.to create_directory('/etc/opt/mondoo/') }
    it { is_expected.to enable_service('cnspec.service') }
    it { is_expected.to start_service('cnspec.service') }

    # cnspec_login presence is covered by the more specific command assertion below.
    it 'logs in with the registration token' do
      expect(chef_run).to run_execute('cnspec_login').with(command: base_cmd)
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
          command: base_cmd + ['--api-proxy', 'example.com:3128']
        )
      end

      it 'writes the api_proxy line into the config file' do
        expect(chef_run.find_resource(:replace_or_add, 'add api_proxy to config file')).not_to be_nil
        expect(chef_run.find_resource(:delete_lines, 'remove api_proxy from config file')).to be_nil
      end
    end

    context 'with default registration settings' do
      it 'does not log out or remove the existing registration' do
        expect(chef_run.find_resource(:execute, 'cnspec_logout')).to be_nil
        expect(chef_run.find_resource(:file, 'remove existing registration')).to be_nil
      end

      it 'leaves auto_update to the cnspec default by removing any auto_update line' do
        expect(chef_run).to edit_delete_lines('remove auto_update from config file').with(
          path: config_file,
          pattern: '^auto_update:.*'
        )
        expect(chef_run.find_resource(:replace_or_add, 'disable auto_update in config file')).to be_nil
      end
    end

    context 'with force_registration enabled' do
      override_attributes['mondoo']['force_registration'] = true

      context 'when the node is already registered' do
        before do
          allow(::File).to receive(:exist?).and_call_original
          allow(::File).to receive(:exist?).with(config_file).and_return(true)
        end

        it 'logs out of Mondoo Platform, tolerating invalid credentials' do
          expect(chef_run).to run_execute('cnspec_logout').with(
            command: ['cnspec', 'logout', '--force', '--config', config_file],
            user: 'root',
            ignore_failure: true
          )
        end
      end

      context 'when the node is not registered yet' do
        before do
          allow(::File).to receive(:exist?).and_call_original
          allow(::File).to receive(:exist?).with(config_file).and_return(false)
        end

        it 'skips the logout' do
          expect(chef_run).not_to run_execute('cnspec_logout')
        end
      end

      it 'deletes the config file so cnspec login runs again' do
        expect(chef_run).to delete_file('remove existing registration').with(path: config_file)
        expect(chef_run).to run_execute('cnspec_login').with(command: base_cmd)
      end

      it 'logs out and deletes the config before logging in' do
        names = chef_run.resource_collection.all_resources.map(&:to_s)
        logout = names.index('execute[cnspec_logout]')
        delete = names.index('file[remove existing registration]')
        login = names.index('execute[cnspec_login]')

        expect(logout).to be < delete
        expect(delete).to be < login
      end
    end

    context 'with timer and splay set' do
      override_attributes['mondoo']['timer'] = 30
      override_attributes['mondoo']['splay'] = '10'

      it 'passes both to cnspec login, accepting integers or numeric strings' do
        expect(chef_run).to run_execute('cnspec_login').with(
          command: base_cmd + ['--timer', '30', '--splay', '10']
        )
      end
    end

    context 'with only splay set' do
      override_attributes['mondoo']['splay'] = 5

      it 'passes only --splay' do
        expect(chef_run).to run_execute('cnspec_login').with(command: base_cmd + ['--splay', '5'])
      end
    end

    context 'with a zero-padded timer' do
      override_attributes['mondoo']['timer'] = '090'

      it 'reads it as base 10, not octal' do
        expect(chef_run).to run_execute('cnspec_login').with(command: base_cmd + ['--timer', '90'])
      end
    end

    [0, -5, 'abc', '1.5', 2.5, ''].each do |bad|
      context "with timer set to #{bad.inspect}" do
        override_attributes['mondoo']['timer'] = bad

        it 'fails the run with a clear message' do
          expect { chef_run }.to raise_error(/node\['mondoo'\]\['timer'\] must be a positive whole number/)
        end
      end
    end

    context 'with an invalid splay' do
      override_attributes['mondoo']['splay'] = 'often'

      it 'fails the run naming the splay attribute' do
        expect { chef_run }.to raise_error(/node\['mondoo'\]\['splay'\] must be a positive whole number/)
      end
    end

    context 'with annotations set' do
      override_attributes['mondoo']['annotations'] = {
        'owner' => 'sec team',
        'env' => 'production',
        'teams' => 'a,b',
        'query' => 'x=1',
      }

      it 'passes one --annotation per pair, sorted by key' do
        expect(chef_run).to run_execute('cnspec_login').with(
          command: base_cmd + [
            '--annotation', 'env=production',
            '--annotation', 'owner=sec team',
            '--annotation', '"query=x=1"',
            '--annotation', 'teams=a,b'
          ]
        )
      end
    end

    context 'with an annotation value containing = and a quote' do
      override_attributes['mondoo']['annotations'] = { 'note' => 'say "a=b"' }

      it 'CSV-quotes the pair so cnspec parses it as a single annotation' do
        expect(chef_run).to run_execute('cnspec_login').with(
          command: base_cmd + ['--annotation', '"note=say ""a=b"""']
        )
      end
    end

    context 'with annotations set to a string' do
      override_attributes['mondoo']['annotations'] = 'env=production'

      it 'fails the run asking for a Hash' do
        expect { chef_run }.to raise_error(/node\['mondoo'\]\['annotations'\] must be a Hash/)
      end
    end

    context 'with annotations set to nil' do
      override_attributes['mondoo']['annotations'] = nil

      it 'logs in without annotations' do
        expect(chef_run).to run_execute('cnspec_login').with(command: base_cmd)
      end
    end

    context 'with every login option set' do
      override_attributes['mondoo']['api_proxy'] = 'http://proxy:3128'
      override_attributes['mondoo']['timer'] = 60
      override_attributes['mondoo']['splay'] = 15
      override_attributes['mondoo']['annotations'] = { 'env' => 'prod' }

      it 'builds the full cnspec login command' do
        expect(chef_run).to run_execute('cnspec_login').with(
          command: base_cmd + [
            '--api-proxy', 'http://proxy:3128',
            '--timer', '60',
            '--splay', '15',
            '--annotation', 'env=prod'
          ]
        )
      end
    end

    context 'with auto_update disabled' do
      override_attributes['mondoo']['auto_update'] = false

      it 'writes auto_update: false into the config file' do
        expect(chef_run).to edit_replace_or_add('disable auto_update in config file').with(
          path: config_file,
          pattern: '^auto_update:.*',
          line: 'auto_update: false'
        )
        expect(chef_run.find_resource(:delete_lines, 'remove auto_update from config file')).to be_nil
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
