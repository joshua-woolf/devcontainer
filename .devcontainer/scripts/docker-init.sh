#!/bin/bash

set -e

mount -t securityfs none /sys/kernel/security
mount -t tmpfs none /tmp
mkdir -p /sys/fs/cgroup/init

xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs

( dockerd > /tmp/dockerd.log 2>&1 ) &
