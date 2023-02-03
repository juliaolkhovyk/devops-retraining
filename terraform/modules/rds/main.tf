resource "random_string" "postgres_password" {
  length  = 12
  upper   = true
  numeric = true
  special = false
}

resource "aws_db_subnet_group" "rds-private-subnet" {
    name = "rds-private-subnet-group"
    subnet_ids = [var.rds_subnet_1, var.rds_subnet_2]
}

resource "aws_security_group" "postgres" {
  name = "postgres security group"
  vpc_id = var.vpc_id
  ingress =  [{
    description = "random"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    self = true
    security_groups = []
    }]


}

resource "aws_db_instance" "postgres" {
    allocated_storage = var.allocated_storage
    engine = var.engine
    engine_version = var.engine_version
    identifier = var.identifier
    instance_class = var.instance_class
    multi_az = false
    db_name = var.db_name
    password = random_string.postgres_password.result
    port = 5432
    username = var.username
    db_subnet_group_name = aws_db_subnet_group.rds-private-subnet.name
    vpc_security_group_ids = [aws_security_group.postgres.id]
    skip_final_snapshot = true

}