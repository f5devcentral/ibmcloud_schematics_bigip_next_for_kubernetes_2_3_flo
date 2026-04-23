variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key"
  type        = string
  sensitive   = true
}

variable "ibmcloud_cluster_region" {
  description = "IBM Cloud region where the cluster resides"
  type        = string
  default     = "ca-tor"
}

variable "ibmcloud_resource_group" {
  description = "IBM Cloud Resource Group name (leave empty to use account default)"
  type        = string
  default     = ""
}

variable "cluster_name_or_id" {
  description = "Name or ID of the existing OpenShift ROKS cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name_or_id) > 0
    error_message = "cluster_name_or_id cannot be empty."
  }
}

variable "far_repo_url" {
  description = "FAR Repository URL for Docker and Helm registry"
  type        = string
  default     = "repo.f5.com"
}

variable "f5_bigip_k8s_manifest_version" {
  description = "Version of the f5-bigip-k8s-manifest chart"
  type        = string
  default     = "2.3.0-bnpp-ehf-2-3.2598.3-0.0.17"
}

variable "ibmcloud_cos_bucket_region" {
  description = "IBM Cloud region where the COS bucket is located"
  type        = string
  default     = "us-south"
}

variable "ibmcloud_cos_instance_name" {
  description = "IBM Cloud COS instance name"
  type        = string
  default     = "bnk-orchestration"
}

variable "ibmcloud_resources_cos_bucket" {
  description = "IBM Cloud COS bucket containing the FAR auth key and JWT files"
  type        = string
  default     = "bnk-schematics-resources"
}

variable "f5_cne_far_auth_file" {
  description = "FAR auth key filename in the COS bucket (.tgz)"
  type        = string
  default     = "f5-far-auth-key.tgz"
}

variable "f5_cne_subscription_jwt_file" {
  description = "Subscription JWT filename in the COS bucket"
  type        = string
  default     = "trial.jwt"
}

variable "cert_manager_namespace" {
  description = "Namespace where cert-manager is installed"
  type        = string
  default     = "cert-manager"
}

variable "flo_namespace" {
  description = "Namespace for F5 Lifecycle Operator"
  type        = string
  default     = "f5-bnk"
}

variable "utils_namespace" {
  description = "Namespace for F5 utility components"
  type        = string
  default     = "f5-utils"
}

variable "bigip_username" {
  description = "BIG-IP username for CIS controller login"
  type        = string
  default     = "admin"
}

variable "bigip_password" {
  description = "BIG-IP password for CIS controller login"
  type        = string
  default     = ""
  sensitive   = true
}

variable "bigip_url" {
  description = "BIG-IP URL for CIS controller login"
  type        = string
  default     = ""
}
