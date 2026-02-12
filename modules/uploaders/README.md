# ABFS Uploaders Terraform module

This module implements the deployment of X (default 3) ABFS uploaders as GCE VMS.

## Usage

For example usage, please check the following [example](../../blueprints/reference/abfs.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abfs\_datadisk\_mountpoint | Location for mounting the ABFS datadisk on the host VM | `string` | `"/mnt/disks/abfs-data"` | no |
| abfs\_docker\_image\_uri | Docker image URI for the ABFS uploader | `string` | n/a | yes |
| abfs\_enable\_git\_lfs | Enable Git LFS support | `bool` | `false` | no |
| abfs\_extra\_params | A list of extra parameters to append to the abfs command | `list(string)` | `[]` | no |
| abfs\_gerrit\_uploader\_allow\_stopping\_for\_update | Allow to stop uploaders to update properties | `bool` | `true` | no |
| abfs\_gerrit\_uploader\_branch\_files | Branch and manifest file tuples from where to find projects (e.g. [["main","default.xml"]]) (default [["main","default.xml"]]) | `set(tuple([string, string]))` | <pre>[<br>  [<br>    "main",<br>    "default.xml"<br>  ]<br>]</pre> | no |
| abfs\_gerrit\_uploader\_count | The number of gerrit uploader instances to create | `number` | `3` | no |
| abfs\_gerrit\_uploader\_datadisk\_name\_prefix | A name prefix for the ABFS gerrit uploader datadisk(s) that will be attached to VM(s). Note, this does not affect the mounting of the disk - the device name is always set to "abfs-server-storage" | `string` | `"abfs-gerrit-uploader-datadisk"` | no |
| abfs\_gerrit\_uploader\_datadisk\_size\_gb | Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s) | `number` | `4096` | no |
| abfs\_gerrit\_uploader\_datadisk\_type | The PD regional disk type to use for the ABFS gerrit uploader datadisk(s) | `string` | `"pd-ssd"` | no |
| abfs\_gerrit\_uploader\_extra\_params | A list of extra parameters to append to the gerrit upload-daemon sub-command | `list(string)` | `[]` | no |
| abfs\_gerrit\_uploader\_machine\_type | Machine type for ABFS gerrit uploaders | `string` | `"n2d-standard-48"` | no |
| abfs\_gerrit\_uploader\_manifest\_project\_url | The URL of the manifest project | `string` | `"https://android.googlesource.com/platform/manifest"` | no |
| abfs\_gerrit\_uploader\_name\_prefix | Name prefix for the ABFS gerrit uploader VM(s) | `string` | `"abfs-gerrit-uploader"` | no |
| abfs\_license | ABFS license (JSON) | `string` | n/a | yes |
| abfs\_server\_name | The name of the ABFS server | `string` | n/a | yes |
| abfs\_uploader\_cos\_image\_ref | Reference to the COS boot image to use for the ABFS uploader | `string` | `"projects/cos-cloud/global/images/family/cos-125-lts"` | no |
| goog\_cm\_deployment\_name | The name of the deployment for Marketplace | `string` | `""` | no |
| pre\_start\_hooks | The absolute path to the local directory containing pre-start hook scripts. These scripts will be copied to the host VM and mounted to the docker container at /etc/abfs/pre-start.d. | `string` | `null` | no |
| project\_id | Google Cloud project ID | `string` | n/a | yes |
| project\_number | Google Cloud project number | `string` | n/a | yes |
| region | Region for ABFS servers | `string` | n/a | yes |
| service\_account\_email | Email of service account to attach to the servers | `string` | n/a | yes |
| subnetwork | Subnetwork for the servers | `string` | n/a | yes |
| zone | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| abfs\_gerrit\_uploader\_count | The number of gerrit uploader instances to create |
| abfs\_gerrit\_uploader\_name\_prefix | Name prefix for the ABFS gerrit uploader VM(s) |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
