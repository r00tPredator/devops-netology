acme.sh make certs
=========

Create and install certificates with acme.sh

Requirements
------------

No specific requirements

Role Variables
--------------

| Variable       | Type   | Default value     | Possible values |
|----------------|--------|-------------------|-----------------|
| acme_domain    | string |                   |                 |
| acme_resources | list   |                   |                 |
| acme_server    | string | 'letsencrypttest' |                 |

Dependencies
------------

No specific dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - acme_sh-make-certs

License
-------

MIT
