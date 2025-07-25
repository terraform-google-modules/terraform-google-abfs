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
  source = "github.com/terraform-google-modules/terraform-google-abfs//modules/server?ref=v0.7.1"

  project_id                          = data.google_project.project.project_id
  zone                                = var.zone
  service_account_email               = local.abfs_service_account_email
  subnetwork                          = module.abfs-vpc.subnets["${var.region}/abfs-subnet"].name
  abfs_docker_image_uri               = var.abfs_docker_image_uri
  abfs_license                        = var.abfs_license
  abfs_bucket_location                = var.abfs_bucket_location
  abfs_server_machine_type            = var.abfs_server_machine_type
  abfs_spanner_instance_config        = var.abfs_spanner_instance_config
  abfs_spanner_database_create_tables = var.abfs_spanner_database_create_tables
}

module "abfs_uploaders" {
  source = "github.com/terraform-google-modules/terraform-google-abfs//modules/uploaders?ref=v0.7.1"

  project_id                            = data.google_project.project.project_id
  zone                                  = var.zone
  service_account_email                 = local.abfs_service_account_email
  subnetwork                            = module.abfs-vpc.subnets["${var.region}/abfs-subnet"].name
  abfs_docker_image_uri                 = var.abfs_docker_image_uri
  abfs_gerrit_uploader_count            = var.abfs_gerrit_uploader_count
  abfs_gerrit_uploader_machine_type     = var.abfs_gerrit_uploader_machine_type
  abfs_gerrit_uploader_datadisk_size_gb = var.abfs_gerrit_uploader_datadisk_size_gb
  abfs_gerrit_uploader_manifest_server  = var.abfs_gerrit_uploader_manifest_server
  abfs_gerrit_uploader_git_branch       = var.abfs_gerrit_uploader_git_branch
  abfs_manifest_project_name            = var.abfs_manifest_project_name
  abfs_manifest_file                    = var.abfs_manifest_file
  abfs_license                          = var.abfs_license
  abfs_server_name                      = module.abfs_server.abfs_server_name
  abfs_enable_git_lfs                   = var.abfs_enable_git_lfs
}

module "monitoring" {
  source = "./monitoring"

  project_id         = data.google_project.project.project_id
  notification_email = var.alert_notification_email
}

data "google_project" "project" {
  project_id = var.project_id

  depends_on = [
    module.project-services
  ]
}
