Monit
=====

Use this role to setup Monit.

Role Variables
--------------

Check [./defaults/main.yml](./defaults/main.yml) for default values for Ansible variables.

Example Playbook
----------------

Playbook to setup Monit might look like:

    - name: Setup Monit
      hosts: all
          monit_scripts: ["monit", "nginx"]
          monit_setup_mode: True
      roles:
        - role: monit

License
-------

This project is released under the Apache 2 license. Read the [LICENSE.txt](./LICENSE.txt) file for more details.

Authors
-------

Update by [Ona Engineering](https://ona.io)
