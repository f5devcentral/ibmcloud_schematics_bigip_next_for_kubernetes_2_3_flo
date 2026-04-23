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
  description = "IBM IAM Trusted Profile ID — pass to the cneinstance project as cneinstance_ibm_trusted_profile_id"
  value       = module.flo.trusted_profile_id
}

output "cluster_issuer_name" {
  description = "Name of the CA ClusterIssuer — pass to the cneinstance project as cluster_issuer_name"
  value       = module.flo.cluster_issuer_name
}

output "cneinstance_network_attachments" {
  description = "Network attachment names — pass to the cneinstance project as cneinstance_network_attachments"
  value       = module.flo.cneinstance_network_attachments
}

output "cos_jwt_token" {
  description = "JWT token fetched from COS — pass to the license project as jwt_token"
  value       = module.flo.cos_jwt_token
  sensitive   = true
}

output "flo_pod_deployment_status" {
  description = "FLO pod deployment status"
  value       = module.flo.flo_pod_deployment_status
}
