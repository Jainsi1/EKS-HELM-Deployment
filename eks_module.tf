module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_cluster_name}-ebs-csi-controller"
    }
  }

  vpc_id                   = var.provision_vpc ? module.vpc[0].vpc_id : var.vpc_id
  subnet_ids               = var.provision_vpc ? module.vpc[0].private_subnets : var.private_subnet_ids
  control_plane_subnet_ids = var.provision_vpc ? module.vpc[0].public_subnets : var.public_subnet_ids

  eks_managed_node_group_defaults = {
    instance_types = var.eks_managed_node_group_default_instance_type
    iam_role_additional_policies = {
      additional1 = aws_iam_policy.cluster-autoscaler-additional.arn, 
      additional2 = var.ssm_policy_arn
    }
  }

  eks_managed_node_groups = {
    eks-first-instance = {
      min_size     = var.managed_nodes_min_capacity
      max_size     = var.managed_nodes_max_capacity
      desired_size = var.managed_nodes_desired_capacity
      disk_size    = 30
      instance_types = ["t3.large"]
      capacity_type  = var.managed_nodes_capacity_type
      ebs_optimized           = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
      labels = {
        sonarqube = "true"
      }
      tags = {
        ExtraTag = "EKS managed node group",
      }
    }
    eks-second-instance = {
      min_size     = var.managed_nodes_min_capacity
      max_size     = var.managed_nodes_max_capacity
      desired_size = var.managed_nodes_desired_capacity
      disk_size    = 30
      instance_types = ["t3.xlarge"]
      capacity_type  = var.managed_nodes_capacity_type
      ebs_optimized           = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
      labels = {
        defectdojo = "true"
      }
      tags = {
        ExtraTag = "EKS managed node group",
      }
    }
    eks-third-instance = {
      min_size     = var.managed_nodes_min_capacity
      max_size     = var.managed_nodes_max_capacity
      desired_size = var.managed_nodes_desired_capacity
      disk_size    = 30
      instance_types = ["t3.2xlarge"]
      capacity_type  = var.managed_nodes_capacity_type
      ebs_optimized           = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 30
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            delete_on_termination = true
          }
        }
      }
      labels = {
        dependencyTrack = "true"
      }
      tags = {
        ExtraTag = "EKS managed node group",
      }
    }
  }
}
