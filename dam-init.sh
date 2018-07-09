#! /bin/sh

# ./dam-init.sh USERNAME UID GID
if [ "$#" -ne 3 ]; then
    echo "./dam-init.sh <username> <uid> <gid>"
    exit 1
fi

UNAME=$1
UID=$2
GID=$3
useradd -m $UNAME
usermod  --uid $UID $UNAME
groupmod --gid $GID $UNAME

mkdir -p /etc/sudoers.d
echo "$UNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$UNAME
chmod 0440 /etc/sudoers.d/$UNAME
gpasswd -a $UNAME audio

echo "default-server = unix:/run/user/$UID/pulse/native
autospawn = no
daemon-binary = /bin/true
enable-shm = false
" > /etc/pulse/client.conf