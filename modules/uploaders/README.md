# ABFS Uploaders Terraform module

This module implements the deployment of X (default 3) ABFS uploaders as GCE VMS.

## Usage

For example usage, please check the following [example](../../examples/simple/main.tf) file.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_attached_disk.abfs_gerrit_uploader_datadisk_attachments](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk) | resource |
| [google_compute_disk.abfs_gerrit_uploader_datadisks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk) | resource |
| [google_compute_instance.abfs_gerrit_uploaders](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [cloudinit_config.abfs_gerrit_uploader_configs](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abfs_datadisk_mountpoint"></a> [abfs\_datadisk\_mountpoint](#input\_abfs\_datadisk\_mountpoint) | Location for mounting the ABFS datadisk on the host VM | `string` | `"/mnt/disks/abfs-data"` | no |
| <a name="input_abfs_docker_image_uri"></a> [abfs\_docker\_image\_uri](#input\_abfs\_docker\_image\_uri) | Docker image URI for the ABFS uploader | `string` | n/a | yes |
| <a name="input_abfs_gerrit_uploader_count"></a> [abfs\_gerrit\_uploader\_count](#input\_abfs\_gerrit\_uploader\_count) | The number of gerrit uploader instances to create | `number` | `3` | no |
| <a name="input_abfs_gerrit_uploader_datadisk_name_prefix"></a> [abfs\_gerrit\_uploader\_datadisk\_name\_prefix](#input\_abfs\_gerrit\_uploader\_datadisk\_name\_prefix) | A name prefix for the ABFS gerrit uploader datadisk(s) that will be attached to VM(s). Note, this does not affect the mounting of the disk - the device name is always set to "abfs-server-storage" | `string` | `"abfs-gerrit-uploader-datadisk"` | no |
| <a name="input_abfs_gerrit_uploader_datadisk_size_gb"></a> [abfs\_gerrit\_uploader\_datadisk\_size\_gb](#input\_abfs\_gerrit\_uploader\_datadisk\_size\_gb) | Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s) | `number` | `4096` | no |
| <a name="input_abfs_gerrit_uploader_datadisk_type"></a> [abfs\_gerrit\_uploader\_datadisk\_type](#input\_abfs\_gerrit\_uploader\_datadisk\_type) | The PD regional disk type to use for the ABFS gerrit uploader datadisk(s) | `string` | `"pd-ssd"` | no |
| <a name="input_abfs_gerrit_uploader_git_branch"></a> [abfs\_gerrit\_uploader\_git\_branch](#input\_abfs\_gerrit\_uploader\_git\_branch) | Git branch to upload to the ABFS server (e.g. main) | `string` | `"main"` | no |
| <a name="input_abfs_gerrit_uploader_git_servers"></a> [abfs\_gerrit\_uploader\_git\_servers](#input\_abfs\_gerrit\_uploader\_git\_servers) | List of git servers to upload to the ABFS server (e.g. ["android.googlesource.com"]) | `list(string)` | n/a | yes |
| <a name="input_abfs_gerrit_uploader_machine_type"></a> [abfs\_gerrit\_uploader\_machine\_type](#input\_abfs\_gerrit\_uploader\_machine\_type) | Machine type for ABFS gerrit uploaders | `string` | `"n2d-standard-48"` | no |
| <a name="input_abfs_gerrit_uploader_name_prefix"></a> [abfs\_gerrit\_uploader\_name\_prefix](#input\_abfs\_gerrit\_uploader\_name\_prefix) | Name prefix for the ABFS gerrit uploader VM(s) | `string` | `"abfs-gerrit-uploader"` | no |
| <a name="input_abfs_license"></a> [abfs\_license](#input\_abfs\_license) | ABFS license (JSON) | `string` | n/a | yes |
| <a name="input_abfs_manifest_file"></a> [abfs\_manifest\_file](#input\_abfs\_manifest\_file) | Relative path from the manifest project root to the manifest file | `string` | `"default.xml"` | no |
| <a name="input_abfs_manifest_project_name"></a> [abfs\_manifest\_project\_name](#input\_abfs\_manifest\_project\_name) | Name of the git project on the manifest-server containing manifests | `string` | `"platform/manifest"` | no |
| <a name="input_abfs_uploader_cos_image_ref"></a> [abfs\_puser\_cos\_image\_ref](#input\_abfs\_puser\_cos\_image\_ref) | Reference to the COS boot image to use for the ABFS uploader | `string` | `"projects/cos-cloud/global/images/family/cos-109-lts"` | no |
| <a name="input_abfs_server_name"></a> [abfs\_server\_name](#input\_abfs\_server\_name) | The name of the ABFS server | `string` | n/a | yes |
| <a name="input_goog_cm_deployment_name"></a> [goog\_cm\_deployment\_name](#input\_goog\_cm\_deployment\_name) | The name of the deployment for Marketplace | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email of service account to attach to the servers | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnetwork for the servers | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
