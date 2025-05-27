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

locals {
  cloud_init_path           = "${path.module}/../../cloud-init"
  goog_cm_deployment_name   = var.goog_cm_deployment_name == "" ? "" : "${var.goog_cm_deployment_name}-"
  abfs_datadisk_device_name = "abfs-server-storage"
  static_script_files = [for filename in fileset("${local.cloud_init_path}/scripts/", "*.sh") :
    {
      path        = "/var/lib/abfs/bin/${filename}"
      permissions = "0755"
      owner       = "root"
      encoding    = "gzip+base64"
      content     = base64gzip(file("${local.cloud_init_path}/scripts/${filename}"))
  }]
  systemd_files = [for filename in fileset(local.cloud_init_path, "abfs*") :
    {
      path        = "/etc/systemd/system/${filename}"
      permissions = "0644"
      owner       = "root"
      encoding    = "gzip+base64"
      content     = base64gzip(file("${local.cloud_init_path}/${filename}"))
  }]
  runcmd = [
    "systemctl daemon-reload",
    "systemctl enable abfs-datadisk.path",
    "systemctl restart abfs-docker-warmup.service",
    "systemctl is-active -q abfs-server.service || systemctl start --no-block abfs-server.service",
    "systemctl is-active -q fluent-bit.service || systemctl start --no-block fluent-bit.service",
    "systemctl is-active -q node-problem-detector.service || systemctl start --no-block node-problem-detector.service"
  ]
  bootcmd = [
    "echo 'cloud-init bootcmd'"
  ]
}

resource "google_compute_instance" "abfs_gerrit_uploaders" {
  count        = var.abfs_gerrit_uploader_count
  project      = var.project_id
  name         = "${local.goog_cm_deployment_name}${var.abfs_gerrit_uploader_name_prefix}-${count.index}"
  machine_type = var.abfs_gerrit_uploader_machine_type
  zone         = var.zone

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = var.abfs_uploader_cos_image_ref
    }
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
    user-data    = data.cloudinit_config.abfs_gerrit_uploader_configs[count.index].rendered
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

resource "google_compute_disk" "abfs_gerrit_uploader_datadisks" {
  project = var.project_id
  count   = var.abfs_gerrit_uploader_count
  name    = "${local.goog_cm_deployment_name}${var.abfs_gerrit_uploader_datadisk_name_prefix}-${count.index}"
  size    = var.abfs_gerrit_uploader_datadisk_size_gb
  zone    = var.zone
  type    = var.abfs_gerrit_uploader_datadisk_type

  lifecycle {
    #    prevent_destroy = true
  }
}

resource "google_compute_attached_disk" "abfs_gerrit_uploader_datadisk_attachments" {
  project     = var.project_id
  count       = var.abfs_gerrit_uploader_count
  disk        = google_compute_disk.abfs_gerrit_uploader_datadisks[count.index].id
  instance    = google_compute_instance.abfs_gerrit_uploaders[count.index].id
  device_name = local.abfs_datadisk_device_name
}

data "cloudinit_config" "abfs_gerrit_uploader_configs" {
  count         = var.abfs_gerrit_uploader_count
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
            content = base64gzip(templatefile("${local.cloud_init_path}/scripts/abfs_container.env.tftpl",
              {
                needs_git = "true" # gerrit uploaders need git access
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
            content = base64gzip(templatefile("${local.cloud_init_path}/scripts/abfs_base.sh.tftpl",
              {
                abfs_docker_image_uri    = var.abfs_docker_image_uri
                abfs_datadisk_mountpoint = var.abfs_datadisk_mountpoint
                # FIXME: Find a better way to parameterize the abfs command
                abfs_command = <<-EOT
                               --manifest-server ${var.abfs_gerrit_uploader_manifest_server} \
                               --remote-servers ${var.abfs_server_name}:50051 \
                               --manifest-project-name ${var.abfs_manifest_project_name} \
                               gerrit upload-daemon ${var.abfs_gerrit_uploader_count} ${count.index} \
                               --branch ${join(",", var.abfs_gerrit_uploader_git_branch)} \
                               --project-storage-path /abfs-storage \
                               --manifest-file ${var.abfs_manifest_file}
                               EOT
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
