path '/home/ec2-user/.ssh/config'
profiles 'default'
regions 'ap-northeast-1'

# You can specify filters on DescribeInstances (default: lists 'running' instances only)
filters([
  { name: 'tag:Name', values: ['rails-structured-logging-production:ec2:app'] },
  { name: 'instance-state-name', values: ['running'] }
])

# You can use methods of AWS::EC2::Instance and tag(key) method.
# See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html
host_line(<<~END)
  Host <%= tag('HostName').gsub(':INSTANCE_ID:', instance_id) %>
    HostName <%= private_ip_address %>
    IdentityFile ~/.ssh/rails-structured-logging.pem
END
