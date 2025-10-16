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
  # 1. Clean the raw DDL content by removing comment lines and empty lines.
  file_lines        = split("\n", data.local_file.abfs_spanner_database_schema.content)
  lines_no_comments = [for line in local.file_lines : line if ! startswith(trimspace(line), "--")]
  ddl_lines         = [for line in local.lines_no_comments : line if length(trimspace(line)) > 0]
  cleaned_ddl       = join("\n", local.ddl_lines)

  # 2. Split the content into individual statements using the semicolon as a delimiter.
  statements = split(";", local.cleaned_ddl)

  # 3. Trim whitespace from each statement and filter out any empty statements.
  spanner_ddl_statements = var.abfs_spanner_database_create_tables ? [
    for s in local.statements : trimspace(s)
    if length(trimspace(s)) > 0
  ] : []
}

resource "google_spanner_instance" "abfs" {
  project                      = var.project_id
  name                         = var.abfs_spanner_instance_name
  display_name                 = var.abfs_spanner_instance_display_name
  edition                      = "ENTERPRISE"
  default_backup_schedule_type = "AUTOMATIC"
  config                       = var.abfs_spanner_instance_config

  autoscaling_config {
    autoscaling_limits {
      min_nodes = 1
      max_nodes = 10
    }
    autoscaling_targets {
      high_priority_cpu_utilization_percent = 65
      storage_utilization_percent           = 95
    }
  }
}

data "local_file" "abfs_spanner_database_schema" {
  filename = "${path.module}/../../files/schemas/${var.abfs_spanner_database_schema_version}-schema.sql"
}

resource "google_spanner_database" "abfs" {
  project             = var.project_id
  instance            = google_spanner_instance.abfs.name
  name                = var.abfs_spanner_database_name
  ddl                 = local.spanner_ddl_statements
  deletion_protection = true
  lifecycle {
    # Ignore changes after database creation to avoid accidental data loss.
    ignore_changes = [ddl]
  }
}
