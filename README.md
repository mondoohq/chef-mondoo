# Mondoo Package Chef Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/mondoo.svg)](https://supermarket.chef.io/cookbooks/mondoo)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs Mondoo `cnquery` and `cnspec` on Linux servers for infrastructure security, compliance, and asset intelligence.

The `default` cookbook recipe:

* Installs the signed `mondoo` package
* Logs in `cnquery` and `cnspec` with Mondoo Platform
* Enables the `cnspec` systemd service

## Requirements

### Platforms

* Amazon Linux
* Debian
* Fedora
* Red Hat, AlmaLinux, CentOS, Oracle Linux, Rocky Linux, Scientific Linux
* SLES and openSUSE
* Ubuntu

### Chef Infra

* Chef Infra Client >= 14.0

### Cookbooks

* [line cookbook](https://supermarket.chef.io/cookbooks/line)

## Attributes

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `default['mondoo']['registration_token']` | `change_me` | Mondoo Registration Token that is used to retrieve client credentials
| `default['mondoo']['api_proxy']` | `` | Proxy server URL setting for communication with Mondoo Platform

## Run Mondoo Cookbook with chef-run

See the `examples` directory for examples of using this cookbook with `chef-run`.

## Testing

Ensure docker and vagrant are installed and run:

```bash
MONDOO_TOKEN=ey...Bp KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test
```

(or add MONDOO_API_PROXY to the list of variables to test the setting/using of that variable)

You can "enter" the resulting environment used for the test by changing the 'test' kitchen command to 'login'.

You can reduce the number of environments tested (to speed up local testing) by commenting out unnecessary entries from kitchen.dokken.yml.

## Release

This repo includes a GitHub action "Supermarket Release", which can be manually triggered to perform a release. Before running this workflow make sure to do the following:

- Update the metadata.rb file with the new version.
- Update the CHANGELOG.md file to document the new release.

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

## Join the community!

Join the [Mondoo Community GitHub Discussions](https://github.com/orgs/mondoohq/discussions) to collaborate on policy as code and security automation.
