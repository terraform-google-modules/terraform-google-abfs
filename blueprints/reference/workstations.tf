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

module "cicd_foundation" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  source = "github.com/GoogleCloudPlatform/cicd-foundation//infra/modules/cicd_foundation?ref=v4.0.0"

  project_id  = data.google_project.project.project_id
  enable_apis = var.enable_apis
  # go/keep-sorted start
  artifact_registry_region                    = var.artifact_registry_region
  binary_authorization_always_create          = var.binary_authorization_always_create
  cloud_build_region                          = var.cloud_build_region
  cws_clusters                                = var.cws_clusters
  cws_configs                                 = var.cws_configs
  cws_custom_images                           = var.cws_custom_images
  git_branch_trigger                          = var.git_branch_trigger
  secret_manager_region                       = var.secret_manager_region
  secure_source_manager_instance_name         = var.secure_source_manager_instance_name
  secure_source_manager_region                = var.secure_source_manager_region
  secure_source_manager_repo_git_url_to_clone = var.secure_source_manager_repo_git_url_to_clone
  secure_source_manager_repo_name             = var.secure_source_manager_repo_name
  # go/keep-sorted end

  depends_on = [
    module.abfs_vpc
  ]
}
