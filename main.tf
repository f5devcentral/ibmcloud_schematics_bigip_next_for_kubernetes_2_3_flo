# ============================================================
# Root Terraform Configuration
# F5 BNK Orchestrator — deploys to an existing ROKS cluster
# Modules: cert-manager → flo → cneinstance → license
# ============================================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.60.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

# ============================================================
# Module: flo (F5 Lifecycle Operator)
# ============================================================

module "flo" {
  source = "./modules/flo"

  depends_on = [data.ibm_container_cluster_config.cluster_config]

  providers = {
    kubernetes = kubernetes
    helm       = helm
    ibm        = ibm
  }

  enabled = true

  cert_manager_crd_ready = true

  far_repo_url = var.far_repo_url

  # COS Bucket Configuration
  use_cos_bucket                = var.use_cos_bucket
  ibmcloud_api_key              = var.ibmcloud_api_key
  ibmcloud_cos_bucket_region    = var.ibmcloud_cos_bucket_region
  ibmcloud_resource_group       = var.ibmcloud_resource_group
  ibmcloud_cos_instance_name    = var.ibmcloud_cos_instance_name
  ibmcloud_resources_cos_bucket = var.ibmcloud_resources_cos_bucket
  f5_cne_far_auth_file          = var.f5_cne_far_auth_file
  f5_cne_subscription_jwt_file  = var.f5_cne_subscription_jwt_file

  # FLO Configuration
  f5_bigip_k8s_manifest_version = var.f5_bigip_k8s_manifest_version
  flo_namespace                 = var.flo_namespace
  utils_namespace               = var.utils_namespace

  # BIG-IP CIS Configuration
  bigip_username = var.bigip_username
  bigip_password = var.bigip_password
  bigip_url      = var.bigip_url

  # Cluster identity — learned from the cluster data source
  openshift_cluster_name = data.ibm_container_vpc_cluster.cluster.name
  openshift_cluster_crn  = data.ibm_container_vpc_cluster.cluster.crn
  cluster_vpc_id         = data.ibm_is_vpc.cluster_vpc.id

  # NAD Configuration
  nad_cni_type       = "ipvlan"
  nad_interface_name = "ens3"
  nad_ipvlan_mode    = "l2"

  # Certificate Manager
  cert_manager_namespace = var.cert_manager_namespace
}
