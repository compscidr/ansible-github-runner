# github_runner Role

## Requirements
- Docker must be installed on the target system
- Depends on the community.docker collection in order to deploy and manage the docker containers.
  Install with `ansible-galaxy install -r requirements.yml`

## Config
See roles/github_runner/defaults/main.yml for all available configuration variables.

### Java / Android runner or Not
By default, the android / java runner is disabled with `github_runner_java`. If you would like the
runner to come withjava / android installed, so your GH actions don't need to run an install task every run,
you can toggle this on. Note, the image is much larger, so it will take some time to deploy.

### Org runners and Repo Runners
If the `github_runner_org` variable is true, `github_runner_org_name` must be set to the organization
of the runner. `github_runner_repo` is not used when `github_runner_org` is set. If it is not set,
the `github_runner_repo` must be set to the `username/repo` that the runner should be used for.

## Usage
See [playbooks/github-actions.yml](playbooks/github-actions.yml) for an example of how to deploy multiple
runners at once. There are examples of no java / android, one with java / android, and one which is an org
runner.