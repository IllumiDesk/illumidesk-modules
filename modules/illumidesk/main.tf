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
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

  }
}

resource "random_string" "proxy_secret_token" {
  length  = 16
  special = false
}

resource "random_string" "jupyterhub_api_token" {
  length  = 32
  special = false
}

resource "random_string" "jupyterhub_crypt_key" {
  length  = 32
  special = false
}

resource "random_string" "lti_11_shared_secret" {
  length  = 32
  special = false
}
## Deploy application
locals {
  chart_name           = "illumidesk"
  jupyterhub_api_token = tostring(random_string.jupyterhub_api_token.result)
  jupyterhub_crypt_key = tostring(random_string.jupyterhub_crypt_key.result)
  lti_11_shared_secret = tostring(random_string.lti_11_shared_secret.result)
  nbgrader_password    = var.enable_external_db == true ? var.database_password : var.postgresql_enabled == true ? var.postgresql_password : ""
  jupyterhub_password  = var.enable_external_db == true ? var.database_password : var.postgresql_enabled == true ? var.postgresql_password : ""
  external_db_url      = var.enable_external_db == true ? format("postgresql://%s:%s@%s:%d/%s", var.database_user, var.database_password, var.db_host, var.db_port, var.database_name) : ""
  postgresql_db_url    = var.postgresql_enabled == true ? format("postgresql://%s:%s@%s-postgresql.%s.svc.cluster.local:%d/%s", var.postgresql_username, var.postgresql_password, var.namespace, var.namespace, var.postgresql_port, var.postgresql_db) : ""
}

locals {
  values = merge({
    jupyterhub = {
      hub = {
        db = {
          url = var.enable_external_db == true ? local.external_db_url : local.postgresql_db_url
        }
        extraEnv = {
          JUPYTERHUB_API_TOKEN         = local.jupyterhub_api_token
          JUPYTERHUB_CRYPT_KEY         = local.jupyterhub_crypt_key
          POSTGRES_NBGRADER_PASSWORD   = local.nbgrader_password
          LTI_SHARED_SECRET            = local.lti_11_shared_secret
          POSTGRES_JUPYTERHUB_PASSWORD = local.jupyterhub_password

        }
        image = {
          name       = var.hub_image
          tag        = var.hub_tag
          pullPolicy = var.hub_pull_policy

        }

      }
      singleuser = {
        defaultUrl = var.single_user_default_url
        image = {
          name       = var.single_user_image
          tag        = var.single_user_tag
          pullPolicy = var.single_user_pull_policy
        }
        cpu = {
          limit     = var.single_cpu_limit
          guarantee = var.single_cpu_guarantee
        }
        memory = {
          limit     = var.single_mem_limit
          guarantee = var.single_mem_guarantee
        }

      }
      proxy = {
        secretToken = tostring(random_string.proxy_secret_token.result)
      }
    }
    imageCredentials = {
      enabled  = var.image_credentials_enabled
      registry = var.image_credentials_registry
      email    = var.image_credentials_email
      username = var.image_credentials_username
      password = var.image_credentials_password
    }

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
    postgresql = {
      enabled                    = var.postgresql_enabled
      postgresqlDatabase         = var.postgresql_db
      postgresqlUsername         = var.postgresql_username
      postgresqlPassword         = var.postgresql_password
      postgresqlPostgresPassword = var.postgresql_password
      port                       = var.db_port
      service = {
        port = var.postgresql_port
      }
    }
    graderSetupService = {
      enabled                   = var.enable_grader_setup_service
      graderCpuLimit            = var.grader_cpu_limit
      graderMemLimit            = var.grader_mem_limit
      graderSetupImage          = var.grader_setup_image
      graderSpawnerCpuGuarantee = var.grader_spawner_cpu_guarantee
      graderSpawnerCpuLimit     = var.grader_spawner_cpu_limit
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
      enabled           = var.enable_illumidesk_settings
      customAuthType    = var.custom_auth_type
      lti13AuthorizeUrl = var.lti13_authorize_url
      lti13ClientId     = var.lti13_client_id
      lti13Endpoint     = var.lti13_endpoint
      lti13TokenUrl     = var.lti13_token_url
      ltiConsumerKey    = var.lti_11_consumer_key
      oidcAuthorizeUrl  = var.oidc_authorize_url
      oidcCallbackUrl   = "https://${var.host}/hub/oauth_callback"
      oidcClientId      = var.oidc_client_Id
      oidcTokenUrl      = var.oidc_token_url
      oidcUserData      = var.oidc_user_data
    }

  })
}
resource "helm_release" "illumidesk-stack-resource" {
  # Due to a bug in the helm provider in repository management, it is more stable to use the repository URL directly.
  # See https://github.com/terraform-providers/terraform-provider-helm/issues/416#issuecomment-598828730 for more
  # information.
  repository       = "https://illumidesk.github.io/helm-chart/"
  name             = var.namespace
  chart            = local.chart_name
  version          = var.illumidesk_version
  namespace        = var.namespace
  create_namespace = true
  values           = [yamlencode(local.values)]

  depends_on = [
    random_string.proxy_secret_token,
    random_string.jupyterhub_api_token,
    random_string.jupyterhub_crypt_key
  ]


}

