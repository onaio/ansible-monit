Monit
=====

Use this role to setup Monit.

Role Variables
--------------

You can monitor mount points and files using the `monit_system_mounts` variable:

```yaml
monit_system_mounts:
  rootfs: # Name of the Monit file system monitor
    path: "/" # The path to monitor
    thresholds: # List of utilization thresholds to measure against the path
      - value: "80%" # The threshold value
        operator: ">" # Operator for comparing against the threshold
        exec_scripts: # List of names of scripts in 'monit_exec_scripts' to run when threshold is crossed
          - slack-notification
    mount_check:
      enabled: true # Whether to check if the mount point is mounted
      test_file:
        path: "sys" # Relative path of the file, within the path being monitored, to check if exists
        type: "directory" # Type of file. Can be 'file' or 'directory'
      exec_scripts: # List of names of scripts in 'monit_exec_scripts' to execute if test file isn't found
        - slack-notification
        - opsgenie-notification
```

The load average is the number of processes in the system run queue per CPU core, averaged over the specified time period. You can monitor thresholds against a host's load average using the `monit_system_loadavg_thresholds` variable:

```yaml
monit_system_loadavg_thresholds:
  - period: "5min" # The period load is averaged. Can be '1min', '5min', and '15min'
    operator: ">" # The operator to use when comparing the load average against the threshold.
    value: "12" # The value of the threshold
    cycles: 4 # Number of Monit cycles the threshold should to be crossed before Monit takes action
    exec_scripts: # List of names of scripts in 'monit_exec_script' to execute when threshold is crossed after the number of cycles
      - slack-notification
```

You can monitor thresholds against a host's memory utilization using the `monit_system_memory_usage_thresholds` variable:

```yaml
monit_system_memory_usage_thresholds:
  - value: "90%" # The value of the threshold
    operator: ">" # the operator to use when comparing memory usage against the threshold
    cycles: 3 # The number of Monit cycles the threshold should be crossed before Monit takes action
    exec_scripts: # List of names of scripts in 'monit_exec_script' to execute when threshold is crossed after the number of cycles
      - slack-notification
```

You can monitor thresholds against a host's CPU utilization using the `monit_system_cpu_usage_thresholds` variable:

```yaml
monit_system_cpu_usage_thresholds:
  - type: user # Type of CPU utilization. Can be 'user' or 'system'
    value: "90%" # The value of the threshold
    operator: ">" # the operator to use when comparing memory usage against the threshold
    cycles: 3 # The number of Monit cycles the threshold should be crossed before Monit takes action
    exec_scripts: # List of names of scripts in 'monit_exec_script' to execute when threshold is crossed after the number of cycles
      - slack-notification
```

Define scripts Monit has access to (to run as monitors or actions to monitors):

```yaml
monit_exec_scripts:
  - name: "slack-notification" # The name of the script
    content: | # The script's content
  #!/bin/bash

  /usr/bin/curl \
    -X POST \
    -s \
    --data-urlencode "payload={ \
        \"channel\": \"#monit-notifications\", \
        \"username\": \"Monit\", \
        \"attachments\": [{\
            \"color\": \"warning\", \
            \"pretext\": \"$(hostname) | ${MONIT_DATE}\", \
            \"text\": \"${MONIT_SERVICE} - ${MONIT_DESCRIPTION}\" \
        }], \
        \"link_names\": 1 \
    }" \
    https://hooks.slack.com/services/secret-slack-endpoint
```

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
