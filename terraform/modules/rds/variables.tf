variable "rds_subnet_1" {
  type = string
}

variable "rds_subnet_2" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "engine" {
  type = string

}

variable "engine_version" {
  type = string
}

variable "identifier" {
  type = string
}

variable "username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  
}