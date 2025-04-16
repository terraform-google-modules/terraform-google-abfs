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

variable "abfs_server_machine_type" {
  description = "Machine type for ABFS servers"
  type        = string
  default     = "n2-highmem-128"
}

# TODO - consider a single prefix that could be used for all VMs and datadisks across the deployment
# E.g. "dev". Then all resources would get non-configurable postfixes yielding names like:
#   * dev-abfs-server
#   * dev-abfs-server-datadisk
#   * dev-abfs-server-gerrit-uploader-0
#   * dev-abfs-server-getrit-uploader-datadisk-0
variable "abfs_server_name" {
  description = "Name for the ABFS server"
  type        = string
  default     = "abfs-server"
}

variable "abfs_server_cos_image_ref" {
  description = "Reference to the COS boot image to use for the ABFS server"
  type        = string
  default     = "projects/cos-cloud/global/images/family/cos-109-lts"
}

variable "abfs_license" {
  description = "ABFS license (JSON)"
  type        = string
}

variable "abfs_docker_image_uri" {
  description = "Docker image URI for main ABFS server"
  type        = string
}

variable "abfs_server_command" {
  description = "The ABFS command to run on ABFS servers. The command should not include 'abfs', only what follows"
  type        = string
  default     = "server -d /abfs-storage"
}

variable "abfs_datadisk_mountpoint" {
  description = "Location for mounting the ABFS datadisk on the host VM"
  type        = string
  default     = "/mnt/disks/abfs-data"
}

variable "abfs_datadisk_name" {
  description = "A name for the ABFS datadisk that will be attached to the VM. Note, this does not affect the mounting of the disk - the device name is always set to \"abfs-server-storage\""
  type        = string
  default     = "abfs-datadisk"
}

variable "abfs_datadisk_size_gb" {
  description = "Size in GB for the ABFS datadisk that will be attached to the VM"
  type        = number
  default     = 10000
}

variable "abfs_datadisk_type" {
  description = "The PD regional disk type to use for the ABFS datadisk"
  type        = string
  default     = "pd-ssd"
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  description = "The name of the deployment for Marketplace"
  type        = string
  default     = ""
}
