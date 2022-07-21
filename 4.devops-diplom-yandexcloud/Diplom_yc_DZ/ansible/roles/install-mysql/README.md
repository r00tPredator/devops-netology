Install MySQL
=========

Install MySQL on CentOS 7 and configure master-slave replication

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable               | Type   | Default value | Possible values |
|------------------------|--------|---------------|-----------------|
| mysql_root_pass        | string |               |                 |
| mysql_replication_user | string |               |                 |
| mysql_replication_pass | string |               |                 |
| mysql_master_ip        | string |               |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-mysql

License
-------

MIT
