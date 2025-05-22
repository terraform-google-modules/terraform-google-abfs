# ABFS Server Terraform module

This module implements the deployment of a ABFS server as GCE VM.

## Usage

For example usage, please check the following [example](../../examples/simple/main.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abfs\_datadisk\_mountpoint | Location for mounting the ABFS datadisk on the host VM | `string` | `"/mnt/disks/abfs-data"` | no |
| abfs\_datadisk\_name | A name for the ABFS datadisk that will be attached to the VM. Note, this does not affect the mounting of the disk - the device name is always set to "abfs-server-storage" | `string` | `"abfs-datadisk"` | no |
| abfs\_datadisk\_size\_gb | Size in GB for the ABFS datadisk that will be attached to the VM | `number` | `10000` | no |
| abfs\_datadisk\_type | The PD regional disk type to use for the ABFS datadisk | `string` | `"pd-ssd"` | no |
| abfs\_docker\_image\_uri | Docker image URI for main ABFS server | `string` | n/a | yes |
| abfs\_license | ABFS license (JSON) | `string` | n/a | yes |
| abfs\_server\_command | The ABFS command to run on ABFS servers. The command should not include 'abfs', only what follows | `string` | `"server -d /abfs-storage"` | no |
| abfs\_server\_cos\_image\_ref | Reference to the COS boot image to use for the ABFS server | `string` | `"projects/cos-cloud/global/images/family/cos-109-lts"` | no |
| abfs\_server\_machine\_type | Machine type for ABFS servers | `string` | `"n2-highmem-128"` | no |
| abfs\_server\_name | Name for the ABFS server | `string` | `"abfs-server"` | no |
| goog\_cm\_deployment\_name | The name of the deployment for Marketplace | `string` | `""` | no |
| project\_id | Google Cloud project ID | `string` | n/a | yes |
| service\_account\_email | Email of service account to attach to the servers | `string` | n/a | yes |
| subnetwork | Subnetwork for the servers | `string` | n/a | yes |
| zone | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| abfs\_server\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
