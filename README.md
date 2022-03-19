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
* Red Hat, CentOS, AlmaLinux, Rocky Linux, Scientific Linux
* Ubuntu

### Chef Infra

* Chef Infra Client >= 14.0

## Attributes

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `default['mondoo']['registration_token']` | `changeme` | Mondoo Registration Token that is used to retrieve client credentials

## Testing

This cookbook uses test-kitchen and InSpec for cookbook testing

```bash
# show all test vms 
kitchen list
# converge all vms
kitchen converge
# converge an individual vm
kitchen converge centos
# verify all instances
kitchen verify
# debug instance
kitchen login centos
# destroys all instances
kitchen destroy
```

## Release

We use stove to release the cookbook:

```
bundle install
bundle exec stove login --username login --key ~/.chef/key.pem
bundle exec stove --log-level debug --no-git
```

## Author

Mondoo, Inc