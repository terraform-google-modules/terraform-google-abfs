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

variable "project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "region" {
  type        = string
  description = "Region for ABFS servers"
}

variable "zone" {
  type        = string
  description = "Zone for ABFS servers"
}

variable "abfs_docker_image_uri" {
  type        = string
  description = "Docker image URI for ABFS"
}

variable "abfs_gerrit_uploader_git_branch" {
  type        = set(string)
  description = "Branches from where to find projects (e.g. [\"main\",\"v-keystone-qcom-release\"]) (default [\"main\"])"
  default     = ["main"]
}

variable "abfs_manifest_project_name" {
  type        = string
  description = "Name of the git project on the manifest-server containing manifests"
  default     = "platform/manifest"
}

variable "abfs_manifest_file" {
  type        = string
  description = "Relative path from the manifest project root to the manifest file"
  default     = "default.xml"
}

variable "abfs_gerrit_uploader_count" {
  type        = number
  description = "The number of gerrit uploader instances to create"
  default     = 3
}

variable "abfs_gerrit_uploader_machine_type" {
  type        = string
  description = "Machine type for ABFS gerrit uploaders"
  default     = "n2d-standard-48"
}

variable "abfs_gerrit_uploader_datadisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s)"
  default     = 4096
}

variable "abfs_gerrit_uploader_manifest_server" {
  type        = string
  description = "The manifest server to assume"
  default     = "android.googlesource.com"
}

variable "abfs_license" {
  type        = string
  description = "ABFS license (JSON)"
}

variable "alert_notification_email" {
  type        = string
  description = "Email address to send alert notifications to"
}

variable "abfs_service_account_id" {
  type        = string
  description = "ABFS service account ID (e.g. abfs@<project-id>.iam.gserviceaccount.com); if not specified, a new service account will be created using the abfs_service_account_name."
  default     = ""
}

variable "abfs_service_account_name" {
  type        = string
  description = "The name of the service account to create in case abfs_service_account_id is not specified."
  default     = "abfs"
}

variable "abfs_server_machine_type" {
  type        = string
  description = "Machine type for ABFS servers"
  default     = "n2-highmem-128"
}

variable "abfs_bucket_location" {
  type        = string
  description = "The location of the ABFS bucket (https://cloud.google.com/storage/docs/locations)."
}

variable "abfs_spanner_instance_config" {
  type        = string
  description = "The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your ABFS database in this instance (https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/spanner_instance.html#config-1)."
}

variable "abfs_spanner_database_create_tables" {
  type        = bool
  description = "Creates the tables in the database."
  default     = false
}

variable "abfs_enable_git_lfs" {
  type        = bool
  description = "Enable Git LFS support"
  default     = false
}

variable "create_dns_zones" {
  type        = bool
  description = "Whether to create the DNS zones for private access to Artifact Registry"
  default     = true
}

variable "create_cloud_workstation_resources" {
  type        = bool
  description = "Whether to create Cloud Workstation resources"
  default     = false
}

variable "cws_scopes" {
  type        = list(string)
  description = "The scope of the Cloud Workstations Service Account"
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
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
    condition     = !var.create_cloud_workstation_resources || length(var.cws_clusters) > 0
    error_message = "cws_clusters is required when create_cloud_workstation_resources is enabled."
  }
}

variable "cws_configs" {
  type = map(object({
    cws_cluster                    = string
    idle_timeout                   = number
    machine_type                   = string
    boot_disk_size_gb              = number
    disable_public_ip_addresses    = bool
    pool_size                      = number
    enable_nested_virtualization   = bool
    persistent_disk_size_gb        = number
    persistent_disk_fs_type        = string
    persistent_disk_type           = string
    persistent_disk_reclaim_policy = string
    creators                       = optional(list(string))
    image                          = optional(string)
    instances = list(object({
      name  = string
      users = list(string)
    }))
  }))
  description = "A map of Cloud Workstation configurations."
  default     = {}
  validation {
    condition     = !var.create_cloud_workstation_resources || length(var.cws_configs) > 0
    error_message = "cws_configs is required when create_cloud_workstation_resources is enabled."
  }
}
