<<<<<<< HEAD
# Copyright:: Mondoo, Inc.
=======
# Copyright (c) Mondoo, Inc.
>>>>>>> 8309bcbf980064d3bab9236e47d293ef8d4639bd
# SPDX-License-Identifier: BUSL-1.1

# InSpec test for recipe mondoo::default

describe package('mondoo') do
  it { should be_installed }
end

describe package('cnquery') do
  it { should be_installed }
end

describe package('cnspec') do
  it { should be_installed }
end

describe service('cnspec.service') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/opt/mondoo/mondoo.yml') do
  it { should exist }
end
