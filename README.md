# BIG-IP Next for Kubernetes 2.3 — Step 2: FLO (F5 Lifecycle Operator)

## About This Workspace

Deploys the F5 Lifecycle Operator (FLO) and F5 BNK CIS controller into an existing IBM Cloud ROKS cluster. This is the second step in the BIG-IP Next for Kubernetes deployment sequence.

cert-manager **must be fully applied** before this workspace is planned or applied. The FLO workspace creates `ClusterIssuer` and `Certificate` resources that require cert-manager CRDs to be registered.

## Deployment Sequence

```
Step 1 → cert-manager
Step 2 → flo           (this workspace)
Step 3 → cneinstance
Step 4 → license
```

## What This Workspace Deploys

- cert-manager `ClusterIssuer` and `Certificate` resources (CA)
- NetworkAttachmentDefinitions (NAD) for TMM pod networking
- Node labels (`app=f5-tmm`) on all cluster nodes
- F5 Lifecycle Operator Helm release
- F5 BNK CIS Helm release
- BIG-IP login secret
- IBM IAM Trusted Profile for CNE controller VPC route orchestration
- Privileged SCC bindings (3 service accounts)

## Prerequisites

- cert-manager workspace applied (Step 1)
- FAR auth key archive (`f5-far-auth-key.tgz`) and license JWT (`trial.jwt`) uploaded to an IBM COS bucket

### IBM COS Setup

```bash
# Create the COS instance
ibmcloud resource service-instance-create bnk-orchestration cloud-object-storage standard global

# Create the COS bucket (replace RESOURCE_INSTANCE_ID with the CRN from above)
ibmcloud cos bucket-create \
  --bucket bnk-schematics-resources \
  --ibm-service-instance-id RESOURCE_INSTANCE_ID \
  --region us-south

# Upload the FAR auth key archive
ibmcloud cos object-put \
  --bucket bnk-schematics-resources \
  --key f5-far-auth-key.tgz \
  --body ./f5-far-auth-key.tgz \
  --region us-south

# Upload the license JWT token
ibmcloud cos object-put \
  --bucket bnk-schematics-resources \
  --key trial.jwt \
  --body ./trial.jwt \
  --region us-south
```

## Variables

### IBM Cloud / Cluster

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| `ibmcloud_api_key` | IBM Cloud API Key | REQUIRED | |
| `ibmcloud_cluster_region` | IBM Cloud region where the cluster resides | REQUIRED with default | `ca-tor` |
| `ibmcloud_resource_group` | IBM Cloud Resource Group name | Optional | `""` |
| `cluster_name_or_id` | Name or ID of the existing OpenShift ROKS cluster | REQUIRED | |

### FAR Registry

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| `far_repo_url` | FAR Repository URL | REQUIRED with default | `repo.f5.com` |
| `f5_bigip_k8s_manifest_version` | f5-bigip-k8s-manifest chart version | REQUIRED with default | `2.3.0-bnpp-ehf-2-3.2598.3-0.0.17` |

### COS Bucket

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| `ibmcloud_cos_bucket_region` | Region where the COS bucket is located | REQUIRED with default | `us-south` |
| `ibmcloud_cos_instance_name` | COS instance name | REQUIRED with default | `bnk-orchestration` |
| `ibmcloud_resources_cos_bucket` | COS bucket name | REQUIRED with default | `bnk-schematics-resources` |
| `f5_cne_far_auth_file` | FAR auth key filename (.tgz) | REQUIRED with default | `f5-far-auth-key.tgz` |
| `f5_cne_subscription_jwt_file` | Subscription JWT filename | REQUIRED with default | `trial.jwt` |

### Namespaces

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| `cert_manager_namespace` | Namespace where cert-manager is installed | Optional | `cert-manager` |
| `flo_namespace` | Namespace for F5 Lifecycle Operator | Optional | `f5-bnk` |
| `utils_namespace` | Namespace for F5 utility components | Optional | `f5-utils` |

### BIG-IP CIS

| Variable | Description | Required | Default |
| -------- | ----------- | -------- | ------- |
| `bigip_username` | BIG-IP username for CIS controller login | Optional | `admin` |
| `bigip_password` | BIG-IP password for CIS controller login | Optional | `""` |
| `bigip_url` | BIG-IP URL for CIS controller login | Optional | `""` |

## Outputs

These outputs are required as inputs for the cneinstance and license workspaces.

| Output | Description | Used by |
| ------ | ----------- | ------- |
| `trusted_profile_id` | IBM IAM Trusted Profile ID | cneinstance: `cneinstance_ibm_trusted_profile_id` |
| `cluster_issuer_name` | CA ClusterIssuer name | cneinstance: `cluster_issuer_name` |
| `cneinstance_network_attachments` | Network attachment names | cneinstance: `cneinstance_network_attachments` |
| `cos_jwt_token` | JWT token fetched from COS (sensitive) | license: `jwt_token` |
| `flo_release_name` | Name of the FLO Helm release | — |
| `flo_namespace` | Namespace where FLO is installed | — |
| `flo_version` | Installed FLO version | — |
| `flo_pod_deployment_status` | FLO pod deployment status | — |

Read outputs after apply:
```bash
terraform output trusted_profile_id
terraform output cluster_issuer_name
terraform output cneinstance_network_attachments
terraform output -raw cos_jwt_token   # sensitive
```

## Deployment

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Cleanup

```bash
terraform destroy -auto-approve
```

## Project Directory Structure

```
ibmcloud_schematics_bigip_next_for_kubernetes_2_3_flo/
├── main.tf                   # Calls FLO module
├── variables.tf              # Input variables
├── outputs.tf                # Outputs (including values needed by cneinstance and license)
├── providers.tf              # IBM, kubernetes, helm, null, local, http providers
├── data.tf                   # Cluster, VPC, subnet data sources
├── terraform.tfvars.example  # Example variable values
└── modules/
    └── flo/
        ├── main.tf           # ClusterIssuer, NAD, node labels, FLO helm, CIS helm, IAM trusted profile
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf
```
