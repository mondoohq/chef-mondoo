# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1

# see https://docs.chef.io/environment_variables.html
ENV['LANG'] = 'en_US.utf-8'
ENV['LC_ALL'] = 'en_US.utf-8'

include_recipe 'mondoo::default'
