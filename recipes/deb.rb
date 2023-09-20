#
# Cookbook:: mondoo
# Recipe:: deb
#
# Copyright:: 2021-2023 Mondoo, Inc
# License:: BUSL-1.1

apt_repository 'mondoo' do
  uri        node['mondoo']['deb']['repo']
  key        [node['mondoo']['deb']['gpgkey']]
  distribution 'stable'
  components ['main']
end

package 'mondoo' do
  action :install
end
