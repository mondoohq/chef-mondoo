#
# Cookbook:: mondoo
# Recipe:: rpm
#
# Copyright:: 2021-2023, Mondoo, Inc, All Rights Reserved.

if platform_family?('suse')
  zypper_repository 'mondoo' do
    description 'Mondoo Repository'
    baseurl node['mondoo']['rpm']['repo']
    gpgkey node['mondoo']['rpm']['gpgkey']
    action :create
  end
else
  yum_repository 'mondoo' do
    description 'Mondoo Repository'
    baseurl node['mondoo']['rpm']['repo']
    gpgkey node['mondoo']['rpm']['gpgkey']
    action :create
  end
end

package 'mondoo'
