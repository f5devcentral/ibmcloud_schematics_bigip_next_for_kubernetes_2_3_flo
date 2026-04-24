# ============================================================
# Root Terraform Outputs
# F5 BNK Orchestrator for existing ROKS cluster
# ============================================================

# ============================================================
# Cluster Info (from data source lookup)
# ============================================================

output "cluster_id" {
  description = "ID of the target OpenShift cluster"
  value       = data.ibm_container_vpc_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the target OpenShift cluster"
  value       = data.ibm_container_vpc_cluster.cluster.name
}

output "cluster_crn" {
  description = "CRN of the target OpenShift cluster"
  value       = data.ibm_container_vpc_cluster.cluster.crn
}

# ============================================================
# FLO Outputs
# ============================================================

output "flo_release_name" {
  description = "Name of the f5-lifecycle-operator Helm release"
  value       = module.flo.flo_release_name
}

output "flo_namespace" {
  description = "Namespace where f5-lifecycle-operator is installed"
  value       = module.flo.flo_namespace
}

output "flo_version" {
  description = "Installed f5-lifecycle-operator version"
  value       = module.flo.flo_version
}

output "extracted_flo_version" {
  description = "FLO version extracted from f5-bigip-k8s-manifest"
  value       = module.flo.extracted_flo_version
}

output "trusted_profile_id" {
  description = "IBM IAM Trusted Profile ID created for the CNE controller service account"
  value       = module.flo.trusted_profile_id
}

output "flo_pod_deployment_status" {
  description = "FLO pod deployment status"
  value       = module.flo.flo_pod_deployment_status
}
