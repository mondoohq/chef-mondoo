<<<<<<< HEAD
# Copyright:: Mondoo, Inc.
=======
# Copyright (c) Mondoo, Inc.
>>>>>>> 8309bcbf980064d3bab9236e47d293ef8d4639bd
# SPDX-License-Identifier: BUSL-1.1

require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '20.04'
end
