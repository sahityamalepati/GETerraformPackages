[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2021-03-22

### Added

- Initial release of layer tested in POC kit
- This deploys an Azure DevOps (ADO) private endpoint. This layer depends on the ADO RG (DevOps onboarding RG) and the service to which you want to create a PE, such as Key Vault, Storage Account, etc.


- Version 0.0.12 = Private endpoint layer has been updated to optionally create the dns a records. A new bool parameter (named "create_dns_record") has been added. The value of "create_dns_record" should be set to "true" in tfvars file to create the dns a records.