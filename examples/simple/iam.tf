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
  create_server_service_account = var.server_service_account_id == ""
  server_service_account        = local.create_server_service_account ? google_service_account.server[0] : data.google_service_account.server[0]

  create_uploader_service_account = var.uploader_service_account_id == ""
  uploader_service_account        = local.create_uploader_service_account ? google_service_account.uploader[0] : data.google_service_account.uploader[0]

  create_client_service_account = var.client_service_account_id == ""
  client_service_account        = var.create_client_instance_resource ? (local.create_client_service_account ? google_service_account.client[0] : data.google_service_account.client[0]) : null
}

# Service Account - Server

moved {
  from = google_service_account.abfs[0]
  to   = google_service_account.server[0]
}

data "google_service_account" "server" {
  count = local.create_server_service_account ? 0 : 1

  project    = data.google_project.project.project_id
  account_id = var.server_service_account_id
}

resource "google_service_account" "server" {
  count = local.create_server_service_account ? 1 : 0

  project      = data.google_project.project.project_id
  account_id   = var.server_service_account_name
  display_name = "Service Account for ABFS Server"

  lifecycle {
    # Prevent the service account that may have been granted an ABFS license from being deleted.
    prevent_destroy = true
  }
}

# Service Account - Uploader

data "google_service_account" "uploader" {
  count = local.create_uploader_service_account ? 0 : 1

  project    = data.google_project.project.project_id
  account_id = var.uploader_service_account_id
}

resource "google_service_account" "uploader" {
  count = local.create_uploader_service_account ? 1 : 0

  project      = data.google_project.project.project_id
  account_id   = var.uploader_service_account_name
  display_name = "Service Account for ABFS Uploader"

  lifecycle {
    # Prevent the service account that may have been granted an ABFS license from being deleted.
    prevent_destroy = true
  }
}

# Service Account - Client

data "google_service_account" "client" {
  count = var.create_client_instance_resource && ! local.create_client_service_account ? 1 : 0

  project    = data.google_project.project.project_id
  account_id = var.client_service_account_id
}

resource "google_service_account" "client" {
  count = var.create_client_instance_resource && local.create_client_service_account ? 1 : 0

  project      = data.google_project.project.project_id
  account_id   = var.client_service_account_name
  display_name = "Service Account for ABFS Client"

  lifecycle {
    # Prevent the service account that may have been granted an ABFS license from being deleted.
    prevent_destroy = true
  }
}

module "project-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "8.2.0"

  projects = [data.google_project.project.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/logging.logWriter"                   = [local.server_service_account.member, local.uploader_service_account.member],
    "roles/monitoring.metricWriter"             = [local.server_service_account.member, local.uploader_service_account.member],
    "roles/monitoring.viewer"                   = [local.server_service_account.member, local.uploader_service_account.member],
    "roles/spanner.databaseUser"                = [local.server_service_account.member],
    "roles/stackdriver.resourceMetadata.writer" = [local.server_service_account.member, local.uploader_service_account.member],
    "roles/storage.objectAdmin"                 = [local.server_service_account.member],
  }

  depends_on = [
    module.project-services,
    local.server_service_account,
    local.uploader_service_account,
    local.client_service_account,
  ]
}
