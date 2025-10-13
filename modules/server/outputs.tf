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

output "abfs_bucket_name" {
  description = "The ABFS GCS bucket name"
  value       = data.google_storage_bucket.abfs.name
}

output "abfs_server_name" {
  description = "The name of the ABFS server instance"
  value       = google_compute_instance.abfs_server.name
}

output "abfs_spanner_instance" {
  description = "The ABFS Spanner instance object"
  value       = google_spanner_instance.abfs
}

output "abfs_spanner_database" {
  description = "The ABFS Spanner database object"
  value       = google_spanner_database.abfs
}

output "abfs_spanner_database_schema_version" {
  description = "The schema version used for the ABFS Spanner database"
  value       = var.abfs_spanner_database_schema_version
}

output "abfs_spanner_database_schema_file" {
  description = "The ABFS Spanner database schema file"
  value       = data.local_file.abfs_spanner_database_schema.filename
}
