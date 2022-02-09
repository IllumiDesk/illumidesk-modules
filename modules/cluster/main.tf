# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY Cluster Based Resource
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

## Deploy application
locals {
    release_name = "cluster-illumidesk-resource"
    chart_name   = "cluster"
    version      = "0.0.1"
}

# creates trust relationship by assuming role using OIDC
module "assume_role_policy" {
  source = "git::git@github.com:gruntwork-io/terraform-aws-eks.git//modules/eks-iam-role-assume-role-policy-for-service-account?ref=v0.7.0"

  eks_openid_connect_provider_arn = var.eks_iam_openid_connect_provider_arn
  eks_openid_connect_provider_url = var.eks_iam_openid_connect_provider_url
  namespaces                      = ["kube-system"]
  service_accounts                = []
}

# creates efs csi driver role and configures assume role policy document
resource "aws_iam_role" "efs-csi-driver-role" {
  name               = "efs-csi-driver-role"
  assume_role_policy = module.assume_role_policy.assume_role_policy_json
}

# 1. Creates efs csi driver policy
resource "aws_iam_policy" "efs_csi_driver_policy" {
  name        = "efs-csi-driver-policy"
  description = "efs csi driver policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
EOT
}

# attaches policy 
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.efs-csi-driver-role.name
  policy_arn = aws_iam_policy.efs_csi_driver_policy.arn
}

resource "helm_release" "k8s_cluster_resource" {
  # Due to a bug in the helm provider in repository management, it is more stable to use the repository URL directly.
  # See https://github.com/terraform-providers/terraform-provider-helm/issues/416#issuecomment-598828730 for more
  # information.
  repository = "https://illumidesk.github.io/helm-chart/"
  name       = local.release_name
  chart      = local.chart_name
  version    = local.version
  namespace  = "kube-system"

  values = [
      "${file("values.yaml")}"
  ]

  set {
      name = "efsCSIDriver.enabled"
      value = true
  }
  set {
      name = "efsCSIDriver.region"
      value = var.region
  }
  set {
      name = "efsCSIDriver.imageAddress"
      value = var.imageAddress
  }
  set {
      name = "efsCSIDriver.PassARN"
      value = true
  }
  set {
      name = "efsCSIDriver.roleARN"
      value = aws_iam_role.efs-csi-driver-role.name
  }



}

