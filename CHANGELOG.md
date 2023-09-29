# Mondoo Changelog

This file is used to list changes made in each version of the mondoo cookbook.

## 1.0.0 (September 14, 2023)

- Update metadata.rb with a new cookbook description.
- Improve README.md content to better describe usage and testing.

## 0.6.0 (May 9th, 2023)

- Add a new attribute `default['mondoo']['api_proxy']` to support setting a proxy server for all asset -> Mondoo Platform communication. This value will be applied to new assets during registration and existing assets via the configuration file. This release also now depends on the line cookbook, which is used to manage entries in the configuration file.

## 0.5.0 (May 25th, 2022)

- switch to mondoo package and install cnquery + cnspec
- add example for Chef Workstation run

## 0.4.1 (May 25th, 2022)

- Add a CONTRIBUTING.md file
- Tag cookbook releases on GitHub

## 0.4.0 (March 23rd, 2022)

- Added support for AlmaLinux

## 0.3.0 (March 21st, 2022)

- Added support for SLES, openSUSE, Fedora, Rocky Linux, and Scientific Linux.
- Updated repository domains from mondoo.io to mondoo.com
- Expanded testing to include additional distros
- Added Docker-based testing with the Test Kitchen dokken plugin
- Added a SPDX compliant license string in the metadata.rb file
- Added source_url and issues_url values in the metadata.rb file
- Add a dedicated TESTING.md file
- Added a LICENSE file and licensing information to the README.md file

## 0.2.0

- Initial release on GitHub
