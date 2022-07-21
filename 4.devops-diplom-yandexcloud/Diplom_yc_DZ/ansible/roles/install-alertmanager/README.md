Install alermanager
=========

Installing alertmanager on CentOS 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable             | Type   | Default value | Possible values |
|----------------------|--------|---------------|-----------------|
| alertmanager_version | string | "0.24.0"      |                 |
| alertmanager_proxy   | string |               |                 |
| alertmanager_cpu     | string | "2"           |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-alertmanager

License
-------

MIT
