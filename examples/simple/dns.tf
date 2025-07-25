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
  from = module.cloud-dns-private-google-apis
  to   = module.cloud-dns-private-google-apis[0]
}

moved {
  from = module.cloud-dns-private-artifact-registry
  to   = module.cloud-dns-private-artifact-registry[0]
}

moved {
  from = module.source-repositories-private-artifact-registry
  to   = module.source-repositories-private-artifact-registry[0]
}

locals {
  # See https://cloud.google.com/vpc/docs/configure-private-google-access#config-domain
  private_google_access_ips = [
    "199.36.153.8", "199.36.153.9", "199.36.153.10", "199.36.153.11"
  ]
}

module "cloud-dns-private-google-apis" {
  count   = var.create_dns_zones ? 1 : 0
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"

  description = "Private DNS zone for Google APIs"
  domain      = "googleapis.com."
  name        = "private-google-apis"
  project_id  = data.google_project.project.project_id
  type        = "private"

  private_visibility_config_networks = [
    module.abfs-vpc.network_id
  ]

  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "private.googleapis.com.",
      ]
    },
    {
      name    = "private"
      type    = "A"
      ttl     = 300
      records = local.private_google_access_ips
    },
  ]
}

module "cloud-dns-private-artifact-registry" {
  count   = var.create_dns_zones ? 1 : 0
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"

  description = "Private DNS zone for Artifact Registry"
  domain      = "pkg.dev."
  name        = "private-artifact-registry"
  project_id  = data.google_project.project.project_id
  type        = "private"

  private_visibility_config_networks = [
    module.abfs-vpc.network_id
  ]

  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "pkg.dev.",
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = local.private_google_access_ips
    },
  ]
}

module "source-repositories-private-artifact-registry" {
  count   = var.create_dns_zones ? 1 : 0
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"

  description = "Private DNS zone for Cloud Source Repositories"
  domain      = "source.developers.google.com."
  name        = "private-cloud-source-repositories"
  project_id  = data.google_project.project.project_id
  type        = "private"

  private_visibility_config_networks = [
    module.abfs-vpc.network_id
  ]

  recordsets = [
    {
      name = "*"
      type = "CNAME"
      ttl  = 300
      records = [
        "source.developers.google.com.",
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = local.private_google_access_ips
    },
  ]
}
