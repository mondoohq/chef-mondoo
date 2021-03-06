# Mondoo Chef Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/mondoo.svg)](https://supermarket.chef.io/cookbooks/mondoo)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs the Mondoo Client on Linux servers.

It does:

* Installs the signed `mondoo` package
* Registers the client with Mondoo Platform
* Enables the systemd service

## Requirements

### Platforms

* Amazon Linux
* Debian
* Fedora
* Red Hat, AlmaLinux, CentOS, Rocky Linux, Scientific Linux
* SLES and openSUSE
* Ubuntu

### Chef Infra

* Chef Infra Client >= 14.0

## Attributes

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `default['mondoo']['registration_token']` | `change_me` | Mondoo Registration Token that is used to retrieve client credentials

## Release

We use the stove gem to release the cookbook:

```bash
bundle install
bundle exec stove login --username login --key ~/.chef/key.pem
bundle exec stove --log-level debug --branch main
```

## Author

Mondoo, Inc

## License

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
