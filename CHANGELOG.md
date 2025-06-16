# Changelog

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-alerts/compare/v1.2.0...v2.0.0) (2025-06-16)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* small refactor ([#16](https://github.com/CloudNationHQ/terraform-azure-alerts/issues/16)) ([5082194](https://github.com/CloudNationHQ/terraform-azure-alerts/commit/50821940f6a33a5c7185bb895602fbf321bd7e3f))

### Upgrade from v1.2.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`
- The property and variable resource_group is renamed to resource_group_name
- The submodule is renamed to monitor-workspace

Details can be found in the example usages

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-alerts/compare/v1.1.0...v1.2.0) (2025-03-19)


### Features

* add enabled option for monitor alert processing rule action groups ([#13](https://github.com/CloudNationHQ/terraform-azure-alerts/issues/13)) ([adb83cd](https://github.com/CloudNationHQ/terraform-azure-alerts/commit/adb83cdda9cdfa358bdb49a188813e8c39110949))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-alerts/compare/v1.0.1...v1.1.0) (2025-01-21)


### Features

* small refactor tests ([#7](https://github.com/CloudNationHQ/terraform-azure-alerts/issues/7)) ([56b82c4](https://github.com/CloudNationHQ/terraform-azure-alerts/commit/56b82c4adcd948012e0c808066f54f5af9e4fee0))

## [1.0.1](https://github.com/CloudNationHQ/terraform-azure-alerts/compare/v1.0.0...v1.0.1) (2024-10-28)


### Bug Fixes

* remove the provider in modules ([#5](https://github.com/CloudNationHQ/terraform-azure-alerts/issues/5)) ([2300953](https://github.com/CloudNationHQ/terraform-azure-alerts/commit/2300953d7c895e61a6e0f3a91b5b786c87c9d715))

## 1.0.0 (2024-10-15)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-alerts/issues/2)) ([40d54f9](https://github.com/CloudNationHQ/terraform-azure-alerts/commit/40d54f93017a20ba8f8c409ac3e9ae03b6cdd5fa))
