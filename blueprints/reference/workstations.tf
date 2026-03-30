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

resource "null_resource" "cws_network_dependency" {
  count = var.use_shared_vpc ? 0 : 1

  triggers = {
    network_id = module.abfs_vpc[0].network_id
  }
}

module "cicd_foundation" {
  count = var.create_cloud_workstation_resources ? 1 : 0

  source = "github.com/GoogleCloudPlatform/cicd-foundation//infra/modules/cicd_foundation?ref=v5.0.0"

  project_id  = data.google_project.project.project_id
  enable_apis = var.enable_apis
  # go/keep-sorted start
  artifact_registry_region                    = var.artifact_registry_region
  binary_authorization_always_create          = var.binary_authorization_always_create
  boot_disk_size_gb_default                   = var.boot_disk_size_gb_default
  build_machine_type_default                  = var.build_machine_type_default
  build_timeout_default_seconds               = var.build_timeout_default_seconds
  cloud_build_peered_network                  = var.cloud_build_peered_network
  cloud_build_region                          = var.cloud_build_region
  cws_clusters                                = var.cws_clusters
  cws_configs                                 = var.cws_configs
  cws_custom_images                           = var.cws_custom_images
  disable_public_ip_addresses_default         = var.disable_public_ip_addresses_default
  enable_nested_virtualization_default        = var.enable_nested_virtualization_default
  git_branch_trigger                          = var.git_branch_trigger
  idle_timeout_seconds_default                = var.idle_timeout_seconds_default
  machine_type_default                        = var.machine_type_default
  persistent_disk_fs_type_default             = var.persistent_disk_fs_type_default
  persistent_disk_reclaim_policy_default      = var.persistent_disk_reclaim_policy_default
  persistent_disk_type_default                = var.persistent_disk_type_default
  pool_size_default                           = var.pool_size_default
  scheduler_default_region                    = var.scheduler_default_region
  secret_manager_region                       = var.secret_manager_region
  secure_source_manager_ca_common_name        = var.secure_source_manager_ca_common_name
  secure_source_manager_ca_key_algorithm      = var.secure_source_manager_ca_key_algorithm
  secure_source_manager_ca_lifetime_seconds   = var.secure_source_manager_ca_lifetime_seconds
  secure_source_manager_ca_organization       = var.secure_source_manager_ca_organization
  secure_source_manager_ca_pool               = var.secure_source_manager_ca_pool
  secure_source_manager_create_ca_pool        = var.secure_source_manager_create_ca_pool
  secure_source_manager_instance_name         = var.secure_source_manager_instance_name
  secure_source_manager_region                = var.secure_source_manager_region
  secure_source_manager_repo_git_url_to_clone = var.secure_source_manager_repo_git_url_to_clone
  secure_source_manager_repo_name             = var.secure_source_manager_repo_name
  # go/keep-sorted end

  depends_on = [
    module.project_services,
    null_resource.cws_network_dependency,
  ]
}
