# Changelog

## [0.1.6] - 2026-08-20
### Added
- `github_runner_mount_docker_socket` (default `true`): whether to mount the host's `/var/run/docker.sock` into the runner container. Set to `false` for runners whose CI jobs never use docker — it drops a root-equivalent privilege, and on a desktop host it guarantees the runner's jobs can't churn veth interfaces (each add/remove aborts in-flight Chrome requests on that host with `ERR_NETWORK_CHANGED`).
- `no-docker-socket` molecule scenario verifying the runner converges without the socket bind.

## [0.1.5] - 2026-08-12
### Fixed
- The deploy no longer replaces a runner container while its runner is mid-job (which destroyed the CI job: GitHub waits out the runner heartbeat ~10 min, then fails every remaining step). When a replace is imminent — new image digest or config change — and the existing runner is busy, the role now polls the GitHub runners API until the runner is idle before replacing, failing the deploy loudly on timeout instead of killing the job. The busy-check fails loudly on a paginated (>100 runners) listing, treats malformed/rate-limited API responses as still-waiting, and clamps the poll interval to >=1s.

### Added
- `github_runner_drain_before_replace` (default `true`), `github_runner_drain_timeout_minutes` (default `45`), `github_runner_drain_poll_seconds` (default `30`): drain-before-replace guard configuration.
- `github_runner_force_replace` (default `false`): emergency override — replace immediately even if a job is mid-flight.
- `github_runner_api_base`: GitHub API base for the busy-check, derived for github.com and GHES.

### Changed
- The image pull is now a separate `docker_image_pull` task and the container task runs with `pull: false`; behavior is unchanged (a new digest still triggers the replace via image-ID comparison), but the pull result now feeds the drain guard. Requires `community.docker` >= 3.6.0.

## [0.1.4] - 2026-08-10
### Fixed
- First playbook run no longer fails with `UnixHTTPConnectionPool ... Read timed out (read timeout=60)` when replacing an existing runner container. Stopping and removing a crash-looping or wedged runner can exceed the Docker SDK's 60s default client timeout; the daemon finished the removal in the background, which is why an immediate rerun succeeded.

### Added
- `github_runner_docker_timeout` (default `180`): Docker API client timeout for the deploy task.
- `github_runner_stop_timeout` (default `10`): seconds docker waits after SIGTERM before SIGKILL when stopping the runner container.

## [0.1.3] - 2026-05-27
### Added
- Added `github_runner_network_mode` variable (defaults to `default`) to control the runner container's Docker network mode. Set to `host` so the in-container `adb` client can reach an adb server running on the host at `127.0.0.1:5037`.
- Added `android-runner-host` molecule scenario verifying host networking converges, is idempotent, and publishes no ports.

### Changed
- ADB port mapping is now omitted automatically when `github_runner_network_mode` is `host`, since `ports:` is invalid together with `network_mode: host`.

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