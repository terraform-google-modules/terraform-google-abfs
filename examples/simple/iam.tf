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

locals {
  create_service_account         = var.abfs_service_account_id == ""
  abfs_service_account_email     = local.create_service_account ? google_service_account.abfs[0].email : data.google_service_account.abfs[0].email
  abfs_service_account_unique_id = local.create_service_account ? google_service_account.abfs[0].unique_id : data.google_service_account.abfs[0].unique_id
}

data "google_service_account" "abfs" {
  count = local.create_service_account ? 0 : 1

  project    = data.google_project.project.project_id
  account_id = var.abfs_service_account_id
}

resource "google_service_account" "abfs" {
  count = local.create_service_account ? 1 : 0

  project      = data.google_project.project.project_id
  account_id   = var.abfs_service_account_name
  display_name = "Service Account for ABFS"

  lifecycle {
    # Prevent the service account that may have been granted an ABFS license from being deleted.
    prevent_destroy = true
  }
}

module "project-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "8.1.0"

  projects = [data.google_project.project.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/artifactregistry.reader"             = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/logging.logWriter"                   = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/monitoring.metricWriter"             = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/monitoring.viewer"                   = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/spanner.databaseUser"                = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/stackdriver.resourceMetadata.writer" = ["serviceAccount:${local.abfs_service_account_email}"],
    "roles/storage.objectAdmin"                 = ["serviceAccount:${local.abfs_service_account_email}"],
  }

  depends_on = [
    module.project-services,
    data.google_service_account.abfs,
    google_service_account.abfs
  ]
}
