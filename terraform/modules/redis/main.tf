resource "aws_elasticache_subnet_group" "redis" {
  name = var.redis-name
  subnet_ids = [ var.redis-subnet-1, var.redis-subnet-2 ]
}

resource "aws_elasticache_cluster" "misago" {
  cluster_id = var.redis-name
  engine = var.redis-engine
  node_type = var.redis-node-type
  port = 6379
  num_cache_nodes = 1
  engine_version = var.redis-engine-version
  subnet_group_name = aws_elasticache_subnet_group.redis.name
}