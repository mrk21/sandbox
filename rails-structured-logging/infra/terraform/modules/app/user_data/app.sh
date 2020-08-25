#!/bin/bash

# Set hostname
# @see http://xoxo-infra.hatenablog.com/entry/2013/06/24/230334
INSTANCE_ID=$(curl 'http://169.254.169.254/latest/meta-data/instance-id')
HOSTNAME="$(echo ${hostname} | sed -e "s/:INSTANCE_ID:/$${INSTANCE_ID}/g")"
NETWORK_CONFIG=/etc/sysconfig/network

/bin/cp -p $${NETWORK_CONFIG} $${NETWORK_CONFIG}.`date -I`
/bin/sed -e 's/HOSTNAME/#HOSTNAME/g' -e '/#HOSTNAME/a\HOSTNAME='$${HOSTNAME}'' $${NETWORK_CONFIG}.`date -I` > $${NETWORK_CONFIG}
/bin/hostname $${HOSTNAME}

# Change prompt to display full hostname
# @see https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-hostname.html#set-hostname-shell
SYSTEM_BASHRC=/etc/bashrc
/bin/cp -p $${SYSTEM_BASHRC} $${SYSTEM_BASHRC}.`date -I`
/bin/sed -e 's/\[\\u@\\h \\W\]/\[\\u@\\H \\W\]/g' $${SYSTEM_BASHRC}.`date -I` > $${SYSTEM_BASHRC}

# Set ECS Cluster
echo ECS_CLUSTER=${ecs_cluster} >> /etc/ecs/ecs.config

exit
