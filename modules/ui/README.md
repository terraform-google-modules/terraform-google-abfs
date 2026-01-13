# ABFS UI Terraform module

This module implements the deployment of a ABFS UI Server as GCE VM.

## Usage

For example usage, please check the following [example](../../blueprints/reference/abfs.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abfs\_bootdisk\_size\_gb | Size in GB for the ABFS bootdisk that will be attached to the VM | `number` | `200` | no |
| abfs\_bootdisk\_type | The PD regional disk type to use for the ABFS bootdisk | `string` | `"pd-ssd"` | no |
| abfs\_docker\_image\_uri | Docker image URI for the ABFS UI | `string` | n/a | yes |
| abfs\_extra\_params | A list of extra parameters to append to the abfs command | `list(string)` | `[]` | no |
| abfs\_ui\_allow\_stopping\_for\_update | Allow to stop UI to update properties | `bool` | `true` | no |
| abfs\_ui\_cos\_image\_ref | Reference to the COS boot image to use for the ABFS UI | `string` | `"projects/cos-cloud/global/images/family/cos-125-lts"` | no |
| abfs\_ui\_extra\_params | A list of extra parameters to append to the ui-server sub-command | `list(string)` | `[]` | no |
| abfs\_ui\_machine\_type | Machine type for ABFS UI | `string` | `"n2d-standard-8"` | no |
| abfs\_ui\_name | Name for the ABFS UI | `string` | `"abfs-ui"` | no |
| abfs\_ui\_port | The port to listen on | `number` | `8080` | no |
| abfs\_ui\_remote\_server | The name of the ABFS server for the cacheman process | `string` | `"abfs-server"` | no |
| abfs\_ui\_uploader\_count | The number of gerrit uploader instances to proxy | `number` | `3` | no |
| abfs\_ui\_uploader\_name\_prefix | Name prefix for the ABFS gerrit uploader VM(s) | `string` | `"abfs-gerrit-uploader"` | no |
| goog\_cm\_deployment\_name | The name of the deployment for Marketplace | `string` | `""` | no |
| project\_id | Google Cloud project ID | `string` | n/a | yes |
| service\_account\_email | Email of service account to attach to the servers | `string` | n/a | yes |
| subnetwork | Subnetwork for the servers | `string` | n/a | yes |
| zone | Zone for ABFS UI | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
