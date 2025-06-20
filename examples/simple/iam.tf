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

data "google_service_account" "abfs" {
  project    = data.google_project.project.project_id
  account_id = var.abfs_service_account_id
}

module "project-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "8.1.0"

  projects = [data.google_project.project.project_id]
  mode     = "authoritative"
  bindings = {
    "roles/artifactregistry.reader"             = [data.google_service_account.abfs.member],
    "roles/logging.logWriter"                   = [data.google_service_account.abfs.member],
    "roles/monitoring.metricWriter"             = [data.google_service_account.abfs.member],
    "roles/monitoring.viewer"                   = [data.google_service_account.abfs.member],
    "roles/stackdriver.resourceMetadata.writer" = [data.google_service_account.abfs.member],
  }

  depends_on = [
    module.project-services
  ]
}
