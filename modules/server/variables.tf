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
  description = "Docker image URI for main ABFS server"
}

variable "abfs_server_command" {
  type        = string
  description = "The ABFS command to run on ABFS servers. The command should not include 'abfs', only what follows"
  default     = "server -d /abfs-storage"
}

variable "abfs_datadisk_mountpoint" {
  type        = string
  description = "Location for mounting the ABFS datadisk on the host VM"
  default     = "/mnt/disks/abfs-data"
}

variable "abfs_datadisk_name" {
  type        = string
  description = "A name for the ABFS datadisk that will be attached to the VM. Note, this does not affect the mounting of the disk - the device name is always set to \"abfs-server-storage\""
  default     = "abfs-datadisk"
}

variable "abfs_datadisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS datadisk that will be attached to the VM"
  default     = 10000
}

variable "abfs_datadisk_type" {
  type        = string
  description = "The PD regional disk type to use for the ABFS datadisk"
  default     = "pd-ssd"
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  type        = string
  description = "The name of the deployment for Marketplace"
  default     = ""
}
