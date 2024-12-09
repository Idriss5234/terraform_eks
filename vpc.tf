provider "aws"{
    region= var.region
}

variable region{}
variable vpc_cidr_block{}
variable public_subnets_cidr_blocks{}
variable private_subnets_cidr_blocks {}

data "aws_availability_zones" "azs"{}

module "myk8s_app-vpc"{
      source = "terraform-aws-modules/vpc/aws"

      name="myk8s_app_vpc"
      cidr=var.vpc_cidr_block
      private_subnets = var.private_subnets_cidr_blocks
      public_subnets  = var.public_subnets_cidr_blocks
      azs=data.aws_availability_zones.azs.names

      enable_nat_gateway = true
      single_nat_gateway=true
      enable_vpn_gateway = true

      tags={
            "kubernetes.io/cluster/myk8sapp-eks-cluster"="shared"      #name of cluster
      }

      public_subnet_tags={                  # open for internet
            "kubernetes.io/cluster/myk8sapp-eks-cluster"="shared"     #name of cluster
            "kuberenetes.io/role/elb"=1       #  so that itaws knows that's public so internet
      }

      private_subnet_tags={             # not open for internet
            "kubernetes.io/cluster/myk8sapp-eks-cluster"="shared"       #name of cluster
            "kuberenetes.io/role/internal-elb"=1            #  so that itaws knows that's private so no internet
      }

        
}