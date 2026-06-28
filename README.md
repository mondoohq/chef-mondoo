# Mondoo Package Chef Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/mondoo.svg)](https://supermarket.chef.io/cookbooks/mondoo)
[![Unit Tests](https://github.com/mondoohq/chef-mondoo/actions/workflows/unit.yaml/badge.svg)](https://github.com/mondoohq/chef-mondoo/actions/workflows/unit.yaml)
[![License](https://img.shields.io/badge/License-BUSL--1.1-green.svg)](https://spdx.org/licenses/BUSL-1.1.html)

This cookbook installs and configures Mondoo's [`cnspec`](https://github.com/mondoohq/cnspec) on Linux servers and connects it to [Mondoo Platform](https://mondoo.com/) for continuous vulnerability management, security, and compliance.

## Usage

1. **Get a registration token.** In the [Mondoo Platform](https://app.mondoo.com/), open the Space you want assets to report into and create a registration token under that Space's settings. See the [cnspec documentation](https://mondoo.com/docs/cnspec/) for more on how `cnspec` registers and scans.

2. **Add the cookbook to your run list and set the token.** Depend on `mondoo` from your wrapper cookbook (`depends 'mondoo'` in `metadata.rb`) and set the registration token as an attribute. The minimum required attribute is `registration_token`:

   ```ruby
   # in a role, environment, Policyfile, or wrapper cookbook attributes
   default['mondoo']['registration_token'] = 'YOUR_REGISTRATION_TOKEN'
   ```

   Then add the default recipe to your run list:

   ```ruby
   run_list 'recipe[mondoo::default]'
   ```

> [!CAUTION]
> The registration token is a secret. Source it from an encrypted data bag, a node attribute set by your provisioning pipeline, or another secrets manager rather than committing it to version control.

See the [`examples/`](examples) directory for a complete wrapper cookbook (including a `chef-run` walkthrough).

## What this cookbook does

The `default` recipe:

* Adds the signed Mondoo package repository (APT on Debian/Ubuntu, YUM/DNF on RHEL-family, Zypper on SUSE) and installs the `mondoo` package
* Creates the `/etc/opt/mondoo/` configuration directory
* Registers the node with Mondoo Platform by running `cnspec login` with your registration token (and optional API proxy), writing credentials to `/etc/opt/mondoo/mondoo.yml`
* Adds or removes the `api_proxy` setting in `mondoo.yml` based on the `api_proxy` attribute
* Starts and enables the `cnspec.service` systemd service for scheduled scans
* Stops and disables the deprecated `mondoo.service` if present

## Requirements

### Platforms

The cookbook supports all non-EOL releases of:

* Amazon Linux
* Debian
* Fedora
* Red Hat, AlmaLinux, Rocky Linux
* SLES and openSUSE Leap
* Ubuntu

### Chef Infra

* Chef Infra Client >= 17

### Cookbooks

* [line cookbook](https://supermarket.chef.io/cookbooks/line)

## Recipes

| Recipe | Description |
| ------ | ----------- |
| `mondoo::default` | Entry point. Configures the repository, installs `cnspec`, registers the node, and enables the service. This is the only recipe you should add to a run list. |
| `mondoo::deb` | Internal helper. Configures the APT repository and installs the package on Debian/Ubuntu. Included automatically by `default`. |
| `mondoo::rpm` | Internal helper. Configures the YUM/Zypper repository and installs the package on RHEL-family and SUSE platforms. Included automatically by `default`. |

## Attributes

| Attribute | Default | Description |
| --------- | ------- | ----------- |
| `default['mondoo']['registration_token']` | `change_me` | Mondoo registration token used to retrieve client credentials. **Required** — override this. |
| `default['mondoo']['api_proxy']` | `nil` | Proxy server URL for communication with Mondoo Platform (for example, `http://proxy.example.com:3128`). When set, it is written to `mondoo.yml`; when unset, any existing `api_proxy` line is removed. |
| `default['mondoo']['deb']['repo']` | `https://releases.mondoo.com/debian/` | APT repository URL for Debian/Ubuntu. Override to use a local mirror. |
| `default['mondoo']['deb']['gpgkey']` | `https://releases.mondoo.com/debian/pubkey.gpg` | GPG key URL used to verify the APT repository. |
| `default['mondoo']['rpm']['repo']` | `https://releases.mondoo.com/rpm/$basearch/` | YUM/Zypper repository URL for RHEL-family and SUSE. Override to use a local mirror. |
| `default['mondoo']['rpm']['gpgkey']` | `https://releases.mondoo.com/rpm/pubkey.gpg` | GPG key URL used to verify the RPM repository. |

## Verify

After a successful Chef run, confirm the node is registered and reporting:

```bash
# The service that runs scheduled scans should be active and enabled
systemctl status cnspec.service

# Confirm cnspec is registered with Mondoo Platform
cnspec status

# Credentials and configuration are written here
cat /etc/opt/mondoo/mondoo.yml
```

The registered asset also appears in your Space in the [Mondoo Platform](https://app.mondoo.com/).

## Troubleshooting

* **Registration fails / asset never appears.** Confirm the `registration_token` is valid and belongs to the intended Space. The token is consumed during `cnspec login`; once `/etc/opt/mondoo/mondoo.yml` exists, the login step is skipped on subsequent converges (it is guarded by `creates`). To re-register, remove `mondoo.yml` and run Chef again.
* **Behind a proxy.** Set `default['mondoo']['api_proxy']` so both the `cnspec login` call and the persisted `mondoo.yml` use the proxy.
* **Offline or mirrored repositories.** Override the `deb`/`rpm` `repo` and `gpgkey` attributes to point at your internal mirror.

## Examples

See the [`examples/`](examples) directory for a complete wrapper cookbook and a `chef-run` walkthrough.

## Testing

This repo uses [Test Kitchen](https://kitchen.ci/) for integration tests, [ChefSpec](https://github.com/chefspec/chefspec) for unit tests, and [Cookstyle](https://docs.chef.io/workstation/cookstyle/) for linting. All three run in CI.

```bash
# Lint
cookstyle .

# Unit tests
chef exec rspec

# Integration tests (requires Docker)
MONDOO_TOKEN=ey...Bp kitchen test
```

For integration tests, add `MONDOO_API_PROXY` to the variables to exercise the proxy setting. You can "enter" the resulting test environment by changing the `kitchen test` command to `kitchen login`. To speed up local testing, comment out unneeded entries in `kitchen.yml`.

The `Makefile` provides additional checks used in CI:

```bash
make test/spell-check       # spell check via typos
make license                # check copyright/license headers
make license/headers/apply  # apply missing license headers
```

## Release

This repo includes a GitHub Action "Supermarket Release", which you can manually trigger to perform a release. Before running this workflow make sure to:

- Update the `metadata.rb` file with the new version.
- Update the `CHANGELOG.md` file to document the new release.

## Author

Mondoo, Inc

## License

This project is licensed under the [Business Source License 1.1 (BUSL-1.1)](https://spdx.org/licenses/BUSL-1.1.html). See the [LICENSE](LICENSE) file for details.

## Join the community!

Join the [Mondoo Community GitHub Discussions](https://github.com/orgs/mondoohq/discussions) to collaborate on policy as code and security automation.
