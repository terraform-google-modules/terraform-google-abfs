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

module "cicd_pipelines" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  source = "github.com/GoogleCloudPlatform/cicd-foundation//infra/modules/cicd_pipelines?ref=v2.1.0"

  project_id = data.google_project.project.project_id
  apps = {
    for k in keys(var.cws_custom_images) : k => {
      runtime = "workstations"
    }
  }
}

module "workstations" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  source = "../../../../cloud_cicd_foundation/infra/modules/cicd_workstations"

  project_id   = data.google_project.project.project_id
  cws_scopes   = var.cws_scopes
  cws_clusters = var.cws_clusters
  cws_configs  = var.cws_configs
  custom_images = {
    for k, v in module.cicd_pipelines[0].cloud_build_trigger_trigger_id :
    k => merge(
      {
        ci_trigger = v
      },
      try({ scheduler_region = var.cws_custom_images[k]["scheduler_region"] }, {}),
      try({ ci_schedule = var.cws_custom_images[k]["ci_schedule"] }, {})
    )
  }
  cloud_build_service_account_id = module.cicd_pipelines[0].cloud_build_service_account_id
}

resource "google_artifact_registry_repository_iam_binding" "reader" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  project    = module.cicd_pipelines[0].artifact_registry_repository.project
  location   = module.cicd_pipelines[0].artifact_registry_repository.location
  repository = module.cicd_pipelines[0].artifact_registry_repository.id
  role       = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${module.workstations[0].cws_service_account_email}"
  ]
}
