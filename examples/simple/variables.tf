# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# General Project & Naming

variable "project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "enable_apis" {
  type        = bool
  description = "Whether to enable the required APIs."
  default     = true
}

# Location/Region Variables

# go/keep-sorted start block=yes newline_separated=yes
variable "artifact_registry_region" {
  type        = string
  description = "The region for Artifact Registry."
  default     = "europe-west4"
}

variable "cloud_build_region" {
  type        = string
  description = "The region for Cloud Build."
  default     = "europe-west4"
}

variable "region" {
  type        = string
  description = "Region for ABFS resources"
  default     = "europe-west4"
}

variable "secret_manager_region" {
  type        = string
  description = "The region for Secret Manager."
  default     = "europe-west4"
}

variable "secure_source_manager_region" {
  type        = string
  description = "The region for the Secure Source Manager instance, cf. https://cloud.google.com/secure-source-manager/docs/locations."
  default     = "europe-west4"
}

variable "zone" {
  type        = string
  description = "Zone for ABFS compute instance resources"
}
# go/keep-sorted end

# Networking

# go/keep-sorted start block=yes newline_separated=yes
variable "abfs_network_name" {
  type        = string
  description = "Name of the ABFS network"
  default     = "abfs-network"
}

variable "abfs_subnet_ip" {
  type        = string
  description = "IP range for the ABFS subnetwork"
  default     = "10.2.0.0/16"
}

variable "abfs_subnet_name" {
  type        = string
  description = "Name of the ABFS subnetwork"
  default     = "abfs-subnet"
}

variable "abfs_subnet_private_access" {
  type        = bool
  description = "Enable private Google access for the ABFS subnetwork"
  default     = true
}
# go/keep-sorted end

# Domain Name System (DNS)

# go/keep-sorted start block=yes newline_separated=yes
variable "create_dns_zones" {
  type        = bool
  description = "Whether to create the DNS zones for private access to Artifact Registry"
  default     = true
}
# go/keep-sorted end

# Monitoring

# go/keep-sorted start block=yes newline_separated=yes
variable "alert_notification_email" {
  type        = string
  description = "Email address to send alert notifications to"
}
# go/keep-sorted end

# Android Build Fileystem (ABFS)

# go/keep-sorted start block=yes newline_separated=yes
variable "abfs_bucket_location" {
  type        = string
  description = "The location of the ABFS bucket (https://cloud.google.com/storage/docs/locations)."
}

variable "abfs_client_config" {
  type = object({
    name                  = string
    machine_type          = string
    image_project         = string
    image_name            = string
    size                  = number
    type                  = string
    scopes                = list(string)
    goog_ops_agent_policy = string
    preemptible           = bool
    automatic_restart     = bool
    enable_oslogin        = bool
    can_ip_forward        = bool
    deletion_protection   = bool
    enable_display        = bool
    shielded_instance_config = object({
      enable_integrity_monitoring = bool
      enable_secure_boot          = bool
      enable_vtpm                 = bool
    })
  })
  description = "Configuration for the ABFS client compute instance."
  default = {
    name          = "abfs-client"
    machine_type  = "n1-standard-8"
    image_project = "ubuntu-os-cloud"
    image_name    = "ubuntu-minimal-2404-noble-amd64-v20250818"
    size          = 2000
    type          = "pd-ssd"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
    goog_ops_agent_policy = "v2-x86-template-1-4-0"
    preemptible           = true
    automatic_restart     = false
    enable_oslogin        = true
    can_ip_forward        = false
    deletion_protection   = false
    enable_display        = false
    shielded_instance_config = {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
      enable_vtpm                 = true
    }
  }
}

variable "abfs_docker_image_uri" {
  type        = string
  description = "Docker image URI for ABFS"
}

variable "abfs_enable_git_lfs" {
  type        = bool
  description = "Enable Git LFS support"
  default     = false
}

variable "abfs_gerrit_uploader_count" {
  type        = number
  description = "The number of gerrit uploader instances to create"
  default     = 3
}

variable "abfs_gerrit_uploader_datadisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s)"
  default     = 4096
}

variable "abfs_gerrit_uploader_git_branch" {
  type        = set(string)
  description = "Branches from where to find projects (e.g. [\"main\",\"v-keystone-qcom-release\"]) (default [\"main\"])"
  default     = ["main"]
}

variable "abfs_gerrit_uploader_machine_type" {
  type        = string
  description = "Machine type for ABFS gerrit uploaders"
  default     = "n2d-standard-48"
}

variable "abfs_gerrit_uploader_manifest_server" {
  type        = string
  description = "The manifest server to assume"
  default     = "android.googlesource.com"
}

# If you don't have an ABFS license yet, leave this empty and run terraform apply.
# Submit the output via the Early Access Program (EAP) form.
# When you received a license, insert it in your terraform.tfvars file and run terraform apply again.
variable "abfs_license" {
  type        = string
  description = "ABFS license (JSON)"
  default     = ""
}

variable "abfs_manifest_file" {
  type        = string
  description = "Relative path from the manifest project root to the manifest file"
  default     = "default.xml"
}

variable "abfs_manifest_project_name" {
  type        = string
  description = "Name of the git project on the manifest-server containing manifests"
  default     = "platform/manifest"
}

variable "abfs_server_machine_type" {
  type        = string
  description = "Machine type for ABFS servers"
  default     = "n2-highmem-128"
}

variable "abfs_spanner_database_create_tables" {
  type        = bool
  description = "Creates the tables in the database."
  default     = false
}

variable "abfs_spanner_instance_config" {
  type        = string
  description = "The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your ABFS database in this instance (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_instance.html#config-1)."
}

variable "create_client_instance_resource" {
  type        = bool
  description = "Whether to create a Google Cloud Engine compute instance for an ABFS client"
  default     = false
}
# go/keep-sorted end

# Service Accounts

# go/keep-sorted start block=yes newline_separated=yes
variable "client_service_account_id" {
  type        = string
  description = "Service account ID (e.g. abfs-client@<project-id>.iam.gserviceaccount.com) used for the ABFS client. If not specified, a new service account will be created using the value of client_service_account_name."
  default     = ""
  nullable    = false
}

variable "client_service_account_name" {
  type        = string
  description = "The name of the service account to create in case client_service_account_id is not specified."
  default     = "abfs-client"
}

variable "server_service_account_id" {
  type        = string
  description = "Service account ID (e.g. abfs-server@<project-id>.iam.gserviceaccount.com) used for the ABFS server. If not specified, a new service account will be created using the value of server_service_account_name."
  default     = ""
  nullable    = false
}

variable "server_service_account_name" {
  type        = string
  description = "The name of the service account to create in case server_service_account_id is not specified."
  default     = "abfs-server"
}

variable "uploader_service_account_id" {
  type        = string
  description = "Service account ID (e.g. abfs-uploader@<project-id>.iam.gserviceaccount.com) used for the ABFS uploader. If not specified, a new service account will be created using the value of uploader_service_account_name."
  default     = ""
  nullable    = false
}

variable "uploader_service_account_name" {
  type        = string
  description = "The name of the service account to create in case uploader_service_account_name is not specified."
  default     = "abfs-uploader"
}
# go/keep-sorted end

# Cloud Workstations

# go/keep-sorted start block=yes newline_separated=yes
variable "create_cloud_workstation_resources" {
  type        = bool
  description = "Whether to create Cloud Workstation resources"
  default     = false
}

variable "cws_clusters" {
  type = map(object({
    network    = string
    region     = string
    subnetwork = string
  }))
  description = "A map of Cloud Workstation clusters to create. The key of the map is used as the unique ID for the cluster."
  default     = {}
  validation {
    condition     = ! var.create_cloud_workstation_resources || length(var.cws_clusters) > 0
    error_message = "cws_clusters is required when create_cloud_workstation_resources is enabled."
  }
}

variable "cws_configs" {
  type = map(object({
    # go/keep-sorted start
    boot_disk_size_gb            = number
    creators                     = optional(list(string))
    custom_image_names           = optional(list(string))
    cws_cluster                  = string
    disable_public_ip_addresses  = bool
    display_name                 = optional(string)
    enable_nested_virtualization = bool
    idle_timeout_seconds         = number
    image                        = optional(string)
    instances = optional(list(object({
      name         = string
      display_name = optional(string)
      users        = list(string)
    })))
    machine_type                    = string
    persistent_disk_fs_type         = optional(string)
    persistent_disk_reclaim_policy  = string
    persistent_disk_size_gb         = optional(number)
    persistent_disk_source_snapshot = optional(string)
    persistent_disk_type            = string
    pool_size                       = number
    # go/keep-sorted end
  }))
  description = "A map of Cloud Workstation configurations."
  default     = {}
  validation {
    condition     = ! var.create_cloud_workstation_resources || length(var.cws_configs) > 0
    error_message = "cws_configs is required when create_cloud_workstation_resources is enabled."
  }
}

variable "cws_custom_images" {
  type = map(object({
    build = optional(object({
      dockerfile_path = optional(string)
      timeout_seconds = number
      machine_type    = string
      })
    )
    workstation_config = optional(object({
      scheduler_region = string
      ci_schedule      = string
    }))
  }))
  description = <<-EOT
    Map of custom images for Cloud Workstations and their build configuration.
  EOT
  default = {
    // go/keep-sorted start block=yes
    "android-studio" : {
      build = {
        dockerfile_path = "workloads/cloud-workstations/pipelines/workstation-images/horizon-android-studio"
        timeout_seconds = 7200
        machine_type    = "E2_HIGHCPU_32"
      }
    },
    "android-studio-for-platform" : {
      build = {
        dockerfile_path = "workloads/cloud-workstations/pipelines/workstation-images/horizon-asfp"
        timeout_seconds = 7200
        machine_type    = "E2_HIGHCPU_32"
      }
    },
    "code-oss" : {
      build = {
        dockerfile_path = "workloads/cloud-workstations/pipelines/workstation-images/horizon-code-oss"
        timeout_seconds = 7200
        machine_type    = "E2_HIGHCPU_32"
      }
    },
    // go/keep-sorted end
  }
}

# go/keep-sorted end

# Source Control (GitHub & Secure Source Manager)

# go/keep-sorted start block=yes newline_separated=yes
variable "git_branch_trigger" {
  type        = string
  description = "The Secure Source Manager (SSM) branch that triggers Cloud Build on push."
  default     = "main"
}

variable "secure_source_manager_instance_name" {
  type        = string
  description = "The name of the Secure Source Manager instance to create, if secure_source_manager_instance_id is null."
  default     = "cicd-foundation"
}

variable "secure_source_manager_repo_git_url_to_clone" {
  type        = string
  description = "The URL of a Git repository to clone into the new Secure Source Manager repository. If null, cloning is skipped."
  default     = "https://github.com/GoogleCloudPlatform/horizon-sdv.git"
}

variable "secure_source_manager_repo_name" {
  type        = string
  description = "The name of the Secure Source Manager repository."
  default     = "horizon-sdv"
}
# go/keep-sorted end
