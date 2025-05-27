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

resource "google_service_account" "abfs_server" {
  project      = data.google_project.project.project_id
  account_id   = "abfs-server"
  display_name = "SA for ABFS server VMs"
}

module "project-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "8.1.0"
  projects = [data.google_project.project.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/logging.logWriter"                   = ["serviceAccount:${google_service_account.abfs_server.email}"],
    "roles/monitoring.metricWriter"             = ["serviceAccount:${google_service_account.abfs_server.email}"],
    "roles/monitoring.viewer"                   = ["serviceAccount:${google_service_account.abfs_server.email}"],
    "roles/stackdriver.resourceMetadata.writer" = ["serviceAccount:${google_service_account.abfs_server.email}"],
    "roles/artifactregistry.reader"             = ["serviceAccount:${google_service_account.abfs_server.email}"]
  }

  depends_on = [
    module.project-services
  ]
}
