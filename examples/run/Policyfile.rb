# Copyright (c) Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1

name 'run'

run_list 'run::default'

default_source :supermarket
cookbook 'mondoo'
cookbook 'run', path: './'

default['mondoo']['registration_token'] = 'changeme'
