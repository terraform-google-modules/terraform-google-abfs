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

variable "region" {
  description = "Region for ABFS servers"
  type        = string
}

variable "zone" {
  description = "Zone for ABFS servers"
  type        = string
}

variable "abfs_docker_image_uri" {
  description = "Docker image URI for main ABFS server"
  type        = string
}

variable "abfs_gerrit_uploader_git_servers" {
  description = "List of git servers to upload to the ABFS server (e.g. [\"android.googlesource.com\"])"
  type        = list(string)
}

variable "abfs_license" {
  description = "ABFS license (JSON)"
  type        = string
}

variable "alert_notification_email" {
  description = "Email address to send alert notifications to"
  type        = string
}
