# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
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

variable "zone" {
  type        = string
  description = "Zone for ABFS servers"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for the servers"
}

variable "service_account_email" {
  type        = string
  description = "Email of service account to attach to the servers"
}

variable "abfs_server_allow_stopping_for_update" {
  type        = bool
  description = "Allow to stop the server to update properties"
  default     = true
}

variable "abfs_server_machine_type" {
  type        = string
  description = "Machine type for ABFS servers"
  default     = "n2-highmem-128"
}

# TODO - consider a single prefix that could be used for all VMs and datadisks across the deployment
# E.g. "dev". Then all resources would get non-configurable postfixes yielding names like:
#   * dev-abfs-server
#   * dev-abfs-server-datadisk
#   * dev-abfs-server-gerrit-uploader-0
#   * dev-abfs-server-getrit-uploader-datadisk-0
variable "abfs_server_name" {
  type        = string
  description = "Name for the ABFS server"
  default     = "abfs-server"
}

variable "abfs_server_cos_image_ref" {
  type        = string
  description = "Reference to the COS boot image to use for the ABFS server"
  default     = "projects/cos-cloud/global/images/family/cos-109-lts"
}

variable "abfs_license" {
  type        = string
  description = "ABFS license (JSON)"
}

variable "abfs_docker_image_uri" {
  type        = string
  description = "Docker image URI for the ABFS server"
}

variable "abfs_bootdisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS bootdisk that will be attached to the VM"
  default     = 100
}

variable "abfs_bootdisk_type" {
  type        = string
  description = "The PD regional disk type to use for the ABFS bootdisk"
  default     = "pd-ssd"
}

// Google Cloud Storage
variable "existing_bucket_name" {
  type        = string
  description = "The name of the existing ABFS bucket to use. If not specified, a new bucket will be created."
  default     = ""
}

variable "abfs_bucket_name" {
  type        = string
  description = "The name of the ABFS bucket."
  default     = "abfs"
}

variable "abfs_bucket_location" {
  type        = string
  description = "The location of the ABFS bucket (https://cloud.google.com/storage/docs/locations)."
}

// Google Cloud Spanner
variable "abfs_spanner_instance_name" {
  type        = string
  description = "A unique identifier for the ABFS instance, which cannot be changed after the instance is created."
  default     = "abfs"
}

variable "abfs_spanner_instance_display_name" {
  type        = string
  description = "The descriptive name for the ABFS instance as it appears in UIs."
  default     = "ABFS"
}

variable "abfs_spanner_instance_config" {
  type        = string
  description = "The name of the instance's configuration (similar but not quite the same as a region) which defines the geographic placement and replication of your ABFS database in this instance."
}

variable "abfs_spanner_database_name" {
  type        = string
  description = "A unique identifier for the ABFS database, which cannot be changed after the instance is created."
  default     = "abfs"
}

variable "abfs_spanner_database_create_tables" {
  type        = bool
  description = "Creates the tables in the database using the online DDL schema with the given schema version."
  default     = false
}

variable "abfs_spanner_database_schema_version" {
  type        = string
  description = "The version of the DDL schema to use for the ABFS database."
  default     = "0.0.31"
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  type        = string
  description = "The name of the deployment for Marketplace"
  default     = ""
}
