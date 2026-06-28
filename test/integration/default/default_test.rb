# Copyright :: Mondoo, Inc. 2024, 2026
# SPDX-License-Identifier: BUSL-1.1

# InSpec test for recipe mondoo::default

describe package('mondoo') do
  it { should be_installed }
end

describe package('cnspec') do
  it { should be_installed }
end

# cnspec must be on PATH and runnable after the package is installed.
describe command('cnspec version') do
  its('exit_status') { should eq 0 }
end

# The recipe creates this directory explicitly with mode 0755, owned by root.
describe directory('/etc/opt/mondoo') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0755' }
end

# cnspec login writes its credentials/config here.
describe file('/etc/opt/mondoo/mondoo.yml') do
  it { should exist }
  it { should be_file }
end

describe service('cnspec.service') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# The recipe stops and disables the deprecated mondoo.service; it must not be
# left running or enabled (this also passes when the unit does not exist).
describe service('mondoo.service') do
  it { should_not be_enabled }
  it { should_not be_running }
end
