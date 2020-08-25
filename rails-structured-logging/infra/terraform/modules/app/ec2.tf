resource "aws_launch_configuration" "app" {
  name                        = "${local.base_name}-app"
  image_id                    = "ami-03003e0e2f7489bfa"
  instance_type               = "t3.micro"
  security_groups             = [local.security_group.app.id]
  key_name                    = local.key_pair.key_name
  user_data                   = data.template_file.user_data_app.rendered
  iam_instance_profile        = local.instance_profile.app.name
  associate_public_ip_address = true
}

data "template_file" "user_data_app" {
  template = file("${path.module}/user_data/app.sh")

  vars = {
    hostname    = "app-:INSTANCE_ID:.${local.base_name}.local"
    ecs_cluster = aws_ecs_cluster.app.name
  }
}

resource "aws_autoscaling_group" "app" {
  name                 = "${local.base_name}-app"
  min_size             = 2
  max_size             = 2
  force_delete         = true
  launch_configuration = aws_launch_configuration.app.name
  vpc_zone_identifier  = local.public_subnets[*].id

  tags = [
    {
      key                 = "Name"
      value               = "${local.base_name}:ec2:app"
      propagate_at_launch = true
    },
    {
      key                 = "App"
      value               = local.app
      propagate_at_launch = true
    },
    {
      key                 = "Env"
      value               = local.env
      propagate_at_launch = true
    },
    {
      key                 = "Role"
      value               = "app"
      propagate_at_launch = true
    },
    {
      key                 = "HostName"
      value               = "app-:INSTANCE_ID:.${local.base_name}.local"
      propagate_at_launch = true
    }
  ]
}
