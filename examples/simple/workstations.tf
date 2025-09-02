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

module "workstations" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  source = "../../../../cloud_cicd_foundation/infra/modules/cicd_workstations"

  project_id   = data.google_project.project.project_id
  cws_scopes   = var.cws_scopes
  cws_clusters = var.cws_clusters
  cws_configs  = var.cws_configs
}

module "cicd_pipelines" {
  count = var.create_cloud_workstation_resources && length(var.cws_custom_images) > 0 ? 1 : 0

  source = "../../../../cloud_cicd_foundation/infra/modules/cicd_pipelines"

  project_id = data.google_project.project.project_id
  apps = {
    for k, v in var.cws_custom_images : k => {
      runtime = "workstations"
      workstation_config = {
        scheduler_region = v.scheduler_region
        ci_schedule      = v.ci_schedule
      }
    }
  }
  artifact_registry_readers = [
    "serviceAccount:${module.workstations[0].cws_service_account_email}"
  ]
}
