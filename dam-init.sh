#! /bin/bash

# ./dam-init.sh <USERNAME> <UID> <GUID> <CAPABILITIES>
if [ "$#" -ne 4 ]; then
    echo "./dam-init.sh <username> <uid> <gid> <capabilities>"
    exit 1
fi


DAM_USERNAME=$1
DAM_UID=$2
DAM_GID=$3
IFS=";"; DAM_CAPABILITIES=($4); unset IFS;

apt-get update
apt-get install sudo

# Create user $DAM_USERNAME with matching host UID and GID
useradd -m $DAM_USERNAME
usermod  --uid $DAM_UID $DAM_USERNAME
groupmod --gid $DAM_GID $DAM_USERNAME

# Enable sudo without asking for password for $DAM_USERNAME
mkdir -p /etc/sudoers.d
echo "$DAM_USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$DAM_USERNAME
chmod 0440 /etc/sudoers.d/$DAM_USERNAME

if [[ " ${DAM_CAPABILITIES[@]} " =~ " x " ]]; then
    apt-get install --yes x11-common
fi

if [[ " ${DAM_CAPABILITIES[@]} " =~ " pulse " ]]; then
    # Install pulseaudio-utils
    apt-get install --yes pulseaudio-utils
    # Add $DAM_USERNAME to audio group
    gpasswd -a $DAM_USERNAME audio
    # Create config file
    echo "default-server = unix:/run/user/$DAM_UID/pulse/native \
    autospawn = no \
    daemon-binary = /bin/true \
    enable-shm = false \
    " > /etc/pulse/client.conf
fi
