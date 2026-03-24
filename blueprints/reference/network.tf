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
  from = module.abfs-vpc
  to   = module.abfs_vpc[0]
}

module "abfs_vpc" {
  count   = var.use_shared_vpc ? 0 : 1

  source  = "terraform-google-modules/network/google"
  version = "~>16.1.0"

  project_id   = data.google_project.project.project_id
  network_name = var.abfs_network_name
  routing_mode = "GLOBAL"

  firewall_rules = [
    {
      name        = "allow-ssh-tunnel-iap"
      description = "Allow ssh tunnel-through-iap to ABFS server VMs"
      direction   = "INGRESS"
      priority    = 1000

      # This range contains all IP addresses that IAP uses for TCP forwarding.
      # See https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
      ranges = ["35.235.240.0/20"]

      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    },
    {
      name        = "abfs-server-allow-ingress"
      description = "Allow ingress from the ABFS uploaders and clients to the ABFS server"
      direction   = "INGRESS"
      priority    = 1000

      source_service_accounts = compact([local.uploader_service_account.email, local.ui_service_account.email, var.create_client_instance_resource ? local.client_service_account.email : null])
      target_service_accounts = [local.server_service_account.email]

      allow = [
        {
          protocol = "tcp"
          ports    = ["50051"]
        },
      ]
    },
    {
      name        = "abfs-uploader-allow-ui-ingress"
      description = "Allow ingress from the ABFS UI to the ABFS uploaders"
      direction   = "INGRESS"
      priority    = 1000

      source_service_accounts = [local.ui_service_account.email]
      target_service_accounts = [local.uploader_service_account.email]

      allow = [
        {
          protocol = "tcp"
          ports    = ["8086"]
        },
      ]
    },
  ]

  subnets = [
    {
      subnet_name           = var.abfs_subnet_name
      subnet_ip             = var.abfs_subnet_ip
      subnet_private_access = var.abfs_subnet_private_access
      subnet_region         = var.region
    },
    {
      subnet_name           = var.cws_subnet_name
      subnet_ip             = var.cws_subnet_ip
      subnet_private_access = var.cws_subnet_private_access
      subnet_region         = var.cws_region
    }
  ]

  depends_on = [
    module.project-services
  ]
}

data "google_compute_subnetwork" "abfs_subnet" {
  count   = var.use_shared_vpc ? 1 : 0

  name    = var.abfs_subnet_name
  project = var.vpc_project_id
  region  = var.region
}

data "google_compute_subnetwork" "cws_subnet" {
  count   = var.use_shared_vpc && var.create_cloud_workstation_resources ? 1 : 0

  name    = var.cws_subnet_name
  project = var.vpc_project_id
  region  = var.cws_region
}

resource "google_compute_router" "nat_router" {
  count   = var.use_shared_vpc ? 0 : 1

  project = var.project_id
  name    = "natgw-router"
  network = module.abfs_vpc[0].network_self_link
  region  = var.region
}

module "cloud-nat" {
  count   = var.use_shared_vpc ? 0 : 1

  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 5.4.0"

  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.nat_router[0].name
}
