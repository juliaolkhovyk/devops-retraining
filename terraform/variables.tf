variable "region" {
  type = string
  default = "eu-central-1"
}

################################## VPC variables ##########################
variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}


variable "vpc_name" {
    type = string
    default = "vpc"
}

variable "public_subnets" {
    type = list(string)
    default = ["10.0.4.0/24"]
}

variable "private_subnets" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "instance_count" {
  type = number
  default = 1
}

variable "cluster_name" {
  type = string
  default = "demo"
}




#################### RDS variables ###############################

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "10"
}

variable "db_name" {
  default = "misago"
}

variable "identifier" {
  default = "misago"
}

variable "allocated_storage" {
  default = 5
}

variable "instance_class" {
  type = string
  default = "db.t2.micro"
}

variable "username" {
  type = string
  default = "misago"
}



###################### Redis ########################
variable "redis-name" {
  type = string
  default = "misago-redis"
}

variable "redis-engine" {
  type = string
  default = "redis"
}

variable "redis-node-type" {
  type = string
  default = "cache.t2.micro"
}

variable "redis-engine-version" {
  type = string
  default = "5.0.3"
}

variable "eks_instance_type" {
  type = string
  default = "t2.micro"
}