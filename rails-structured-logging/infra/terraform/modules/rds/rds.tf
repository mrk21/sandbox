resource "aws_db_subnet_group" "main" {
  name       = local.base_name
  subnet_ids = [for subnet in local.public_subnets : subnet.id]

  tags = {
    Name = "${local.base_name}:subgrp:main"
    App  = local.app
    Env  = local.env
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${local.base_name}-aurora-5-7"
  family = "aurora-mysql5.7"

  tags = {
    Name = "${local.base_name}:pg:main"
    App  = local.app
    Env  = local.env
  }
}

resource "aws_rds_cluster_parameter_group" "main" {
  name   = "${local.base_name}-aurora-5-7-cluster"
  family = "aurora-mysql5.7"

  tags = {
    Name = "${local.base_name}:cpg:main"
    App  = local.app
    Env  = local.env
  }

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "binary"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier              = local.base_name
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"
  master_username                 = data.aws_ssm_parameter.rds_user.value
  master_password                 = data.aws_ssm_parameter.rds_password.value
  backup_retention_period         = 1
  preferred_backup_window         = "19:30-20:00"
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  port                            = 3306
  vpc_security_group_ids          = [local.security_group.rds.id]
  db_subnet_group_name            = aws_db_subnet_group.main.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
  deletion_protection             = false
  skip_final_snapshot             = true

  tags = {
    Name = "${local.base_name}:db:main"
    App  = local.app
    Env  = local.env
  }
}

resource "aws_rds_cluster_instance" "default" {
  count = 1

  identifier           = "${local.base_name}-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.main.id
  engine               = "aurora-mysql"
  engine_version       = "5.7.12"
  instance_class       = "db.t3.small"
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "${local.base_name}:db-cluster-instance:main"
    App  = local.app
    Env  = local.env
  }
}

data "aws_ssm_parameter" "rds_user" {
  name = local.ssm_params.rds.user.name
}

data "aws_ssm_parameter" "rds_password" {
  name = local.ssm_params.rds.password.name
}
