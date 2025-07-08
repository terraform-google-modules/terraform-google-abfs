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

output "license_information" {
  value = {
    project_id                = data.google_project.project.project_id,
    project_number            = data.google_project.project.number,
    service_account_email     = data.google_service_account.abfs.email
    service_account_unique_id = data.google_service_account.abfs.unique_id
  }
}

output "spanner_database_schema_creation" {
  description = "The CLI command for creating the Spanner database schema"
  value       = "SCHEMA_FILE=0.0.31-schema.sql; curl -O https://raw.githubusercontent.com/terraform-google-modules/terraform-google-abfs/refs/heads/main/files/schemas/$SCHEMA_FILE; gcloud --project ${data.google_project.project.project_id} spanner databases ddl update --instance ${module.abfs_server.abfs_spanner_instance.name} ${module.abfs_server.abfs_spanner_database.name} --ddl-file $SCHEMA_FILE; rm $SCHEMA_FILE"
}
