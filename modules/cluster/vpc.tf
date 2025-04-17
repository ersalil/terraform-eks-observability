
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "eks-mon"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway  = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
     "kubernetes.io/role/elb" = 1
 }

 private_subnet_tags = {
     "kubernetes.io/role/internal-elb" = 1
 }
  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = "eks-salil"
  cluster_version = "1.31"
  bootstrap_self_managed_addons = true
  cluster_upgrade_policy = {
   support_type = "STANDARD"
  }
  cluster_addons = {
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

enable_irsa = true
  vpc_id                   =  module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "example" {
  depends_on = [ module.eks_managed_node_group ]
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"
}

module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  cluster_service_cidr = module.eks.cluster_service_cidr
  name            = "eks-node-salil"
  cluster_name    = module.eks.cluster_name
  cluster_version = "1.31"

  subnet_ids = module.vpc.private_subnets
  min_size     = 1
  max_size     = 2
  desired_size = 1

  instance_types = ["t3.large"]
  capacity_type  = "SPOT"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_eks_addon" "ebs" {
  depends_on = [ module.eks_managed_node_group ]
  cluster_name = module.eks.cluster_name 
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.eks-ebs.arn
}
resource "aws_iam_role" "eks-ebs" {
  name = "eks-ebs-salil"
  assume_role_policy = data.aws_iam_policy_document.ebs_controller_assume_role_policy.json  
}

resource "aws_iam_role_policy_attachment" "ebs_controller_policy_attachment" {
  role       = aws_iam_role.eks-ebs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Define the IAM policy document for the AssumeRole policy
data "aws_iam_policy_document" "ebs_controller_assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRoleWithWebIdentity"]
    effect    = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.oidc_provider}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}