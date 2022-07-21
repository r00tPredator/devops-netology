Install Prometheus
=========

Install and configure Prometheus on Centos 7

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable           | Type   | Default value | Possible values |
|--------------------|--------|---------------|-----------------|
| prometheus_version | string | "2.36.2"      |                 |
| prometheus_proxy   | string |               |                 |
| prometheus_cpu     | string | "2"           |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - install-prometheus

License
-------

MIT
