[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2021-03-22

### Added

- Initial release of layer tested in POC kit
- This deploys a storage account plus containers, blobs, etc. This depends on the following layers: keyvault, adoprivateendpoints

- Version 0.0.23 =  default value for persist_access_key is false
- So long as ado_resource_group_name, ado_vnet_name and ado_subnet_name variables are supplied and correspond to the agent subnet, the subnet id will be added to default_rules so the agents don't lose the ability to make subsequent REST calls to a Storage Account with the default_action set to "Deny"