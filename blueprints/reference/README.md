# ABFS Environment Blueprint

This blueprint deploys a complete Android Build Filesystem (ABFS) environment on
Google Cloud. It provides a scalable and secure solution for building Android
and is ideal for teams looking to modernize their Android development
infrastructure. The blueprint also includes a sophisticated CI/CD pipeline for
creating and maintaining custom developer environments using Cloud Workstations.

## Deployed Resources

This blueprint will deploy the following key resources to stand up a fully
functional ABFS environment:

-   **Spanner Instance and Database**: A fully managed, mission-critical,
    relational database service that provides a scalable and highly available
    backend for ABFS.
-   **ABFS Server**: The core component of the Android Build Filesystem,
    deployed on Google Compute Engine (GCE).
-   **ABFS Uploaders**: Services responsible for uploading build artifacts into
    the ABFS environment.
-   **Optional ABFS Client**: A Compute Engine instance can be optionally
    created to act as a client for interacting with and testing the ABFS setup.

## ABFS Licensing and Deployment Flow

Deploying the ABFS environment involves a two-step process due to licensing
requirements:

1.  **Initial `terraform apply`**: Run `terraform apply` for the first time.
    This will provision the necessary project infrastructure and output the
    license information.

2.  **Submit EAP Form**: Use the license information from the Terraform output
    to fill out the EAP (Early Access Program) form provided by the Google team.
    This will initiate the licensing process for your service account.

3.  **Update `terraform.tfvars`**: Once you receive the license key, add it to
    your `terraform.tfvars` file. For example:
    ```hcl
    abfs_license = "your-license-key-here"
    ```

4.  **Final `terraform apply`**: Run `terraform apply` a second time. With the
    license key in place, Terraform will now deploy and start all the ABFS
    components, including the server and uploaders.

5.  **Seeding and Building**: After the deployment is complete, the ABFS
    uploaders will begin seeding the environment with data from the Gerrit
    server. Once this process is finished, you can use the ABFS client to mount
    the filesystem and start your first Android build.

## Automated Custom Images for Cloud Workstations

A key feature of this blueprint is its ability to create and manage custom
container images for
[Cloud Workstations](https://cloud.google.com/workstations). This allows you to
provide developers with tailored, up-to-date, and secure development
environments like **Android Studio (AS)**,
**Android Studio for Platform (ASfP)**, and **CodeOSS**.

The blueprint sets up a complete, GitOps-driven CI/CD pipeline to automate the
build, deployment, and maintenance of these custom images.

### The CI/CD Workflow for Custom Images

The process is designed to be fully automated after the initial setup:

1.  **Initial Deployment (`terraform apply`)**:
    When you first apply the Terraform configuration for this blueprint, it
    provisions the entire CI/CD foundation, including:
    *   A **Secure Source Manager (SSM)** repository to host the source code for
        your custom images. This repository is initialized by cloning the Git
        repository if specified in `secure_source_manager_repo_git_url_to_clone`.
    *   A **Cloud Build trigger** configured with a webhook to automatically
        start a build on a `git push` to the SSM repository.
        If `secure_source_manager_repo_git_url_to_clone` is specified, the
        initial clone and push to the SSM repository triggers a first build of
        the images.
    *   An **Artifact Registry** repository to securely store the built
        container images.
    *   **Cloud Workstations configurations** that are pre-configured to use the
        `:latest` tag of your custom images.
    *   A **Cloud Scheduler** job to periodically rebuild the images.

2.  **Automated Build and Deployment**:
    Every `git push` to the SSM repository automatically triggers the
    Cloud Build pipeline via a webhook. Cloud Build:
    *   Builds the container image from your Dockerfile.
    *   Pushes the newly built image to Artifact Registry.
    *   Tags the image as `:latest`.

3.  **Periodic Rebuilds for Security**:
    The Cloud Scheduler job runs on a defined schedule (e.g., nightly) and
    triggers the same Cloud Build pipeline. This is critical for security and
    maintenance, as it ensures your custom images are regularly rebuilt on top
    of their base layers. This process automatically incorporates the latest OS
    updates and security patches into your development environments without any
    manual intervention.

4.  **Seamless User Experience**:
    When a developer starts a new Cloud Workstation, it automatically pulls the
    `:latest` image tag from Artifact Registry. Because of the automated build
    and periodic rebuild process, they are always launching a workstation that
    is up-to-date, secure, and contains the preinstalled tools they need.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| abfs\_bucket\_location | The location of the ABFS bucket (https://cloud.google.com/storage/docs/locations). | `string` | `"europe-west1"` | no |
| abfs\_client\_config | Configuration for the ABFS client compute instance. | <pre>object({<br>    name                  = string<br>    machine_type          = string<br>    image_project         = string<br>    image_name            = string<br>    size                  = number<br>    type                  = string<br>    scopes                = list(string)<br>    goog_ops_agent_policy = string<br>    preemptible           = bool<br>    automatic_restart     = bool<br>    enable_oslogin        = bool<br>    can_ip_forward        = bool<br>    deletion_protection   = bool<br>    enable_display        = bool<br>    shielded_instance_config = object({<br>      enable_integrity_monitoring = bool<br>      enable_secure_boot          = bool<br>      enable_vtpm                 = bool<br>    })<br>  })</pre> | <pre>{<br>  "automatic_restart": false,<br>  "can_ip_forward": false,<br>  "deletion_protection": false,<br>  "enable_display": false,<br>  "enable_oslogin": true,<br>  "goog_ops_agent_policy": "v2-x86-template-1-4-0",<br>  "image_name": "ubuntu-minimal-2404-noble-amd64-v20250818",<br>  "image_project": "ubuntu-os-cloud",<br>  "machine_type": "n1-standard-8",<br>  "name": "abfs-client",<br>  "preemptible": true,<br>  "scopes": [<br>    "cloud-platform"<br>  ],<br>  "shielded_instance_config": {<br>    "enable_integrity_monitoring": true,<br>    "enable_secure_boot": false,<br>    "enable_vtpm": true<br>  },<br>  "size": 2000,<br>  "type": "pd-ssd"<br>}</pre> | no |
| abfs\_docker\_image\_uri | Docker image URI for ABFS | `string` | `"europe-docker.pkg.dev/abfs-binaries/abfs-containers-alpha/abfs-alpha:0.1.1"` | no |
| abfs\_enable\_git\_lfs | Enable Git LFS support | `bool` | `false` | no |
| abfs\_gerrit\_uploader\_count | The number of gerrit uploader instances to create | `number` | `3` | no |
| abfs\_gerrit\_uploader\_datadisk\_size\_gb | Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s) | `number` | `4096` | no |
| abfs\_gerrit\_uploader\_git\_branch | Branches from where to find projects (e.g. ["main","v-keystone-qcom-release"]) (default ["main"]) | `set(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| abfs\_gerrit\_uploader\_machine\_type | Machine type for ABFS gerrit uploaders | `string` | `"n2d-standard-48"` | no |
| abfs\_gerrit\_uploader\_manifest\_scheme | The manifest scheme to assume | `string` | `"https"` | no |
| abfs\_gerrit\_uploader\_manifest\_server | The manifest server to assume | `string` | `"android.googlesource.com"` | no |
| abfs\_license | ABFS license (JSON) | `string` | `""` | no |
| abfs\_manifest\_file | Relative path from the manifest project root to the manifest file | `string` | `"default.xml"` | no |
| abfs\_manifest\_project\_name | Name of the git project on the manifest-server containing manifests | `string` | `"platform/manifest"` | no |
| abfs\_network\_name | Name of the ABFS network | `string` | `"abfs-network"` | no |
| abfs\_server\_machine\_type | Machine type for ABFS servers | `string` | `"n2-highmem-128"` | no |
| abfs\_spanner\_database\_create\_tables | Creates the tables in the database. | `bool` | `false` | no |
| abfs\_spanner\_instance\_config | The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your ABFS database in this instance (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_instance.html#config-1). | `string` | `"regional-europe-west1"` | no |
| abfs\_subnet\_ip | IP range for the ABFS subnetwork | `string` | `"10.2.0.0/16"` | no |
| abfs\_subnet\_name | Name of the ABFS subnetwork | `string` | `"abfs-subnet"` | no |
| abfs\_subnet\_private\_access | Enable private Google access for the ABFS subnetwork | `bool` | `true` | no |
| abfs\_ui\_machine\_type | Machine type for ABFS UI | `string` | `"n2d-standard-8"` | no |
| alert\_notification\_email | Email address to send alert notifications to | `string` | n/a | yes |
| artifact\_registry\_region | The region for Artifact Registry. | `string` | `"europe-west4"` | no |
| binary\_authorization\_always\_create | If true, create Binary Authorization resources even if kritis\_signer\_image is not provided. | `bool` | `false` | no |
| client\_service\_account\_id | Service account ID (e.g. abfs-client@<project-id>.iam.gserviceaccount.com) used for the ABFS client. If not specified, a new service account will be created using the value of client\_service\_account\_name. | `string` | `""` | no |
| client\_service\_account\_name | The name of the service account to create in case client\_service\_account\_id is not specified. | `string` | `"abfs-client"` | no |
| cloud\_build\_region | The region for Cloud Build. | `string` | `"europe-west4"` | no |
| create\_client\_instance\_resource | Whether to create a Google Cloud Engine compute instance for an ABFS client | `bool` | `false` | no |
| create\_cloud\_workstation\_resources | Whether to create Cloud Workstation resources | `bool` | `false` | no |
| create\_dns\_zones | Whether to create the DNS zones for private access to Artifact Registry | `bool` | `true` | no |
| cws\_clusters | A map of Cloud Workstation clusters to create. The key of the map is used as the unique ID for the cluster. | <pre>map(object({<br>    network    = string<br>    region     = string<br>    subnetwork = string<br>  }))</pre> | `{}` | no |
| cws\_configs | A map of Cloud Workstation configurations. | <pre>map(object({<br>    # go/keep-sorted start<br>    accelerators = optional(list(object({<br>      type  = string<br>      count = number<br>    })), [])<br>    boost_configs = optional(list(object({<br>      id = string<br>      accelerators = optional(list(object({<br>        type  = string<br>        count = number<br>      })), [])<br>      boot_disk_size_gb            = optional(number)<br>      enable_nested_virtualization = optional(bool)<br>      machine_type                 = optional(string)<br>      pool_size                    = optional(number)<br>    })), [])<br>    boot_disk_size_gb            = optional(number, 100)<br>    creators                     = optional(list(string))<br>    custom_image_names           = optional(list(string))<br>    cws_cluster                  = string<br>    disable_public_ip_addresses  = bool<br>    display_name                 = optional(string)<br>    enable_nested_virtualization = bool<br>    idle_timeout_seconds         = number<br>    image                        = optional(string)<br>    instances = optional(list(object({<br>      name         = string<br>      display_name = optional(string)<br>      users        = list(string)<br>    })))<br>    machine_type                    = string<br>    persistent_disk_fs_type         = optional(string)<br>    persistent_disk_reclaim_policy  = optional(string, "RETAIN")<br>    persistent_disk_size_gb         = optional(number)<br>    persistent_disk_source_snapshot = optional(string)<br>    persistent_disk_type            = string<br>    pool_size                       = number<br>    shielded_instance_config = optional(object({<br>      enable_secure_boot          = optional(bool, true)<br>      enable_vtpm                 = optional(bool, true)<br>      enable_integrity_monitoring = optional(bool, true)<br>    }), null)<br>    # go/keep-sorted end<br>  }))</pre> | `{}` | no |
| cws\_custom\_images | Map of custom images for Cloud Workstations and their build configuration. | <pre>map(object({<br>    build = optional(object({<br>      skaffold_path   = optional(string)<br>      timeout_seconds = number<br>      machine_type    = string<br>      })<br>    )<br>    workstation_config = optional(object({<br>      scheduler_region = string<br>      ci_schedule      = string<br>    }))<br>  }))</pre> | <pre>{<br>  "android-studio": {<br>    "build": {<br>      "machine_type": "E2_HIGHCPU_32",<br>      "skaffold_path": "workloads/cloud-workstations/pipelines/workstation-images/horizon-android-studio",<br>      "timeout_seconds": 7200<br>    }<br>  },<br>  "android-studio-for-platform": {<br>    "build": {<br>      "machine_type": "E2_HIGHCPU_32",<br>      "skaffold_path": "workloads/cloud-workstations/pipelines/workstation-images/horizon-asfp",<br>      "timeout_seconds": 7200<br>    }<br>  },<br>  "code-oss": {<br>    "build": {<br>      "machine_type": "E2_HIGHCPU_32",<br>      "skaffold_path": "workloads/cloud-workstations/pipelines/workstation-images/horizon-code-oss",<br>      "timeout_seconds": 7200<br>    }<br>  }<br>}</pre> | no |
| cws\_region | The region for Cloud Workstation resources. | `string` | `"europe-west4"` | no |
| cws\_subnet\_ip | IP range for the CWS subnetwork | `string` | `"10.3.0.0/16"` | no |
| cws\_subnet\_name | Name of the CWS subnetwork | `string` | `"cws-subnet"` | no |
| cws\_subnet\_private\_access | Enable private Google access for the CWS subnetwork | `bool` | `true` | no |
| enable\_apis | Whether to enable the required APIs. | `bool` | `true` | no |
| git\_branch\_trigger | The Secure Source Manager (SSM) branch that triggers Cloud Build on push. | `string` | `"main"` | no |
| project\_id | Google Cloud project ID | `string` | n/a | yes |
| region | The region for ABFS resources | `string` | `"europe-west4"` | no |
| secret\_manager\_region | The region for Secret Manager. | `string` | `"europe-west4"` | no |
| secure\_source\_manager\_instance\_name | The name of the Secure Source Manager instance to create, if secure\_source\_manager\_instance\_id is null. | `string` | `"cicd-foundation"` | no |
| secure\_source\_manager\_region | The region for the Secure Source Manager instance, cf. https://cloud.google.com/secure-source-manager/docs/locations. | `string` | `"europe-west4"` | no |
| secure\_source\_manager\_repo\_git\_url\_to\_clone | The URL of a Git repository to clone into the new Secure Source Manager repository. If null, cloning is skipped. | `string` | `"https://github.com/GoogleCloudPlatform/horizon-sdv.git"` | no |
| secure\_source\_manager\_repo\_name | The name of the Secure Source Manager repository. | `string` | `"horizon-sdv"` | no |
| server\_service\_account\_id | Service account ID (e.g. abfs-server@<project-id>.iam.gserviceaccount.com) used for the ABFS server. If not specified, a new service account will be created using the value of server\_service\_account\_name. | `string` | `""` | no |
| server\_service\_account\_name | The name of the service account to create in case server\_service\_account\_id is not specified. | `string` | `"abfs-server"` | no |
| ui\_service\_account\_id | Service account ID (e.g. abfs-ui@<project-id>.iam.gserviceaccount.com) used for the ABFS UI. If not specified, a new service account will be created using the value of ui\_service\_account\_name. | `string` | `""` | no |
| ui\_service\_account\_name | The name of the service account to create in case ui\_service\_account\_id is not specified. | `string` | `"abfs-ui"` | no |
| uploader\_service\_account\_id | Service account ID (e.g. abfs-uploader@<project-id>.iam.gserviceaccount.com) used for the ABFS uploader. If not specified, a new service account will be created using the value of uploader\_service\_account\_name. | `string` | `""` | no |
| uploader\_service\_account\_name | The name of the service account to create in case uploader\_service\_account\_name is not specified. | `string` | `"abfs-uploader"` | no |
| zone | Zone for ABFS compute instance resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| license\_information | n/a |
| spanner\_database\_schema\_creation | The CLI command for creating the Spanner database schema |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
