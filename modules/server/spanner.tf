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

resource "google_spanner_database" "abfs" {
  instance            = google_spanner_instance.abfs.name
  name                = var.abfs_spanner_database_name
  deletion_protection = true
}
