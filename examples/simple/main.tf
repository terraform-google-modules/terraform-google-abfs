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

module "abfs-deployment" {
  source = "../../modules/server"

  project_id            = var.project_id
  zone                  = var.zone
  service_account_email = google_service_account.abfs_server.email
  subnetwork            = module.abfs-vpc.subnets["${var.region}/abfs-subnet"].name
  abfs_docker_image_uri = var.abfs_docker_image_uri
  abfs_license          = var.abfs_license
}

module "abfs-uploaders" {
  source = "../../modules/uploaders"

  project_id                           = var.project_id
  zone                                 = var.zone
  service_account_email                = google_service_account.abfs_server.email
  subnetwork                           = module.abfs-vpc.subnets["${var.region}/abfs-subnet"].name
  abfs_docker_image_uri                = var.abfs_docker_image_uri
  abfs_gerrit_uploader_manifest_server = var.abfs_gerrit_uploader_manifest_server
  abfs_license                         = var.abfs_license
  abfs_server_name                     = module.abfs-deployment.abfs_server_name
}

module "monitoring" {
  source             = "./monitoring"
  project_id         = data.google_project.project.project_id
  notification_email = var.alert_notification_email
}

data "google_project" "project" {
  project_id = var.project_id

  depends_on = [
    module.project-services
  ]
}
