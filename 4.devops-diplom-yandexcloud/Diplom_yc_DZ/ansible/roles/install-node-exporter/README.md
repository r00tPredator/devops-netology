Install node_exporter
=========

Install and configure node_exporter on CentOS 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable                | Type   | Default value | Possible values |
|-------------------------|--------|---------------|-----------------|
| node_exporter_version   | string | "1.3.1"       |                 |
| node_exporter_proxy     | string |               |                 |
| node_exporter_open_port | bool   | no            | yes, no         |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - preconfigure

License
-------

MIT
