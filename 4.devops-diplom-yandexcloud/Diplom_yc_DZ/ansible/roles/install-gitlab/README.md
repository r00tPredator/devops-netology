Install GitLab
=========

Install and preconfigure GitLab on CentOS 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable                                         | Type   | Default value | Possible values |
|--------------------------------------------------|--------|---------------|-----------------|
| gitlab_initial_root_password                     | string |               |                 |
| gitlab_initial_shared_runners_registration_token | string |               |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-gitlab

License
-------

MIT
