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
  chart_name = "illumidesk/illumidesk"

}

locals {
  values = merge({
    albIngress = {
      enabled = var.enable_ingress
      host    = var.host
      ingress = {
        annotations = {
          "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate
          "alb.ingress.kubernetes.io/group.name"      = var.group_name
          "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
          "alb.ingress.kubernetes.io/tags"            = var.lb_tags
          "alb.ingress.kubernetes.io/target-type"     = "ip"
          "kubernetes.io/ingress.class"               = "alb"
        }
      }
      allowNFS = {
        enabled = var.enable_nfs
        path    = "/"
        server  = var.nfs_server
      }
      externalDatabase = {
        enabled          = var.enable_external_db
        host             = var.db_host
        database         = var.database_name
        databaseUser     = var.database_user
        databasePassword = var.database_password
        port             = var.db_port
      }
      graderSetupService = {
        enabled                   = var.enable_grader_setup_service
        graderCpuLimit            = var.grader_cpu_limit
        graderMemLimit            = var.grader_mem_limit
        graderSetupImage          = var.grader_setup_image
        graderSpawnerCpuGuarantee = var.grader_spawner_cpu_guarantee
        graderSpawnerImage        = var.grader_spawner_image
        graderSpawnerMemGuarantee = var.grader_spawner_mem_guarantee
        graderSpawnerMemLimit     = var.grader_spawner_mem_limit
        graderSpawnerPullPolicy   = var.grader_spawner_pull_policy
        graderSpawnerStorage      = var.grader_spawner_storage
        pullPolicy                = var.grader_pull_policy
        storageCapacity           = var.grader_storage_capacity
        storageRequests           = var.grader_storage_requests
      }
      illumideskSettings = {
        enabled: var.enable_illumidesk_settings
        customAuthType: var.custom_auth_type
        lti13AuthorizeUrl: var.lti13_authorize_url
        lti13ClientId: var.lti13_client_id
        lti13Endpoint: var.lti13_endpoint
        lti13TokenUrl: var.lti13_token_url
        ltiConsumerKey: var.lti_11_consumer_key
        oidcAuthorizeUrl: var.oidc_authorize_url
        oidcCallbackUrl: "https://${var.host}/hub/oauth_callback"
        oidcClientId: var.oidc_client_Id
        oidcTokenUrl: var.oidc_token_url
        oidcUserData: var.oidc_user_data
      }
    }


  })
}
resource "helm_release" "k8s_cluster_resource" {
  # Due to a bug in the helm provider in repository management, it is more stable to use the repository URL directly.
  # See https://github.com/terraform-providers/terraform-provider-helm/issues/416#issuecomment-598828730 for more
  # information.
  repository = "https://illumidesk.github.io/helm-chart/"
  name       = var.namespace
  chart      = local.chart_name
  version    = var.illumidesk_version
  namespace  = var.namespace

  values = [yamlencode(local.values)]


}

