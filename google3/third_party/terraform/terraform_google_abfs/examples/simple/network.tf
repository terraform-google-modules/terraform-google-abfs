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

module "abfs-vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.2.0"

  project_id   = data.google_project.project.project_id
  network_name = "abfs-network"
  routing_mode = "GLOBAL"

  firewall_rules = [
    {
      description             = "Allow egress to Google APIs via Private Google Access"
      direction               = "EGRESS"
      name                    = "allow-egress-google-apis"
      priority                = 1000
      ranges                  = ["199.36.153.8/30", "34.126.0.0/18"]
      target_service_accounts = [google_service_account.abfs_server.email]

      allow = [
        {
          protocol = "tcp"
        }
      ]
    },
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
      name        = "allow-internal-ingress"
      description = "Allow all ingress between VMs using the ABFS service account"
      direction   = "INGRESS"
      priority    = 1000

      ranges                  = ["0.0.0.0/0"]
      source_service_accounts = [google_service_account.abfs_server.email]
      target_service_accounts = [google_service_account.abfs_server.email]
      allow = [
        {
          protocol = "icmp"
          ports    = []
        },
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
      ]
    }
  ]

  subnets = [
    {
      subnet_name           = "abfs-subnet"
      subnet_ip             = "10.2.0.0/16"
      subnet_private_access = "true"
      subnet_region         = var.region
    }
  ]

  depends_on = [
    module.project-services
  ]
}

resource "google_compute_router" "nat_router" {
  project = var.project_id
  name    = "natgw-router"
  network = module.abfs-vpc.network_self_link
  region  = var.region
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.3"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.nat_router.name
}
