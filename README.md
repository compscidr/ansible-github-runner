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
                github_runner_java_mount_usb: true
                github_runner_repo: "my_repo"
        - role: compscidr.github_runner.github_runner
            vars:
                github_runner_name: "some-org"
                github_runner_java: true
                github_runner_java_mount_usb: true
                github_runner_org: true
                github_runner_org_name: "my-org"
```

# Variables
Variable                                    | Description
------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
github_runner_personal_access_token         | GH personal access toke, see: https://github.com/myoung34/docker-github-actions-runner/wiki/Usage#token-scope for permissions needed
github_runner_name                          | the name for the runner (will show up in GH to differentiate runners)
github_runner_repo                          | the repo for the runner in format "user-name/repo" (ignored if an org runner)
github_runner_labels                        | labels to attach to the runner (comma separated, defaults to "self-hosted")
github_runner_org                           | true for org runner, false for repo runner (defaults to false)
github_runner_org_name                      | org name if an org runner, otherwise ignored
github_runner_java                          | whether to use an android / java runner image or not (defaults to false)
github_runner_java_mount_usb                | whether to mount usb devices (for instance if running tests on actual phones, defaults to false)
github_runner_android                       | whether this is an android runner (defaults to false)
github_runner_android_expose_adb_ports      | whether to expose ADB ports for android runners (defaults to false, requires github_runner_android to be true)
github_runner_adb_port                      | the host port to map ADB to (defaults to 5037)
github_runner_java_image                    | the java / android runner image (defaults to compscidr/github-runner-android:latest)
github_runner_non_java_image                | the non-java/android runner image (defaults to myoung34/github-runner:latest)
github_runner_env_file                      | whether to use an env file for passing extra environment variables into the runner container (defaults to false)
github_runner_env_filename                  | the filename of the env file for passing extra environment variables into the container (defaults to ".env")
github_runner_github_host                   | The GITHUB_HOST used for registering the runner (defaults to "github.com")

Notes: the env file lets you do things like set site-specific credentials into the runner that can be built into the code
at build time, for instance, Wi-Fi credentials that can be built into tests that are specific to the location of
where the runner container is located.

## Testing
Using a clean slate vagrant ubuntu vm from the vagrant folder run `vagrant up` and then
use `vagrant ssh` to get into the machine, then `ansible-playbook playbooks/github_actions.yml`

If changes are made, you can re-run: `ansible-galaxy collection build --force` and
`ansible-galaxy collection install *tar.gz --force`

## Inspiration
* [https://github.com/macunha1/ansible-github-actions-runner](https://github.com/macunha1/ansible-github-actions-runner)
* [https://github.com/buluma/ansible-collection-roles](https://github.com/buluma/ansible-collection-roles)
