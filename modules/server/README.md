# ABFS Server Terraform module

This module implements the deployment of a ABFS server as GCE VM.

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
| [google_compute_attached_disk.abfs_datadisk_attachment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_attached_disk) | resource |
| [google_compute_disk.abfs_datadisk](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk) | resource |
| [google_compute_instance.abfs_server](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [cloudinit_config.abfs_server](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abfs_datadisk_mountpoint"></a> [abfs\_datadisk\_mountpoint](#input\_abfs\_datadisk\_mountpoint) | Location for mounting the ABFS datadisk on the host VM | `string` | `"/mnt/disks/abfs-data"` | no |
| <a name="input_abfs_datadisk_name"></a> [abfs\_datadisk\_name](#input\_abfs\_datadisk\_name) | A name for the ABFS datadisk that will be attached to the VM. Note, this does not affect the mounting of the disk - the device name is always set to "abfs-server-storage" | `string` | `"abfs-datadisk"` | no |
| <a name="input_abfs_datadisk_size_gb"></a> [abfs\_datadisk\_size\_gb](#input\_abfs\_datadisk\_size\_gb) | Size in GB for the ABFS datadisk that will be attached to the VM | `number` | `10000` | no |
| <a name="input_abfs_datadisk_type"></a> [abfs\_datadisk\_type](#input\_abfs\_datadisk\_type) | The PD regional disk type to use for the ABFS datadisk | `string` | `"pd-ssd"` | no |
| <a name="input_abfs_docker_image_uri"></a> [abfs\_docker\_image\_uri](#input\_abfs\_docker\_image\_uri) | Docker image URI for main ABFS server | `string` | n/a | yes |
| <a name="input_abfs_license"></a> [abfs\_license](#input\_abfs\_license) | ABFS license (JSON) | `string` | n/a | yes |
| <a name="input_abfs_server_command"></a> [abfs\_server\_command](#input\_abfs\_server\_command) | The ABFS command to run on ABFS servers. The command should not include 'abfs', only what follows | `string` | `"server -d /abfs-storage"` | no |
| <a name="input_abfs_server_cos_image_ref"></a> [abfs\_server\_cos\_image\_ref](#input\_abfs\_server\_cos\_image\_ref) | Reference to the COS boot image to use for the ABFS server | `string` | `"projects/cos-cloud/global/images/family/cos-109-lts"` | no |
| <a name="input_abfs_server_machine_type"></a> [abfs\_server\_machine\_type](#input\_abfs\_server\_machine\_type) | Machine type for ABFS servers | `string` | `"n2-highmem-128"` | no |
| <a name="input_abfs_server_name"></a> [abfs\_server\_name](#input\_abfs\_server\_name) | Name for the ABFS server | `string` | `"abfs-server"` | no |
| <a name="input_goog_cm_deployment_name"></a> [goog\_cm\_deployment\_name](#input\_goog\_cm\_deployment\_name) | The name of the deployment for Marketplace | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email of service account to attach to the servers | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnetwork for the servers | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_abfs_server_name"></a> [abfs\_server\_name](#output\_abfs\_server\_name) | n/a |
<!-- END_TF_DOCS -->
