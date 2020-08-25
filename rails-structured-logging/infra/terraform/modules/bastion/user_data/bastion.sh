#!/bin/bash

# Set hostname
# @see http://xoxo-infra.hatenablog.com/entry/2013/06/24/230334
HOSTNAME="${hostname}"
NETWORK_CONFIG=/etc/sysconfig/network

/bin/cp -p $${NETWORK_CONFIG} $${NETWORK_CONFIG}.`date -I`
/bin/sed -e 's/HOSTNAME/#HOSTNAME/g' -e '/#HOSTNAME/a\HOSTNAME='$${HOSTNAME}'' $${NETWORK_CONFIG}.`date -I` > $${NETWORK_CONFIG}
/bin/hostname $${HOSTNAME}

# Change prompt to display full hostname
# @see https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-hostname.html#set-hostname-shell
SYSTEM_BASHRC=/etc/bashrc
/bin/cp -p $${SYSTEM_BASHRC} $${SYSTEM_BASHRC}.`date -I`
/bin/sed -e 's/\[\\u@\\h \\W\]/\[\\u@\\H \\W\]/g' $${SYSTEM_BASHRC}.`date -I` > $${SYSTEM_BASHRC}

# Set SSH port
# @see https://dev.classmethod.jp/server-side/os/how-to-change-ssh-default-port-using-user-data/
/bin/sed -i -e 's/^#Port 22$/Port ${ssh_port}/' /etc/ssh/sshd_config
service sshd restart

exit
