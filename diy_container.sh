#!/bin/bash

set -e
set -u
set -o pipefail

CONTAINER_NAME=${1}
PROJECT=$(readlink -f ${PWD}/${CONTAINER_NAME})
if [[ -e $PROJECT ]] ; then
	echo "ERROR: $PROJECT already exists!"
	exit 1
fi
#
# Make an union file system which overlays the current OS root
#
mkdir $PROJECT
(cd $PROJECT ; mkdir lower upper workdir overlay) 
sudo mount -t overlay -o lowerdir=/,upperdir=$PROJECT/upper,workdir=$PROJECT/workdir none $PROJECT/overlay

#
# make the kernel virtual file systems needed by programs like 'ps'
#
(cd $PROJECT/overlay; mkdir -p proc sysfs dev/shm dev/pts)
sudo mount -t proc proc $PROJECT/overlay/proc
sudo mount -t sysfs sysfs $PROJECT/overlay/sysfs
sudo mount -t devtmpfs devtmpfs $PROJECT/overlay/dev
sudo mount -t tmpfs tmpfs $PROJECT/overlay/dev/shm
sudo mount -t devpts devpts $PROJECT/overlay/dev/pts

#
# Link to mtab
#
sudo chroot $PROJECT/overlay rm /etc/mtab 2> /dev/null 
sudo chroot $PROJECT/overlay ln -s /proc/mounts /etc/mtab

echo "Command to access the container is:"
echo "    sudo chroot $PROJECT/overlay /bin/bash"
