# Copyright :: Mondoo, Inc. 2024, 2026
# SPDX-License-Identifier: BUSL-1.1

default['mondoo']['registration_token'] = 'change_me'
default['mondoo']['api_proxy'] = nil

default['mondoo']['deb']['repo'] = 'https://releases.mondoo.com/debian/'
default['mondoo']['deb']['gpgkey'] = 'https://releases.mondoo.com/debian/pubkey.gpg'

default['mondoo']['rpm']['repo'] = 'https://releases.mondoo.com/rpm/$basearch/'
default['mondoo']['rpm']['gpgkey'] = 'https://releases.mondoo.com/rpm/pubkey.gpg'

# Re-register the node on every Chef run: log out, delete mondoo.yml, and run
# `cnspec login` again. Leave this false except to rotate a registration.
default['mondoo']['force_registration'] = false

# Annotations attached to the asset at registration, as a Hash of
# key => value (for example, { 'env' => 'production' }).
default['mondoo']['annotations'] = {}

# Scan interval and random splay, in minutes. nil keeps cnspec's defaults.
default['mondoo']['timer'] = nil
default['mondoo']['splay'] = nil

# Set to false to disable automatic updates of cnspec and its providers.
default['mondoo']['auto_update'] = true
