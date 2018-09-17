#!/bin/bash

before=$(ls /sys/fs/cgroup/systemd/system.slice/*.scope -d|wc -l)

# If scope units are created quickly, it has change empty cgroup message will
# not be received by cgroups-agent.  See
# https://github.com/systemd/systemd/pull/3191
for ((i=0; i < 100; i++)); do
    systemd-run --scope -- "true"
done

sleep 1 # give systemd some time to clean
after=$(ls /sys/fs/cgroup/systemd/system.slice/*.scope -d|wc -l)

echo "before: $before"
echo "after: $after"
