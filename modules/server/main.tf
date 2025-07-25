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

locals {
  common_files_root       = "${path.module}/../../files"
  goog_cm_deployment_name = var.goog_cm_deployment_name == "" ? "" : "${var.goog_cm_deployment_name}-"
  abfs_server_name        = "${local.goog_cm_deployment_name}${var.abfs_server_name}"

  static_script_files = flatten([
    for folder in ["${local.common_files_root}/scripts", "${path.module}/files/scripts"] : [
      for filename in fileset(folder, "*.sh") :
      {
        path        = "/var/lib/abfs/bin/${filename}"
        permissions = "0755"
        owner       = "root"
        encoding    = "gzip+base64"
        content     = base64gzip(file("${folder}/${filename}"))
      }
    ]
  ])

  systemd_files = flatten([
    for folder in ["${local.common_files_root}/systemd", "${path.module}/files/systemd"] : [
      for filename in fileset(folder, "*") :
      {
        path        = "/etc/systemd/system/${filename}"
        permissions = "0644"
        owner       = "root"
        encoding    = "gzip+base64"
        content     = base64gzip(file("${folder}/${filename}"))
      }
    ]
  ])

  runcmd = [
    "systemctl daemon-reload",
    "systemctl restart abfs-docker-warmup.service",
    "systemctl is-active -q abfs-server.service || systemctl start --no-block abfs-server.service",
    "systemctl is-active -q fluent-bit.service || systemctl start --no-block fluent-bit.service",
    "systemctl is-active -q node-problem-detector.service || systemctl start --no-block node-problem-detector.service"
  ]

  bootcmd = [
    "echo 'cloud-init bootcmd'"
  ]
}

resource "google_compute_disk" "abfs_server_bootdisk" {
  name  = "${local.abfs_server_name}-bootdisk"
  zone  = var.zone
  image = var.abfs_server_cos_image_ref
  size  = var.abfs_bootdisk_size_gb
  type  = var.abfs_bootdisk_type
}

resource "google_compute_instance" "abfs_server" {
  project      = var.project_id
  name         = local.abfs_server_name
  machine_type = var.abfs_server_machine_type
  zone         = var.zone

  allow_stopping_for_update = var.abfs_server_allow_stopping_for_update

  service_account {
    # Google recommends custom service accounts with a cloud-platform scope and permissions granted via IAM roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    source = google_compute_disk.abfs_server_bootdisk.name
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_integrity_monitoring = true
  }

  metadata = {
    abfs-license = base64encode(var.abfs_license)
    user-data    = data.cloudinit_config.abfs_server.rendered
  }
}

data "cloudinit_config" "abfs_server" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = concat(
        [
          # abfs_container.env is provided to the container run command using '--env-file'
          # it can be used to customize environment variables per deployment
          {
            path        = "/var/run/abfs/abfs_container.env"
            permissions = "0644"
            owner       = "root"
            encoding    = "gzip+base64"
            content = base64gzip(templatefile("${local.common_files_root}/templates/abfs_container.env.tftpl",
              {
                envs = {
                  "NEEDS_GIT" = false
                }
            }))
          }
        ],
        [
          # abfs_base.sh declares variables used by COS VM startup scripts
          # it can be used to set specific values per server
          #   e.g. the container image URI and the ABFS command (server, upload-daemon, etc)
          {
            path        = "/var/lib/abfs/bin/abfs_base.sh"
            permissions = "0755"
            owner       = "root"
            encoding    = "gzip+base64"
            content = base64gzip(templatefile("${local.common_files_root}/templates/abfs_base.sh.tftpl",
              {
                envs = {
                  "ABFS_CMD"              = <<-EOT
                    --project ${google_spanner_instance.abfs.project} \
                    --bucket ${data.google_storage_bucket.abfs.name} \
                    --instance ${google_spanner_instance.abfs.name} \
                    --db ${google_spanner_database.abfs.name}
                  EOT
                  "ABFS_DOCKER_IMAGE_URI" = var.abfs_docker_image_uri,
                }
            }))
          }
        ],
        [
          {
            path        = "/etc/systemd/system/abfs-server.service"
            permissions = "0644"
            owner       = "root"
            encoding    = "gzip+base64"
            content = base64gzip(templatefile("${local.common_files_root}/templates/abfs-server.service.tftpl",
              {
                type = "server"
            }))
          }
        ],
        # static script files used during startup
        local.static_script_files,
        # config for systemd services, targets, paths, etc
        local.systemd_files
      )
      runcmd  = local.runcmd,
      bootcmd = local.bootcmd
    })
  }
}
