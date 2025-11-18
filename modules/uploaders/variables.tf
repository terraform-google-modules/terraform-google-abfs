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

variable "abfs_gerrit_uploader_allow_stopping_for_update" {
  type        = bool
  description = "Allow to stop uploaders to update properties"
  default     = true
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

variable "abfs_gerrit_uploader_name_prefix" {
  type        = string
  description = "Name prefix for the ABFS gerrit uploader VM(s)"
  default     = "abfs-gerrit-uploader"
}

variable "abfs_gerrit_uploader_datadisk_name_prefix" {
  type        = string
  description = "A name prefix for the ABFS gerrit uploader datadisk(s) that will be attached to VM(s). Note, this does not affect the mounting of the disk - the device name is always set to \"abfs-server-storage\""
  default     = "abfs-gerrit-uploader-datadisk"
}

variable "abfs_gerrit_uploader_datadisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS gerrit uploader datadisk(s) that will be attached to the VM(s)"
  default     = 4096
}

variable "abfs_gerrit_uploader_datadisk_type" {
  type        = string
  description = "The PD regional disk type to use for the ABFS gerrit uploader datadisk(s)"
  default     = "pd-ssd"
}

variable "abfs_gerrit_uploader_manifest_server" {
  type        = string
  description = "The manifest server to assume"
  default     = "android.googlesource.com"
}

variable "abfs_gerrit_uploader_git_branch" {
  type        = set(string)
  description = "Branches from where to find projects (e.g. [\"main\",\"v-keystone-qcom-release\"]) (default [\"main\"])"
  default     = ["main"]
}

variable "abfs_extra_params" {
  type        = list(string)
  description = "A list of extra parameters to append to the abfs command"
  default     = []
}

variable "abfs_gerrit_uploader_extra_params" {
  type        = list(string)
  description = "A list of extra parameters to append to the gerrit upload-daemon sub-command"
  default     = []
}

variable "abfs_enable_git_lfs" {
  type        = bool
  description = "Enable Git LFS support"
  default     = false
}

variable "abfs_license" {
  type        = string
  description = "ABFS license (JSON)"
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

variable "abfs_uploader_cos_image_ref" {
  type        = string
  description = "Reference to the COS boot image to use for the ABFS uploader"
  default     = "projects/cos-cloud/global/images/family/cos-125-lts"
}

variable "abfs_docker_image_uri" {
  type        = string
  description = "Docker image URI for the ABFS uploader"
}

variable "abfs_datadisk_mountpoint" {
  type        = string
  description = "Location for mounting the ABFS datadisk on the host VM"
  default     = "/mnt/disks/abfs-data"
}

variable "abfs_server_name" {
  type        = string
  description = "The name of the ABFS server"
}

variable "pre_start_hooks" {
  type        = string
  description = "The absolute path to the local directory containing pre-start hook scripts. These scripts will be copied to the host VM and mounted to the docker container at /etc/abfs/pre-start.d."
  default     = null
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  type        = string
  description = "The name of the deployment for Marketplace"
  default     = ""
}
