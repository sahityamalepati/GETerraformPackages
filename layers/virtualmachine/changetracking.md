[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2021-03-22

### Added

- Initial release of layer tested in POC kit
- Deploy Linux virtual machines from gallery image or Customer custom image via virtualmachine.tf sourceimage. Requires a preexisting boot diagnostic storage account in same RG and Key vault for SSH storage in same RG, or the creation of the SA and KV must be part of the pipeline.


Version 0.0.1 = Deploy Linux virtual machines from gallery image or Customer custom image via virtualmachine.tf sourceimage. Requires a preexisting boot diagnostic storage account in same RG and Key vault for SSH storage in same RG, or the creation of the SA and KV must be part of the pipeline.
Version 0.0.13 = Added Proxy Placement Group support
Version 0.0.18 = Added support for central placement of the boot diagnostic and key vault in different resource groups.
Version 0.0.36 = Added support for the use of existing ASGs in different resource groups.

