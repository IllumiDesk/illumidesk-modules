variable "region" {
  type    = string
  default = "us-west-2"
}

variable "imageAddress" {
  type    = string
  default = "602401143452"
}

variable "eks_iam_openid_connect_provider_arn" {
  type    = string
  default = module.eks_cluster.eks_iam_openid_connect_provider_arn
}

variable "eks_iam_openid_connect_provider_url" {
  type    = string
  default = module.eks_cluster.eks_iam_openid_connect_provider_url
}

