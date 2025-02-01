provider "kubernetes" {
  host                   = data.aws_eks_cluster.myk8sapp-eks-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.myk8sapp-eks-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myk8sapp-eks-cluster.certificate_authority.0.data)
}


data "aws_eks_cluster" "myk8sapp-eks-cluster" {
 name = module.eks.cluster_name
 depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "myk8sapp-eks-cluster" {
  name = module.eks.cluster_name
 depends_on = [module.eks.cluster_name]
}

output "cert_nana" {
    value=base64decode(data.aws_eks_cluster.myk8sapp-eks-cluster.certificate_authority.0.data)
  
}
output "pvsbnt" {
    value=module.myk8s_app-vpc.private_subnets
  
}


module "eks" { 
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name= "myk8sapp-eks-cluster"
  cluster_version= "1.32"

  subnet_ids=module.myk8s_app-vpc.private_subnets
  vpc_id=module.myk8s_app-vpc.vpc_id


   tags = {
    environment = "dev"
    application = "myk8sapp"
   }
 
    
    eks_managed_node_groups = {
    worker-group-1 = {
      instance_types = ["t3.micro"] 

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
    worker-group-2 = {
      instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }
}