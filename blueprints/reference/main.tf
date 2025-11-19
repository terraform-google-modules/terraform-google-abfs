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

data "google_project" "project" {
  project_id = var.project_id

  depends_on = [
    module.project-services
  ]
}
