# ABFS Server Terraform module

This module implements the deployment of a ABFS server as GCE VM.

## Usage

For example usage, please check the following [example](../../examples/simple/main.tf) file.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abfs_bootdisk_size_gb"></a> [abfs\_bootdisk\_size\_gb](#input\_abfs\_bootdisk\_size\_gb) | Size in GB for the ABFS bootdisk that will be attached to the VM | `number` | `100` | no |
| <a name="input_abfs_bootdisk_type"></a> [abfs\_bootdisk\_type](#input\_abfs\_bootdisk\_type) | The PD regional disk type to use for the ABFS bootdisk | `string` | `"pd-ssd"` | no |
| <a name="input_abfs_bucket_location"></a> [abfs\_bucket\_location](#input\_abfs\_bucket\_location) | The location of the ABFS bucket (https://cloud.google.com/storage/docs/locations). | `string` | n/a | yes |
| <a name="input_abfs_bucket_name"></a> [abfs\_bucket\_name](#input\_abfs\_bucket\_name) | The name of the ABFS bucket. | `string` | `"abfs"` | no |
| <a name="input_abfs_docker_image_uri"></a> [abfs\_docker\_image\_uri](#input\_abfs\_docker\_image\_uri) | Docker image URI for the ABFS server | `string` | n/a | yes |
| <a name="input_abfs_license"></a> [abfs\_license](#input\_abfs\_license) | ABFS license (JSON) | `string` | n/a | yes |
| <a name="input_abfs_server_allow_stopping_for_update"></a> [abfs\_server\_allow\_stopping\_for\_update](#input\_abfs\_server\_allow\_stopping\_for\_update) | Allow to stop the server to update properties | `bool` | `true` | no |
| <a name="input_abfs_server_cos_image_ref"></a> [abfs\_server\_cos\_image\_ref](#input\_abfs\_server\_cos\_image\_ref) | Reference to the COS boot image to use for the ABFS server | `string` | `"projects/cos-cloud/global/images/family/cos-109-lts"` | no |
| <a name="input_abfs_server_machine_type"></a> [abfs\_server\_machine\_type](#input\_abfs\_server\_machine\_type) | Machine type for ABFS servers | `string` | `"n2-highmem-128"` | no |
| <a name="input_abfs_server_name"></a> [abfs\_server\_name](#input\_abfs\_server\_name) | Name for the ABFS server | `string` | `"abfs-server"` | no |
| <a name="input_abfs_spanner_database_create_tables"></a> [abfs\_spanner\_database\_create\_tables](#input\_abfs\_spanner\_database\_create\_tables) | Creates the tables in the database using the online DDL schema with the given schema version. | `bool` | `false` | no |
| <a name="input_abfs_spanner_database_name"></a> [abfs\_spanner\_database\_name](#input\_abfs\_spanner\_database\_name) | A unique identifier for the ABFS database, which cannot be changed after the instance is created. | `string` | `"abfs"` | no |
| <a name="input_abfs_spanner_database_schema_version"></a> [abfs\_spanner\_database\_schema\_version](#input\_abfs\_spanner\_database\_schema\_version) | The version of the DDL schema to use for the ABFS database. | `string` | `"0.0.31"` | no |
| <a name="input_abfs_spanner_instance_config"></a> [abfs\_spanner\_instance\_config](#input\_abfs\_spanner\_instance\_config) | The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your ABFS database in this instance. | `string` | n/a | yes |
| <a name="input_abfs_spanner_instance_display_name"></a> [abfs\_spanner\_instance\_display\_name](#input\_abfs\_spanner\_instance\_display\_name) | The descriptive name for the ABFS instance as it appears in UIs. | `string` | `"ABFS"` | no |
| <a name="input_abfs_spanner_instance_name"></a> [abfs\_spanner\_instance\_name](#input\_abfs\_spanner\_instance\_name) | A unique identifier for the ABFS instance, which cannot be changed after the instance is created. | `string` | `"abfs"` | no |
| <a name="input_existing_bucket_name"></a> [existing\_bucket\_name](#input\_existing\_bucket\_name) | The name of the existing ABFS bucket to use. If not specified, a new bucket will be created. | `string` | `""` | no |
| <a name="input_goog_cm_deployment_name"></a> [goog\_cm\_deployment\_name](#input\_goog\_cm\_deployment\_name) | The name of the deployment for Marketplace | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email of service account to attach to the servers | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnetwork for the servers | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone for ABFS servers | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_abfs_bucket_name"></a> [abfs\_bucket\_name](#output\_abfs\_bucket\_name) | The ABFS GCS bucket name |
| <a name="output_abfs_server_name"></a> [abfs\_server\_name](#output\_abfs\_server\_name) | The name of the ABFS server instance |
| <a name="output_abfs_spanner_database"></a> [abfs\_spanner\_database](#output\_abfs\_spanner\_database) | The ABFS Spanner database object |
| <a name="output_abfs_spanner_database_schema_file"></a> [abfs\_spanner\_database\_schema\_file](#output\_abfs\_spanner\_database\_schema\_file) | The ABFS Spanner database schema file |
| <a name="output_abfs_spanner_database_schema_version"></a> [abfs\_spanner\_database\_schema\_version](#output\_abfs\_spanner\_database\_schema\_version) | The schema version used for the ABFS Spanner database |
| <a name="output_abfs_spanner_instance"></a> [abfs\_spanner\_instance](#output\_abfs\_spanner\_instance) | The ABFS Spanner instance object |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
