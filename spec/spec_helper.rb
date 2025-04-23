# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1

require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '22.04'
end
