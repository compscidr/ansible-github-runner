# Changelog

## [0.1.0] - 2025-11-12
### Breaking Changes
- Removed `github_runner_install_docker` variable and Docker installation task
- Removed dependency on `nickjj.docker` role - Docker must now be pre-installed on target systems

### Added
- Added `github_runner_android` variable (defaults to false) to identify Android runners
- Added `github_runner_android_expose_adb_ports` variable (defaults to false) to control ADB port exposure
- Support for Ubuntu 24.04 (Noble)

### Changed
- Consolidated 12 separate deployment tasks into a single task using conditional parameters
- Refactored task configuration to use `omit` filter for cleaner conditional logic
- Ports are no longer exposed by default for Java/Android runners
- ADB ports (5037) only exposed when both `github_runner_android` and `github_runner_android_expose_adb_ports` are true
- Updated documentation to reflect new variables and configuration options

### Improved
- Significantly improved maintainability by reducing task duplication
- Cleaner role configuration with dynamic parameter assignment

## Previous
- bringing things up to par with modern lint