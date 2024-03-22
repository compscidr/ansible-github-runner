# ansible-github-runner
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

## Testing
Using a clean slate vagrant ubuntu vm from the vagrant folder run `vagrant up` and then
use `vagrant ssh` to get into the machine, then `ansible-playbook playbooks/github_actions.yml`

If changes are made, you can re-run: `ansible-galaxy collection build --force` and
`ansible-galaxy collection install *tar.gz --force`

## Inspiration
* [https://github.com/macunha1/ansible-github-actions-runner](https://github.com/macunha1/ansible-github-actions-runner)
* [https://github.com/buluma/ansible-collection-roles](https://github.com/buluma/ansible-collection-roles)