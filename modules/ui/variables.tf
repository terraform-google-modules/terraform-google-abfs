# Copyright 2026 Google LLC
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
  description = "Zone for ABFS UI"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for the servers"
}

variable "service_account_email" {
  type        = string
  description = "Email of service account to attach to the servers"
}

variable "abfs_ui_allow_stopping_for_update" {
  type        = bool
  description = "Allow to stop UI to update properties"
  default     = true
}

variable "abfs_ui_uploader_count" {
  type        = number
  description = "The number of gerrit uploader instances to proxy"
  default     = 3
}

variable "abfs_ui_machine_type" {
  type        = string
  description = "Machine type for ABFS UI"
  default     = "n2d-standard-8"
}

variable "abfs_ui_uploader_name_prefix" {
  type        = string
  description = "Name prefix for the ABFS gerrit uploader VM(s)"
  default     = "abfs-gerrit-uploader"
}

variable "abfs_bootdisk_size_gb" {
  type        = number
  description = "Size in GB for the ABFS bootdisk that will be attached to the VM"
  default     = 200
}

variable "abfs_bootdisk_type" {
  type        = string
  description = "The PD regional disk type to use for the ABFS bootdisk"
  default     = "pd-ssd"
}

variable "abfs_extra_params" {
  type        = list(string)
  description = "A list of extra parameters to append to the abfs command"
  default     = []
}

variable "abfs_ui_extra_params" {
  type        = list(string)
  description = "A list of extra parameters to append to the ui-server sub-command"
  default     = []
}

variable "abfs_ui_name" {
  type        = string
  description = "Name for the ABFS UI"
  default     = "abfs-ui"
}

variable "abfs_ui_port" {
  type        = number
  description = "The port to listen on"
  default     = 8080
}

variable "abfs_ui_remote_server" {
  type        = string
  description = "The name of the ABFS server for the cacheman process"
  default     = "abfs-server"
}

variable "abfs_ui_cos_image_ref" {
  type        = string
  description = "Reference to the COS boot image to use for the ABFS UI"
  default     = "projects/cos-cloud/global/images/family/cos-125-lts"
}

variable "abfs_docker_image_uri" {
  type        = string
  description = "Docker image URI for the ABFS UI"
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  type        = string
  description = "The name of the deployment for Marketplace"
  default     = ""
}
