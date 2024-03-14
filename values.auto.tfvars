provision_vpc = true
# If provision_vpc = false then you have to update the values of vpc_id, public_subnet_ids and private_subnet_ids 
provider_region = "us-east-1"
vpc_id = ""
private_subnet_ids = [ "","","" ]
public_subnet_ids = [  "","",""  ]
# If provision_vpc = true then you have to change the following values as per your needs
vpc_name="dev-vpc"
vpc_cidr="172.22.158.0/23"
vpc_azs=["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_private_subnet_cidrs=["172.22.158.192/26", "172.22.159.0/26", "172.22.159.64/26"]
vpc_public_subnet_cidrs=["172.22.158.0/26", "172.22.158.64/26", "172.22.158.128/26"]
vpc_tags={
    Terraform = "true"
    Environment = "dev"
  }

#eks cluster values.
eks_cluster_name="eks-dev-cluster"
eks_cluster_version="1.27"
eks_managed_node_group_default_instance_type=["t3.large"]
managed_nodes_min_capacity=1
managed_nodes_max_capacity=10
ebs_disk_size = 50
managed_nodes_desired_capacity=1
managed_nodes_instance_type_list=["t3.large"]
managed_nodes_capacity_type="ON_DEMAND"
# managed_nodes_tags={
#         sonarqube = "true"
#       }
encryption = false
ssm_policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
