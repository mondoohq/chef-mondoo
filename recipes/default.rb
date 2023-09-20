#
# Cookbook:: mondoo
# Recipe:: default
#
# Copyright:: 2021-2023 Mondoo, Inc
# License:: BUSL-1.1

require 'yaml'

Chef::Log.info("Detected platform: #{node['platform_family']}")

# install package repository
case node['platform_family']
when 'debian' # configure ubuntu, debian
  include_recipe 'mondoo::deb'
when 'rhel', 'fedora', 'amazon', 'suse' # configure rhel/sles-derived platforms
  include_recipe 'mondoo::rpm'
end

directory '/etc/opt/mondoo/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

login_cmd = "cnspec login --config /etc/opt/mondoo/mondoo.yml --token #{node['mondoo']['registration_token']}"
login_cmd << " --api-proxy #{node['mondoo']['api_proxy']}" if node['mondoo']['api_proxy']

# register the mondoo client
execute 'cnspec_login' do
  command login_cmd
  user 'root'
  creates '/etc/opt/mondoo/mondoo.yml'
end

if node['mondoo']['api_proxy']
  replace_or_add 'add api_proxy to config file' do
    path '/etc/opt/mondoo/mondoo.yml'
    pattern '^api_proxy:.*'
    line "api_proxy: #{node['mondoo']['api_proxy']}"
  end
else
  delete_lines 'remove api_proxy from config file' do
    path '/etc/opt/mondoo/mondoo.yml'
    pattern '^api_proxy:.*'
  end
end

# enable the service
service 'cnspec.service' do
  action [:start, :enable]
end

# disable deprecated mondoo service
service 'mondoo.service' do
  action [:stop, :disable]
  ignore_failure true
end
