<<<<<<< HEAD
# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1
=======
# Copyright:: 2021-2023 Mondoo, Inc
# License:: BUSL-1.1
>>>>>>> 8309bcbf980064d3bab9236e47d293ef8d4639bd

name 'run'

run_list 'run::default'

default_source :supermarket
cookbook 'mondoo'
cookbook 'run', path: './'

default['mondoo']['registration_token'] = 'changeme'
