output "redis-host" {
  value = aws_elasticache_cluster.misago.cache_nodes.0.address
}