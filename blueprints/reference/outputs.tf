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
  description = "Information required for ABFS license generation."
  value       = local.has_abfs_license ? null : <<-EOT
  Please provide the below license information to your ABFS contact and update
  the 'abfs_license' variable. Also ensure this project Service Accounts are
  allowlisted to the artifact registry of abfs-binaries before proceeding with
  phase 2 of 'tf apply'.

  project_id                = ${data.google_project.project.project_id}
  project_number            = ${data.google_project.project.number}
  service_account_email     = ${local.server_service_account.email}
  service_account_unique_id = ${local.server_service_account.unique_id}
  EOT
}

output "spanner_database_schema_creation" {
  description = "The CLI command for creating or updating the Spanner database schema."
  value       = (!local.has_abfs_license || var.abfs_spanner_database_create_tables) ? null : <<-EOT
      # To manually apply or update the Spanner database schema, execute:
      gcloud --project ${data.google_project.project.project_id} \
        spanner databases ddl update \
        --instance ${module.abfs_server[0].abfs_spanner_instance.name} \
        ${module.abfs_server[0].abfs_spanner_database.name} \
        --ddl-file ${module.abfs_server[0].abfs_spanner_database_schema_file}
    EOT
}
