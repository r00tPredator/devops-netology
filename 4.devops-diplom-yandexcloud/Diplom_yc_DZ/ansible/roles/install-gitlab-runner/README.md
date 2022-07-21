Install gitlab-runner
=========

Install and register gitlab-runner on CentOS 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable                         | Type   | Default value        | Possible values |
|----------------------------------|--------|----------------------|-----------------|
| gitlab_runner_coordinator_url    | string | "https://gitlab.com" |                 |
| gitlab_runner_tags               | list   | []                   |                 |
| gitlab_runner_executor           | string | "shell"              |                 |
| gitlab_runner_registration_token | string |                      |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-gitlab-runner

License
-------

MIT
