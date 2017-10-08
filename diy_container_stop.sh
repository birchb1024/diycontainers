#!/bin/bash
set -e
set -u
set -x
set -o pipefail

PROJECT=$(readlink -f ${PWD}/${1})
if [[ ! -e $PROJECT ]] ; then
        echo "ERROR: $PROJECT does not exist!"
        exit 1
fi

set +e
sudo umount $PROJECT/overlay/proc
sudo umount $PROJECT/overlay/sysfs
sudo umount $PROJECT/overlay/dev/shm
sudo umount $PROJECT/overlay/dev/pts
sudo umount $PROJECT/overlay/dev
sudo umount $PROJECT/overlay


