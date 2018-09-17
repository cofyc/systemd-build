#!/bin/bash

mkdir -p bind-test/abc
mount --bind bind-test bind-test
mount -t tmpfs tmpfs bind-test/abc
systemctl list-units --all | grep bind-test # Observe that the bind-test/abc mount unit is inactive

# One consequence here is that unmounting bind-test/abc does not clean up the bind-test/abc mount unit:
umount bind-test/abc
if systemctl list-units --all | grep bind-test | grep abc; then
    echo "issue 7798 exist"
else
    echo "issue 7798 does not exist"
fi
umount bind-test
rm -rf bind-test
