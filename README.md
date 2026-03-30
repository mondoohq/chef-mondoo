# Mondoo Package Chef Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/mondoo.svg)](https://supermarket.chef.io/cookbooks/mondoo)
[![License](https://img.shields.io/badge/License-BUSL--1.1-green.svg)](https://spdx.org/licenses/BUSL-1.1.html)

This cookbook installs Mondoo `cnquery` and `cnspec` on Linux servers for infrastructure security, compliance, and asset intelligence.

The `default` cookbook recipe:

* Installs the signed `mondoo` package
* Logs in `cnquery` and `cnspec` with Mondoo Platform
* Enables the `cnspec` systemd service

## Requirements

### Platforms

* Amazon Linux >= 2
* CentOS >= 8
* Debian >= 11
* Fedora >= 34
* Red Hat >= 8, AlmaLinux >= 8, Rocky Linux >= 8
* SLES >= 12 and openSUSE Leap >= 15
* Ubuntu >= 20.04

### Chef Infra

* Chef Infra Client >= 17

### Cookbooks

* [line cookbook](https://supermarket.chef.io/cookbooks/line)

## Attributes

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `default['mondoo']['registration_token']` | `change_me` | Mondoo Registration Token that is used to retrieve client credentials
| `default['mondoo']['api_proxy']` | `` | Proxy server URL setting for communication with Mondoo Platform

## Examples

See the `examples` directory for examples of using this cookbook.

## Testing

Ensure Docker is installed and run:

```bash
MONDOO_TOKEN=ey...Bp kitchen test
```

(or add MONDOO_API_PROXY to the list of variables to test the setting/using of that variable)

You can "enter" the resulting environment used for the test by changing the 'test' kitchen command to 'login'.

You can reduce the number of environments tested (to speed up local testing) by commenting out unnecessary entries from kitchen.yml.

## Release

This repo includes a GitHub action "Supermarket Release", which you can manually trigger to perform a release. Before running this workflow make sure to:

- Update the metadata.rb file with the new version.
- Update the CHANGELOG.md file to document the new release.

## Author

Mondoo, Inc

## License

This project is licensed under the [Business Source License 1.1 (BUSL-1.1)](https://spdx.org/licenses/BUSL-1.1.html). See the [LICENSE](LICENSE) file for details.

## Join the community!

Join the [Mondoo Community GitHub Discussions](https://github.com/orgs/mondoohq/discussions) to collaborate on policy as code and security automation.
