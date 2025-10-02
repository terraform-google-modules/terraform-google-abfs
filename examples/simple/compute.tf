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

resource "google_compute_instance" "abfs_client" {
  count = var.create_client_instance_resource ? 1 : 0

  project             = var.project_id
  name                = var.abfs_client_config.name
  zone                = var.zone
  can_ip_forward      = var.abfs_client_config.can_ip_forward
  deletion_protection = var.abfs_client_config.deletion_protection
  enable_display      = var.abfs_client_config.enable_display
  machine_type        = var.abfs_client_config.machine_type
  boot_disk {
    auto_delete = true
    device_name = var.abfs_client_config.name
    initialize_params {
      image = format(
        "projects/%s/global/images/%s",
        var.abfs_client_config.image_project,
        var.abfs_client_config.image_name
      )
      size = var.abfs_client_config.size
      type = var.abfs_client_config.type
    }
    mode = "READ_WRITE"
  }
  metadata = var.abfs_client_config.enable_oslogin ? {
    enable-osconfig = "TRUE"
    enable-oslogin  = "true"
  } : {}
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = module.abfs_vpc.subnets["${var.region}/${var.abfs_subnet_name}"].self_link
  }
  scheduling {
    automatic_restart   = var.abfs_client_config.automatic_restart
    on_host_maintenance = var.abfs_client_config.preemptible ? "TERMINATE" : "MIGRATE"
    preemptible         = var.abfs_client_config.preemptible
    provisioning_model  = var.abfs_client_config.preemptible ? "SPOT" : "STANDARD"
  }
  service_account {
    email  = local.abfs_service_account_email
    scopes = var.abfs_client_config.scopes
  }
  shielded_instance_config {
    enable_integrity_monitoring = var.abfs_client_config.shielded_instance_config.enable_integrity_monitoring
    enable_secure_boot          = var.abfs_client_config.shielded_instance_config.enable_secure_boot
    enable_vtpm                 = var.abfs_client_config.shielded_instance_config.enable_vtpm
  }
}
