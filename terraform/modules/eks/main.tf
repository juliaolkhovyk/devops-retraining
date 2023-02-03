data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version = "17.1.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = "1.24"
  subnets                         = var.private_subnets
  cluster_endpoint_private_access = true
  vpc_id                          = var.vpc_id
  worker_groups = [
    {
      name                         = "worker-group"
      instance_type                = var.instance_type
      asg_desired_capacity         = 2
      asg_min_size = 1
      asg_max_size = 3
      tags = [{
        key = "worker-group-tag"
        value = "worker-group-1"
        propagate_at_launch = true
      }]
    }
  ]

    map_users = [{
    userarn = "arn:aws:iam::646248791052:user/juliaolkhovyk"
    username = "juliaolkhovyk"
    groups = ["system:masters"]
  },
  ]

}


provider "kubernetes" {
    host = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    
} 

#resource "null_resource" "generate_kubeconfig" {
#  provisioner "local-exec" {
#    command = "aws eks update-kubeconfig --name ${var.cluster_name}"
#  }
#
#  depends_on = [
#    module.eks
#  ]
#}
