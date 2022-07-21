Install Squid
=========

Install and configure Squid on CentOS 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable           | Type   | Default value | Possible values |
|--------------------|--------|---------------|-----------------|
| squid_port         | string | '3128'        |                 |
| squid_ip           | string | ''            |                 |
| squid_allowed_list | string | []            |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-squid

License
-------

MIT
