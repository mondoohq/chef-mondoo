<<<<<<< HEAD
# Copyright:: Mondoo, Inc.
# SPDX-License-Identifier: BUSL-1.1
=======
# Copyright:: 2021-2023 Mondoo, Inc
# License:: BUSL-1.1
>>>>>>> 8309bcbf980064d3bab9236e47d293ef8d4639bd


default['mondoo']['registration_token'] = 'change_me'
default['mondoo']['api_proxy'] = nil

default['mondoo']['deb']['repo'] = 'https://releases.mondoo.com/debian/'
default['mondoo']['deb']['gpgkey'] = 'https://releases.mondoo.com/debian/pubkey.gpg'

default['mondoo']['rpm']['repo'] = 'https://releases.mondoo.com/rpm/$basearch/'
default['mondoo']['rpm']['gpgkey'] = 'https://releases.mondoo.com/rpm/pubkey.gpg'
