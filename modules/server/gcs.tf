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

moved {
  from = google_storage_bucket.abfs
  to   = google_storage_bucket.abfs[0]
}

moved {
  from = random_bytes.abfs_bucket_prefix
  to   = random_bytes.abfs_bucket_prefix[0]
}

data "google_storage_bucket" "abfs" {
  project = var.project_id
  name    = var.existing_bucket_name == "" ? google_storage_bucket.abfs[0].name : var.existing_bucket_name
}

resource "random_bytes" "abfs_bucket_prefix" {
  count  = var.existing_bucket_name == "" ? 1 : 0
  length = 2
}

resource "google_storage_bucket" "abfs" {
  count                       = var.existing_bucket_name == "" ? 1 : 0
  project                     = var.project_id
  name                        = "${var.abfs_bucket_name}-${random_bytes.abfs_bucket_prefix[0].hex}"
  location                    = var.abfs_bucket_location
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
}
