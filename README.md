# ansible-github-runner
[![Static Badge](https://img.shields.io/badge/Ansible_galaxy-Download-blue)](https://galaxy.ansible.com/ui/repo/published/compscidr/github_runner/)
[![ansible lint](https://github.com/compscidr/ansible-github-runner/actions/workflows/check.yml/badge.svg)](https://github.com/compscidr/ansible-github-runner/actions/workflows/check.yml)
[![ansible lint rules](https://img.shields.io/badge/Ansible--lint-rules%20table-blue.svg)](https://ansible.readthedocs.io/projects/lint/rules/)

Installs a github self hosted runner within a docker container.

This is done so we don't need to recreate the work done for
downloading, installing, configuring and running the runner
as a deamon directly on the host system.

We make use of: [https://github.com/myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner)
for a runner without java / android, or [https://github.com/compscidr/docker-github-actions-runner-android](https://github.com/compscidr/docker-github-actions-runner-android)
for a runner with java / android.

This is a collection instead of a role because it has a collection
dependency on the ansible community docker collection in order
to install the runner with a docker container.

## Usage
See the docs at [roles/github_runner](roles/github_runner) for more details

Add the collection to your meta/requirements.yml:
```
collections:
    - name: compscidr.github_runner
        version: "<insert version here>"
```

Install the collection:
```
ansible-galaxy install -r meta/requirements.yml
```

Use in a playbook:
```
---
- name: Github Runners
    hosts: some_hosts
    vars_files:
        - vars/some_vars.yml
    roles:
        - role: compscidr.github_runner.github_runner
            vars:
                github_runner_name: "some-runner-name"
                github_runner_java: true
                github_runner_install_docker: false
                github_runner_java_mount_usb: true
                github_runner_repo: "my_repo"
        - role: compscidr.github_runner.github_runner
            vars:
                github_runner_name: "some-org"
                github_runner_java: true
                github_runner_install_docker: false
                github_runner_java_mount_usb: true
                github_runner_org: true
                github_runner_org_name: "my-org"
```

# Variables
Variable                                | Description
--------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
github_runner_install_docker            | Set to true to install docker with the nickjj.docker role (defaults to true)
github_runner_personal_access_token     | GH personal access toke, see: https://github.com/myoung34/docker-github-actions-runner/wiki/Usage#token-scope for permissions needed
github_runner_name                      | the name for the runner (will show up in GH to differentiate runners)
github_runner_repo: user-name/repo      | the repo for the runner (ignored if an org runner)
github_runner_labels: self-hosted       | labels to attach to the runner (comma separated)
github_runner_org: false                | true for org runner, false for repo runner
github_runner_org_name: org name        | org name if an org runner, otherwise ignored
github_runner_java: false               | whether to use an android / java runner image or not
github_runner_java_mount_usb: false     | whether to mount usb (for instance if running tests on actual phones)
github_runner_java_image: compscidr/github-runner-android:latest | the java / android runner image
github_runner_non_java_image: myoung34/github-runner:latest | the non-java/android runner image
github_runner_env_file: false           | env file for passing extra environment variables into the runner container
github_runner_env_filename: ".env"      | the filename of the env file for passing extra environment variables into the container
github_runner_github_host: "github.com" | The GITHUB_HOST used for registering the runner.

Notes: the env file lets you do things like set site-specific credentials into the runner that can be built into the code
at build time, for instance, Wi-Fi credentials that can be built into tests that are specific to the location of
where the runner container is located.

## Testing
This collection uses [Molecule](https://molecule.readthedocs.io/) for testing with Docker containers.

### Local Testing (when galaxy.ansible.com is accessible)
```bash
# Install testing dependencies
pip install -r requirements-dev.txt

# Install required collections
ansible-galaxy collection install -r requirements.yml

# Run the complete test suite
molecule test
```

The tests will:
- Spin up a Docker container with Ubuntu 24.04 (using geerlingguy's ansible-enabled image)
- Run the `github_runner` role with test configuration
- Verify the role executes without errors

### Current CI Limitation
**Note:** Molecule tests are currently disabled in CI due to network restrictions preventing installation of the required `community.docker` collection from galaxy.ansible.com. The CI currently runs ansible-lint for syntax validation.

To run basic syntax validation:
```bash
ansible-lint roles/
```

## Inspiration
* [https://github.com/macunha1/ansible-github-actions-runner](https://github.com/macunha1/ansible-github-actions-runner)
* [https://github.com/buluma/ansible-collection-roles](https://github.com/buluma/ansible-collection-roles)
