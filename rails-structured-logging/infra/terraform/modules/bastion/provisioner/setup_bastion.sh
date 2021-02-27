#!/bin/bash +x

## Set key
chmod 600 /home/ec2-user/.ssh/rails-structured-logging.pem

## Install ec2ssh
sudo amazon-linux-extras install -y ruby2.6
gem install ec2ssh
/home/ec2-user/bin/ec2ssh init
/home/ec2-user/bin/ec2ssh update
/home/ec2-user/bin/ec2ssh shellcomp >> /home/ec2-user/.bash_profile
echo "*/5 * * * * /bin/bash -c '/home/ec2-user/bin/ec2ssh update'" | crontab
sudo yum install -y bash-completion
