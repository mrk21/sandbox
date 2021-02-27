resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.base_name}-main"
  subnet_ids = [for subnet in local.public_subnets : subnet.id]
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${local.base_name}-main"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [local.security_group.elasticache.id]
}
