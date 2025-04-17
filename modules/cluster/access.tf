resource "aws_iam_group" "admin_group" {
  name = "eks-admin-group-salil"
}
resource "aws_iam_role" "admin_role" {
    name = "eks-admin-role-salil"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                      "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id
}:root"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "admin_permissions" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create IAM Policy for AssumeRole
resource "aws_iam_policy" "eks_assume_role_policy" {
  name        = "eks-assume-role-policy-salil"
  description = "Allows users in the group to assume the eks-admins-role"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::936379345511:role/${aws_iam_role.admin_role.name}"
      }
    ]
  })
}

# Attach Policy to IAM Group
resource "aws_iam_group_policy_attachment" "attach_assume_role_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.eks_assume_role_policy.arn
}

resource "aws_eks_access_entry" "example" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = aws_iam_role.admin_role.arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "example" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.admin_role.arn
  access_scope {
    type       = "cluster"
  }
}

resource "aws_iam_role" "eks-alb-ingress-controller" {
  name = "eks-alb-ingress-controller-salil"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json  
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = aws_iam_role.eks-alb-ingress-controller.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

# Define the IAM policy document for the AssumeRole policy
data "aws_iam_policy_document" "alb_controller_assume_role_policy" {
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
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}


