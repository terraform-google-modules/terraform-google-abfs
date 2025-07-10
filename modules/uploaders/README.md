# ABFS Uploaders Terraform module

This module implements the deployment of X (default 3) ABFS uploaders as GCE VMS.

## Usage

For example usage, please check the following [example](../../examples/simple/main.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abfs\_datadisk\_mountpoint | Location for mounting the ABFS datadisk on the host VM | `string` | `"/mnt/disks/abfs-data"` | no |
| abfs\_docker\_image\_uri | Docker image URI for the ABFS uploader | `string` | n/a | yes |
| abfs\_enable\_git\_lfs | Enable Git LFS support | `bool` | `false` | no |
| abfs\_gerrit\_uploader\_allow\_stopping\_for\_update | Allow to stop uploaders to update properties | `bool` | `true` | no |
| abfs\_gerrit\_uploader\_count | The number of gerrit uploader instances to create | `number` | `3` | no |
| abfs\_gerrit\_uploader\_datadisk\_name\_prefix | A name prefix for the ABFS gerrit uploader datadisk(s) that will be attached to VM(s). Note, this does not affect the mounting of the disk - the device name is always set to "abfs-server-storage" | `string` | `"abfs-gerrit-uploader-datadisk"` | no |
| abfs\_gerrit\_uploader\_datadisk\_size\_gb | Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s) | `number` | `4096` | no |
| abfs\_gerrit\_uploader\_datadisk\_type | The PD regional disk type to use for the ABFS gerrit uploader datadisk(s) | `string` | `"pd-ssd"` | no |
| abfs\_gerrit\_uploader\_git\_branch | Branches from where to find projects (e.g. ["main","v-keystone-qcom-release"]) (default ["main"]) | `set(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| abfs\_gerrit\_uploader\_machine\_type | Machine type for ABFS gerrit uploaders | `string` | `"n2d-standard-48"` | no |
| abfs\_gerrit\_uploader\_manifest\_server | The manifest server to assume | `string` | `"android.googlesource.com"` | no |
| abfs\_gerrit\_uploader\_name\_prefix | Name prefix for the ABFS gerrit uploader VM(s) | `string` | `"abfs-gerrit-uploader"` | no |
| abfs\_license | ABFS license (JSON) | `string` | n/a | yes |
| abfs\_manifest\_file | Relative path from the manifest project root to the manifest file | `string` | `"default.xml"` | no |
| abfs\_manifest\_project\_name | Name of the git project on the manifest-server containing manifests | `string` | `"platform/manifest"` | no |
| abfs\_server\_name | The name of the ABFS server | `string` | n/a | yes |
| abfs\_uploader\_cos\_image\_ref | Reference to the COS boot image to use for the ABFS uploader | `string` | `"projects/cos-cloud/global/images/family/cos-109-lts"` | no |
| goog\_cm\_deployment\_name | The name of the deployment for Marketplace | `string` | `""` | no |
| project\_id | Google Cloud project ID | `string` | n/a | yes |
| service\_account\_email | Email of service account to attach to the servers | `string` | n/a | yes |
| subnetwork | Subnetwork for the servers | `string` | n/a | yes |
| zone | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
