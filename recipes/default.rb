#
# Cookbook:: mondoo
# Recipe:: default
#
# Copyright:: 2021-2023 Mondoo, Inc
# License:: BUSL-1.1

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

config_file = '/etc/opt/mondoo/mondoo.yml'

# Returns a positive whole number of minutes as a String, or nil when unset.
minutes = lambda do |name|
  value = node['mondoo'][name]
  next nil if value.nil?

  int = Integer(value.to_s, 10)
  raise ArgumentError unless int.positive?

  int.to_s
rescue ArgumentError
  raise "node['mondoo']['#{name}'] must be a positive whole number of minutes, got #{value.inspect}"
end

annotations = node['mondoo']['annotations'] || {}
unless annotations.respond_to?(:each_pair)
  raise "node['mondoo']['annotations'] must be a Hash of key => value, got #{annotations.inspect}"
end

# Built as an array so Chef runs cnspec without a shell and values are passed verbatim.
login_cmd = ['cnspec', 'login', '--config', config_file, '--token', node['mondoo']['registration_token']]
login_cmd.push('--api-proxy', node['mondoo']['api_proxy']) if node['mondoo']['api_proxy']
timer = minutes.call('timer')
splay = minutes.call('splay')
login_cmd.push('--timer', timer) if timer
login_cmd.push('--splay', splay) if splay
annotations.keys.sort.each do |key|
  pair = "#{key}=#{annotations[key]}"
  if pair.count('=') > 1
    # cnspec parses a value with more than one '=' as a CSV record, so quote it.
    pair = %("#{pair.gsub('"', '""')}")
  elsif pair.start_with?('"') || pair.end_with?('"')
    # With a single '=', cnspec strips leading and trailing double quotes, and
    # no quoting survives that, so refuse rather than register a changed value.
    raise "node['mondoo']['annotations'] key #{key.inspect} cannot start, and its value cannot end, " \
          'with a double quote; cnspec strips those characters'
  end
  login_cmd.push('--annotation', pair)
end

if node['mondoo']['force_registration']
  execute 'cnspec_logout' do
    command ['cnspec', 'logout', '--force', '--config', config_file]
    user 'root'
    ignore_failure true # the existing credentials may already be invalid
    only_if { ::File.exist?(config_file) }
  end

  file 'remove existing registration' do
    path config_file
    action :delete
  end
end

# register the mondoo client
execute 'cnspec_login' do
  command login_cmd
  user 'root'
  sensitive true
  creates config_file
end

if node['mondoo']['api_proxy']
  replace_or_add 'add api_proxy to config file' do
    path config_file
    pattern '^api_proxy:.*'
    line "api_proxy: #{node['mondoo']['api_proxy']}"
  end
else
  delete_lines 'remove api_proxy from config file' do
    path config_file
    pattern '^api_proxy:.*'
  end
end

# auto_update defaults to true in cnspec, so the line is only written to disable it.
if node['mondoo']['auto_update']
  delete_lines 'remove auto_update from config file' do
    path config_file
    pattern '^auto_update:.*'
  end
else
  replace_or_add 'disable auto_update in config file' do
    path config_file
    pattern '^auto_update:.*'
    line 'auto_update: false'
  end
end

# enable the service
#
# Note: cnspec.service declares `Alias=mondoo.service` in its [Install] section,
# so mondoo.service is now the same unit as cnspec.service. We must NOT stop or
# disable mondoo.service here — doing so would tear down the cnspec service we
# just started/enabled.
service 'cnspec.service' do
  action [:start, :enable]
end
