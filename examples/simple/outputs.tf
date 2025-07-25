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

output "license_information" {
  value = {
    project_id                = data.google_project.project.project_id,
    project_number            = data.google_project.project.number,
    service_account_email     = local.abfs_service_account_email
    service_account_unique_id = local.abfs_service_account_unique_id
  }
}

output "spanner_database_schema_creation" {
  description = "The CLI command for creating the Spanner database schema"
  value = var.abfs_spanner_database_create_tables ? (
    "# The abfs_spanner_database_create_tables variable was set to true; no further action required."
    ) : (
    join(" ", [
      "gcloud --project ${data.google_project.project.project_id}",
      "spanner databases ddl update",
      "--instance ${module.abfs_server.abfs_spanner_instance.name}",
      "${module.abfs_server.abfs_spanner_database.name}",
      "--ddl-file ${module.abfs_server.abfs_spanner_database_schema_file}",
    ])
  )
}
