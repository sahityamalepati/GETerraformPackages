[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2021-03-22

### Added

- Initial release of layer tested in POC kit
- This deploys an application gateway. This depends on the following layers: resourcegroup, networking. Requires manual upload of cert into key vault.

- Version 0.0.30 = Supports referencing a preexisting subnet not managed by terraform.
                   The previous logic understandably assumed the subnet would also be managed by terraform so it looked for the outputs of the networking layer (This applies to networkingsubnet too since it uses the same layer) to retrieve the subnet IDs
- Version 0.0.31 = Removed the resource_group_exists logic so that data lookups are always used.
                   The previous logic assumed that the resource group being referenced was retrievable by using the outputs of the resource group in the current pipeline, which doesn't work for ps-core-infra stage since the resource group is provisioned in dev
                 
