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

# go/keep-sorted start

moved {
  from = google_service_account.abfs[0]
  to   = google_service_account.server[0]
}
moved {
  from = module.abfs-deployment
  to   = module.abfs_server
}
moved {
  from = module.abfs-uploaders
  to   = module.abfs_uploaders
}
moved {
  from = module.abfs-vpc
  to   = module.abfs_vpc
}
moved {
  from = module.abfs_vpc
  to   = module.abfs_vpc[0]
}
moved {
  from = module.cloud-dns-private-artifact-registry
  to   = module.cloud-dns-private-artifact-registry[0]
}
moved {
  from = module.cloud-dns-private-artifact-registry[0]
  to   = module.cloud_dns_private_artifact_registry[0]
}
moved {
  from = module.cloud-dns-private-google-apis
  to   = module.cloud-dns-private-google-apis[0]
}
moved {
  from = module.cloud-dns-private-google-apis[0]
  to   = module.cloud_dns_private_google_apis[0]
}
moved {
  from = module.project-iam-bindings
  to   = module.project_iam_bindings
}
moved {
  from = module.project-services
  to   = module.project_services
}
moved {
  from = module.project-services-cloud-resource-manager
  to   = module.project_services_cloud_resource_manager
}
moved {
  from = module.source-repositories-private-artifact-registry
  to   = module.source-repositories-private-artifact-registry[0]
}
moved {
  from = module.source-repositories-private-artifact-registry[0]
  to   = module.source_repositories_private_artifact_registry[0]
}
# go/keep-sorted end
