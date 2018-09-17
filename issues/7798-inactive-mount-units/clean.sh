#!/bin/bash
#
# This script is run to clean old scopes after fix is done.
#

cd /sys/fs/cgroup/systemd/system.slice/

for scope in $(ls -d *.scope); do
    procs=$(cat $scope/cgroup.procs | wc -l)
    printf "%d processes found in scope %s\n" "$procs" "$scope"
    if [[ $procs -eq 0 ]]; then
        echo systemctl stop $scope
        systemctl stop $scope
    fi
done
