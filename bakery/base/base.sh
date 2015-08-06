#!/bin/bash -e
#
# Skeleton for a base packing effort. Add users, logging, monitoring, etc. -
# all the things that should have global presence.

#TODO username is hardcoded in local wrapper and base
username='ii4b'

# Add the user, join sudo group, and configure NOPASSWD
sudo adduser --disabled-password --gecos "" $username
sudo usermod -aG sudo $username # For easy sudo privs
# Don't do this in production
sudo su -c "echo \"$username ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers.d/91-ii4b-init-users"

# Create .ssh, copy the key, fix permissions
sudo mkdir -p /home/$username/.ssh
sudo cp -f /tmp/base/keys/${username}.pub /home/$username/.ssh/authorized_keys
sudo chown -R $username:$username /home/$username/.ssh
sudo chmod 0700 /home/$username/.ssh
