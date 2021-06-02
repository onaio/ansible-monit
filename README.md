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

You can monitor IPSEC connections using the `monit_ipsec_hosts` variable:

```yaml
monit_ipsec_hosts:
  - name: ipsec_orange  # name of the IPSEC connection
    address: "10.123.23.2"  # the IPv4, IPv6 or hostname to ping to
    port: 9999  # port to connect to
    type: TCP  # either TCP or UDP
    exec_scripts:  # list of names of scripts to execute when ping fails
      - opsgenie-notification
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

If monitoring PostgreSQL, set thresholds for number of slow queries, slow query time, and number of connection thresholds using:

```yaml
monit_postgresql_number_slow_queries_threshold: 1 # Number of queries that if deemed as slow, health check fails
monit_postgresql_number_slow_query_min_time: "1 minute" # Time above which a running query will be deemed as slow
monit_postgresql_number_connections_threshold: 0.9 # Ratio of maximum number of PostgreSQL connections which if the number of active connections is crossed, the health check fails
```

Make sure to also add `postgres` to the `monit_scripts` list.

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
