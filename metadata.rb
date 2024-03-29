# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1

name 'mondoo'
maintainer 'Mondoo, Inc'
maintainer_email 'hello@mondoo.com'
license 'BUSL-1.1'
description 'Installs and configures Mondoo package for infrastructure security, compliance, and asset intelligence'
version '1.1.0'
chef_version '>= 14'
source_url 'https://github.com/mondoohq/chef-mondoo'
issues_url 'https://github.com/mondoohq/chef-mondoo/issues'
depends 'line'

supports 'almalinux', '>= 8.0'
supports 'amazon', '>= 2.0'
supports 'centos', '>= 6.0'
supports 'debian', '>= 9.0'
supports 'fedora', '>= 34.0'
supports 'opensuseleap', '>= 15.0'
supports 'redhat', '>= 6.0'
supports 'rocky', '>= 8.0'
supports 'scientific', '>= 7.0'
supports 'suse', '>= 12.0'
