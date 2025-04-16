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
  description = "Google Cloud project ID"
  type        = string
}

variable "zone" {
  description = "Zone for ABFS servers"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork for the servers"
  type        = string
}

variable "service_account_email" {
  description = "Email of service account to attach to the servers"
  type        = string
}

variable "abfs_gerrit_uploader_count" {
  default     = 3
  description = "The number of gerrit uploader instances to create"
  type        = number
}

variable "abfs_gerrit_uploader_machine_type" {
  default     = "n2d-standard-48"
  description = "Machine type for ABFS gerrit uploaders"
  type        = string
}

variable "abfs_gerrit_uploader_name_prefix" {
  default     = "abfs-gerrit-uploader"
  description = "Name prefix for the ABFS gerrit uploader VM(s)"
  type        = string
}

variable "abfs_gerrit_uploader_datadisk_name_prefix" {
  default     = "abfs-gerrit-uploader-datadisk"
  description = "A name prefix for the ABFS gerrit uploader datadisk(s) that will be attached to VM(s). Note, this does not affect the mounting of the disk - the device name is always set to \"abfs-server-storage\""
  type        = string
}

variable "abfs_gerrit_uploader_datadisk_size_gb" {
  default     = 4096
  description = "Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s)"
  type        = number
}

variable "abfs_gerrit_uploader_datadisk_type" {
  default     = "pd-ssd"
  description = "The PD regional disk type to use for the ABFS gerrit uploader datadisk(s)"
  type        = string
}

variable "abfs_gerrit_uploader_git_servers" {
  description = "List of git servers to upload to the ABFS server (e.g. [\"android.googlesource.com\"])"
  type        = list(string)
}

variable "abfs_gerrit_uploader_git_branch" {
  default     = "main"
  description = "Git branch to upload to the ABFS server (e.g. main)"
  type        = string
}

variable "abfs_license" {
  description = "ABFS license (JSON)"
  type        = string
}

variable "abfs_manifest_project_name" {
  description = "Name of the git project on the manifest-server containing manifests"
  type        = string
  default     = "platform/manifest"
}

variable "abfs_manifest_file" {
  description = "Relative path from the manifest project root to the manifest file"
  type        = string
  default     = "default.xml"
}

variable "abfs_puser_cos_image_ref" {
  description = "Reference to the COS boot image to use for the ABFS uploader"
  type        = string
  default     = "projects/cos-cloud/global/images/family/cos-109-lts"
}

variable "abfs_docker_image_uri" {
  description = "Docker image URI for the ABFS uploader"
  type        = string
}

variable "abfs_datadisk_mountpoint" {
  description = "Location for mounting the ABFS datadisk on the host VM"
  type        = string
  default     = "/mnt/disks/abfs-data"
}

variable "abfs_server_name" {
  description = "The name of the ABFS server"
  type        = string
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  description = "The name of the deployment for Marketplace"
  type        = string
  default     = ""
}
