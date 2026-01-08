# ABFS UI Terraform module

This module implements the deployment of a ABFS UI Server as GCE VM.

## Usage

For example usage, please check the following [example](../../blueprints/reference/abfs.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abfs_bootdisk_size_gb"></a> [abfs\_bootdisk\_size\_gb](#input\_abfs\_bootdisk\_size\_gb) | Size in GB for the ABFS bootdisk that will be attached to the VM | `number` | `200` | no |
| <a name="input_abfs_bootdisk_type"></a> [abfs\_bootdisk\_type](#input\_abfs\_bootdisk\_type) | The PD regional disk type to use for the ABFS bootdisk | `string` | `"pd-ssd"` | no |
| <a name="input_abfs_docker_image_uri"></a> [abfs\_docker\_image\_uri](#input\_abfs\_docker\_image\_uri) | Docker image URI for the ABFS UI | `string` | n/a | yes |
| <a name="input_abfs_extra_params"></a> [abfs\_extra\_params](#input\_abfs\_extra\_params) | A list of extra parameters to append to the abfs command | `list(string)` | `[]` | no |
| <a name="input_abfs_ui_allow_stopping_for_update"></a> [abfs\_ui\_allow\_stopping\_for\_update](#input\_abfs\_ui\_allow\_stopping\_for\_update) | Allow to stop UI to update properties | `bool` | `true` | no |
| <a name="input_abfs_ui_cos_image_ref"></a> [abfs\_ui\_cos\_image\_ref](#input\_abfs\_ui\_cos\_image\_ref) | Reference to the COS boot image to use for the ABFS UI | `string` | `"projects/cos-cloud/global/images/family/cos-125-lts"` | no |
| <a name="input_abfs_ui_extra_params"></a> [abfs\_ui\_extra\_params](#input\_abfs\_ui\_extra\_params) | A list of extra parameters to append to the ui-server sub-command | `list(string)` | `[]` | no |
| <a name="input_abfs_ui_machine_type"></a> [abfs\_ui\_machine\_type](#input\_abfs\_ui\_machine\_type) | Machine type for ABFS UI | `string` | `"n2d-standard-8"` | no |
| <a name="input_abfs_ui_name"></a> [abfs\_ui\_name](#input\_abfs\_ui\_name) | Name for the ABFS UI | `string` | `"abfs-ui"` | no |
| <a name="input_abfs_ui_port"></a> [abfs\_ui\_port](#input\_abfs\_ui\_port) | The port to listen on | `number` | `8080` | no |
| <a name="input_abfs_ui_remote_server"></a> [abfs\_ui\_remote\_server](#input\_abfs\_ui\_remote\_server) | The name of the ABFS server for the cacheman process | `string` | `"abfs-server"` | no |
| <a name="input_abfs_ui_uploader_count"></a> [abfs\_ui\_uploader\_count](#input\_abfs\_ui\_uploader\_count) | The number of gerrit uploader instances to proxy | `number` | `3` | no |
| <a name="input_abfs_ui_uploader_name_prefix"></a> [abfs\_ui\_uploader\_name\_prefix](#input\_abfs\_ui\_uploader\_name\_prefix) | Name prefix for the ABFS gerrit uploader VM(s) | `string` | `"abfs-gerrit-uploader"` | no |
| <a name="input_goog_cm_deployment_name"></a> [goog\_cm\_deployment\_name](#input\_goog\_cm\_deployment\_name) | The name of the deployment for Marketplace | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email of service account to attach to the servers | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnetwork for the servers | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone for ABFS UI | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
