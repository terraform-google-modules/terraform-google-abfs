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

moved {
  from = module.abfs-deployment
  to   = module.abfs_server
}

moved {
  from = module.abfs-uploaders
  to   = module.abfs_uploaders
}

module "abfs_server" {
  source = "github.com/terraform-google-modules/terraform-google-abfs//modules/server?ref=v0.11.0"
  count  = var.abfs_license == "" ? 0 : 1

  project_id                          = data.google_project.project.project_id
  zone                                = var.zone
  service_account_email               = local.server_service_account.email
  subnetwork                          = module.abfs_vpc.subnets["${var.region}/${var.abfs_subnet_name}"].name
  abfs_docker_image_uri               = var.abfs_docker_image_uri
  abfs_license                        = var.abfs_license
  abfs_bucket_location                = var.abfs_bucket_location
  abfs_server_machine_type            = var.abfs_server_machine_type
  abfs_spanner_instance_config        = var.abfs_spanner_instance_config
  abfs_spanner_database_create_tables = var.abfs_spanner_database_create_tables
}

module "abfs_uploaders" {
  source = "github.com/terraform-google-modules/terraform-google-abfs//modules/uploaders?ref=v0.11.0"
  count  = var.abfs_license == "" ? 0 : 1

  project_id                                = data.google_project.project.project_id
  region                                    = var.region
  zone                                      = var.zone
  service_account_email                     = local.uploader_service_account.email
  subnetwork                                = module.abfs_vpc.subnets["${var.region}/${var.abfs_subnet_name}"].name
  abfs_docker_image_uri                     = var.abfs_docker_image_uri
  abfs_gerrit_uploader_count                = var.abfs_gerrit_uploader_count
  abfs_gerrit_uploader_machine_type         = var.abfs_gerrit_uploader_machine_type
  abfs_gerrit_uploader_datadisk_size_gb     = var.abfs_gerrit_uploader_datadisk_size_gb
  abfs_gerrit_uploader_manifest_project_url = var.abfs_gerrit_uploader_manifest_project_url
  abfs_gerrit_uploader_branch_files         = var.abfs_gerrit_uploader_branch_files
  abfs_gerrit_uploader_name_prefix          = var.abfs_gerrit_uploader_name_prefix
  abfs_license                              = var.abfs_license
  abfs_server_name                          = module.abfs_server[0].abfs_server_name
  abfs_enable_git_lfs                       = var.abfs_enable_git_lfs

  # APIs need to be enabled prior to starting the Cloud Run jobs.
  depends_on = [
    module.project-services
  ]
}

module "abfs_ui" {
  source = "../../modules/ui"
  #count  = var.abfs_license == "" ? 0 : 1
  # TODO: The UI needs changes with new git-pusher
  count = 0

  project_id                   = data.google_project.project.project_id
  zone                         = var.zone
  service_account_email        = local.ui_service_account.email
  subnetwork                   = module.abfs_vpc.subnets["${var.region}/${var.abfs_subnet_name}"].name
  abfs_docker_image_uri        = var.abfs_docker_image_uri
  abfs_ui_machine_type         = var.abfs_ui_machine_type
  abfs_ui_remote_server        = module.abfs_server[0].abfs_server_name
  abfs_ui_uploader_count       = var.abfs_gerrit_uploader_count
  abfs_ui_uploader_name_prefix = var.abfs_gerrit_uploader_name_prefix
}
