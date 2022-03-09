
variable "namespace" {
  type = string
}

variable "illumidesk_version" {
  type    = string
  default = "5.11.2"
}

variable "single_user_default_url" {
  type    = string
  default = "/tree"
}

variable "single_user_image" {
  type    = string
  default = "illumidesk/illumidesk-notebook"
}

variable "single_user_tag" {
  type    = string
  default = "python-3.9.5"
}

variable "single_user_pull_policy" {
  type    = string
  default = "Always"
}

variable "single_cpu_limit" {
  type    = number
  default = 1.0
}


variable "single_cpu_guarantee" {
  type    = number
  default = 1.0
}

variable "single_mem_limit" {
  type    = string
  default = "2G"
}


variable "single_mem_guarantee" {
  type    = string
  default = "1G"
}

variable "hub_image" {
  type    = string
  default = "illumidesk/k8s-hub"
}

variable "hub_tag" {
  type    = string
  default = "latest"
}

variable "hub_pull_policy" {
  type    = string
  default = "Always"
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
  type = string
}

variable "group_name" {
  type = string
}

variable "lb_tags" {
  type    = string
  default = "Environment=dev,Team=dev"
}

variable "enable_nfs" {
  type    = bool
  default = false
}

variable "enable_efs" {
  type    = bool
  default = true
}

variable "efs_volume_handle" {
  type = string
  default = ""
}

variable "nfs_server" {
  type = string
  default = ""
}

variable "enable_external_db" {
  type    = bool
  default = true
}

variable "db_host" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}


variable "database_password" {
  type      = string
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
  default = "200m"
}

variable "grader_spawner_cpu_limit" {
  type    = string
  default = "400m"
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

variable "lti_11_shared_secret" {
  type    = string
  default = "lti_11_shared_secret"
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




variable "image_credentials_enabled" {
  type    = bool
  default = false
}

variable "image_credentials_registry" {
  type    = string
  default = "https://index.docker.io/v1/"
}
variable "image_credentials_email" {
  type    = string
  default = "hello@illumidesk.com"
}

variable "image_credentials_username" {
  type    = string
  default = "illumideskops"
}

variable "image_credentials_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "postgresql_enabled" {
  type    = bool
  default = false
}

variable "postgresql_db" {
  type    = string
  default = "illumidesk"
}

variable "postgresql_username" {
  type    = string
  default = "postgres"
}

variable "postgresql_password" {
  type      = string
  default   = "postgres123"
  sensitive = true
}

variable "postgresql_port" {
  type    = number
  default = 5432
}

