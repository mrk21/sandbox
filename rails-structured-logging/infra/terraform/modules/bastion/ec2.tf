resource "aws_instance" "bastion" {
  ami                    = "ami-0cc75a8978fbbc969"
  instance_type          = "t3.nano"
  subnet_id              = local.public_subnet.id
  vpc_security_group_ids = [local.security_group.bastion.id]
  key_name               = local.key_pair.key_name
  user_data              = data.template_file.user_data_bastion.rendered
  iam_instance_profile   = local.instance_profile.bastion.name

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      port        = 22
      private_key = data.aws_ssm_parameter.private_key.value
    }

    content     = data.aws_ssm_parameter.private_key.value
    destination = "/home/ec2-user/.ssh/rails-structured-logging.pem"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      port        = 22
      private_key = data.aws_ssm_parameter.private_key.value
    }
    source      = "${path.module}/provisioner/bastion_ec2ssh.rb"
    destination = "/home/ec2-user/.ec2ssh"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      port        = 22
      private_key = data.aws_ssm_parameter.private_key.value
    }
    source      = "${path.module}/provisioner/setup_bastion.sh"
    destination = "/tmp/setup_bastion.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      port        = 22
      private_key = data.aws_ssm_parameter.private_key.value
    }
    inline = [
      "chmod +x /tmp/setup_bastion.sh",
      "/tmp/setup_bastion.sh",
    ]
  }

  tags = {
    Name = "${local.base_name}:ec2:bastion"
    App  = local.app
    Env  = local.env
    Role = "bastion"
  }
}

data "template_file" "user_data_bastion" {
  template = file("${path.module}/user_data/bastion.sh")

  vars = {
    hostname = "bastion.${local.base_name}.local"
    ssh_port = 22
  }
}

data "aws_ssm_parameter" "private_key" {
  name = local.ssm_params.private_key.name
}
