[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2021-03-22

### Added

- Initial release of layer tested in POC kit
- This deploys a Windows virtual machine scale set. This depends on the following layers: networking, loadbalancer, storage, keyvault, adoprivateendpoints, applicationsecuritygroup

- Version 0.0.14 = layer has been updated to support the use the exiting ASGs residing in the different resource groups than the VMSS