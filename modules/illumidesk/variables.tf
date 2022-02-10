
variable "namespace" {
  type    = string
  default = ""
}

variable "illumidesk_version" {
  type    = string
  default = ""
}


variable "host" {
  type    = string
  default = "illumidesk.illumidesk.com"
}

variable "enable_ingress" {
  type    = bool
  default = true
}

variable "acm_certificate" {
  type    = string
  default = ""
}

variable "group_name" {
  type    = string
  default = ""
}

variable "lb_tags" {
  type    = string
  default = "Environment=dev,Team=dev"
}

variable "enable_nfs" {
  type    = bool
  default = true
}


variable "nfs_server" {
  type = string
}

variable "enable_external_db" {
  type    = bool
  default = true
}

variable "db_host" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}

variable "database_user" {
  type    = string
  default = "gruntwork"
}


variable "database_password" {
  type      = string
  default   = ""
  sensitive = true
}


variable "db_port" {
  type    = number
  default = 5432
}

variable "enable_grader_setup_service" {
  type    = bool
  default = true
}

variable "grader_cpu_limit" {
  type    = string
  default = "2000m"
}

variable "grader_mem_limit" {
  type    = string
  default = "4Gi"
}

variable "grader_setup_image" {
  type    = string
  default = "illumidesk/grader-setup-service:latest"
}
variable "grader_spawner_cpu_guarantee" {
  type    = string
  default = "300m"
}
variable "grader_spawner_image" {
  type    = string
  default = "illumidesk/grader-notebook:latest"
}
variable "grader_spawner_mem_guarantee" {
  type    = string
  default = "400Mi"
}
variable "grader_spawner_mem_limit" {
  type    = string
  default = "2Gi"
}
variable "grader_spawner_pull_policy" {
  type    = string
  default = "Always"
}
variable "grader_spawner_storage" {
  type    = string
  default = "2Gi"
}
variable "grader_pull_policy" {
  type    = string
  default = "Always"
}
variable "grader_storage_capacity" {
  type    = string
  default = "2Gi"
}

variable "grader_storage_requests" {
  type    = string
  default = "2Gi"
}

variable "enable_illumidesk_settings" {
  type    = bool
  default = true
}

variable "custom_auth_type" {
  type    = string
  default = "AUTH0"
}

variable "lti13_authorize_url" {
  type    = string
  default = "https://illumidesk.instructure.com/api/lti/authorize_redirect"
}

variable "lti13_client_id" {
  type    = number
  default = 125900000000000240
}


variable "lti13_endpoint" {
  type    = string
  default = "https://illumidesk.instructure.com/api/lti/security/jwks"
}
variable "lti13_token_url" {
  type    = string
  default = "https://illumidesk.instructure.com/login/oauth2/token"
}


variable "lti_11_consumer_key" {
  type    = string
  default = "lti_11_consumer_key"
}


variable "oidc_authorize_url" {
  type    = string
  default = "https://auth.illumidesk.com/authorize"
}

variable "oidc_client_Id" {
  type    = string
  default = "HW2CKzOTNEH3aIXNrhsxnJmowVaUYgcn"
}

variable "oidc_token_url" {
  type    = string
  default = "https://auth.illumidesk.com/oauth/token"
}

variable "oidc_user_data" {
  type    = string
  default = "https://auth.illumidesk.com/userinfo"
}