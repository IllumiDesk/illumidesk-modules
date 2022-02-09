variable "region" {
  type    = string
  default = "us-west-2"
}

variable "imageAddress" {
  type    = string
  default = "602401143452"
}

variable "account_id" {
  type    = string
  default = ""
}

variable "eks_iam_openid_connect_provider_url" {
  type    = string
  default = "https://oidc.eks.us-west-2.amazonaws.com/id/6FBEFFE17A2B780AA8FB6C0E86808DF5"


}

