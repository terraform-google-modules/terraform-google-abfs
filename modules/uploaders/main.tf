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
  common_files_root         = "${path.module}/../../files"
  goog_cm_deployment_name   = var.goog_cm_deployment_name == "" ? "" : "${var.goog_cm_deployment_name}-"
  abfs_datadisk_device_name = "abfs-server-storage"

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

  templates_files_root = "${path.module}/files/templates"

  pre_start_hooks = var.pre_start_hooks == null ? [] : [
    for filename in fileset(var.pre_start_hooks, "*") :
    {
      path        = "/var/lib/abfs/pre-start-hooks.d/${filename}"
      permissions = "0755"
      owner       = "root"
      encoding    = "gzip+base64"
      content     = base64gzip(file("${var.pre_start_hooks}/${filename}"))
    }
  ]

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

# Add the pusher config to secret manager
# This is an idiomatic way to allow bindmounting into a cloud run job.
resource "google_secret_manager_secret" "pusher_config" {
  project   = var.project_id
  secret_id = "pusher-config"
  replication {
    dynamic "auto" {
      for_each = length(var.abfs_secret_replication_locations) == 0 ? [1] : []

      content {}
    }
    dynamic "user_managed" {
      for_each = length(var.abfs_secret_replication_locations) > 0 ? [1] : []

      content {
        dynamic "replicas" {
          for_each = var.abfs_secret_replication_locations

          content {
            location = replicas.value
          }
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "pusher_config_version" {
  secret      = google_secret_manager_secret.pusher_config.id
  secret_data = templatefile("${path.module}/files/templates/pusher_config.tftpl", {
    count                = var.abfs_gerrit_uploader_count
    name_prefix          = "${local.goog_cm_deployment_name}${var.abfs_gerrit_uploader_name_prefix}"
    manifest_project_url = var.abfs_gerrit_uploader_manifest_project_url
    branch_files         = var.abfs_gerrit_uploader_branch_files
  })
}

# Give the Uploader SA access to the secret.
resource "google_secret_manager_secret_iam_binding" "run_job_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.pusher_config.id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${var.service_account_email}",
  ]
}

resource "google_cloud_run_v2_job" "create_pusher_config" {
  project             = var.project_id
  location            = var.region
  name                = "pusher-config"
  deletion_protection = false

  timeouts {
    create = "5m"
  }

  template {
    template {
      service_account = var.service_account_email
      containers {
        image = var.abfs_docker_image_uri

        volume_mounts {
          name       = "pusher-config-volume"
          mount_path = "/etc/pusher-config"
        }

        command = ["/bin/bash", "-c"]

        args = [
          <<-EOT
          set -ex

          # Need the FQDN when connecting from Cloud Run
          # It lives outside the VPC
          ARGS="--remote-servers ${var.abfs_server_name}.${var.zone}.c.${var.project_id}.internal:50051 --tunnel-ports 0"

          # Create the intended directory structure for the ABFS hashpath resolution
          # This structure contains the pusher config
          mkdir /tmp/workspace && cd /tmp/workspace
          git init
          mkdir git-pusher
          cp /etc/pusher-config/default git-pusher/default
          git add git-pusher/default
          git config --global user.email "${var.service_account_email}"
          git config --global user.name "Cloud Run Job"
          git commit -a -m "Creating the default pusher config."
          abfs $ARGS init
          abfs $ARGS cacheman run &
          abfs cacheman ping -t 1m
          abfs $ARGS push -r $PWD
          abfs cacheman wait

          # After pushing to ABFS, we update the ABFS ref with the tree object we created in the commit.
          TREE=$(git rev-parse HEAD^{tree})
          echo "$TREE" config | abfs $ARGS test-client put-ref -p abfs-meta -s default-server
          EOT
        ]
      }
      volumes {
        name = "pusher-config-volume"
        secret {
          secret = google_secret_manager_secret.pusher_config.secret_id
          items {
            version = "latest"
            path    = "default" # File will be at /etc/pusher-config/default
          }
        }
      }
      vpc_access {
        network_interfaces {
          subnetwork = var.subnetwork
        }
        egress = "ALL_TRAFFIC"
      }
    }
  }
}

resource "null_resource" "run_pusher_config" {
  depends_on = [google_cloud_run_v2_job.create_pusher_config]

  provisioner "local-exec" {
    command = <<EOT
gcloud --project ${var.project_id} run jobs execute ${google_cloud_run_v2_job.create_pusher_config.name} --region ${var.region} --wait || {
  echo "
ERROR: Failed to execute Cloud Run job to update the pusher configuration.
Please check the following:
* Ensure the Cloud Run Executor Service Account has access to the abfs-binaries artifact registry.
* Ensure the Spanner DDL schema has been applied.
  * This is done automatically during the 'tf apply' if abfs_spanner_database_create_tables=true.
  * Otherwise a manual 'gcloud spanner databases ddl update' is required.
* Ensure the license information has been added to the variables.
* Review the Cloud Run job logs.
"
  exit 1
}
EOT
  }
}

resource "google_compute_instance" "abfs_gerrit_uploaders" {
  count = var.abfs_gerrit_uploader_count

  # Wait for the cloud run pusher config write to complete
  depends_on = [null_resource.run_pusher_config]

  project      = var.project_id
  name         = "${local.goog_cm_deployment_name}${var.abfs_gerrit_uploader_name_prefix}-${count.index}"
  machine_type = var.abfs_gerrit_uploader_machine_type
  zone         = var.zone

  allow_stopping_for_update = var.abfs_gerrit_uploader_allow_stopping_for_update

  service_account {
    # Google recommends custom service accounts with a cloud-platform scope and permissions granted via IAM roles.
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
  count = var.abfs_gerrit_uploader_count

  project = var.project_id
  name    = "${local.goog_cm_deployment_name}${var.abfs_gerrit_uploader_datadisk_name_prefix}-${count.index}"
  size    = var.abfs_gerrit_uploader_datadisk_size_gb
  zone    = var.zone
  type    = var.abfs_gerrit_uploader_datadisk_type

  lifecycle {
    #    prevent_destroy = true
  }
}

resource "google_compute_attached_disk" "abfs_gerrit_uploader_datadisk_attachments" {
  count = var.abfs_gerrit_uploader_count

  project     = var.project_id
  disk        = google_compute_disk.abfs_gerrit_uploader_datadisks[count.index].id
  instance    = google_compute_instance.abfs_gerrit_uploaders[count.index].id
  device_name = local.abfs_datadisk_device_name
}

data "cloudinit_config" "abfs_gerrit_uploader_configs" {
  count = var.abfs_gerrit_uploader_count

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
            content = base64gzip(templatefile("${local.templates_files_root}/abfs_container.env.tftpl",
              {
                envs = {
                  "RUN_MODE"        = "uploader"
                  "NEEDS_GIT"       = true # gerrit uploaders need git access
                  "GIT_LFS_ENABLED" = var.abfs_enable_git_lfs
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
            content = base64gzip(templatefile("${local.templates_files_root}/abfs_base.sh.tftpl",
              {
                envs = {
                  "ABFS_CMD"                   = <<-EOT
                    --tunnel-ports 0 \
                    --remote-servers ${var.abfs_server_name}:50051 \
                    --lfs=${var.abfs_enable_git_lfs} \
                    ${join(" ", var.abfs_extra_params)} \
                    git-pusher \
                    --config config:git-pusher/default \
                    --storage-path /abfs-storage \
                    ${join(" ", var.abfs_gerrit_uploader_extra_params)}
                  EOT
                  "ABFS_DOCKER_IMAGE_URI"      = var.abfs_docker_image_uri,
                  "DATADISK_MOUNTPOINT"        = var.abfs_datadisk_mountpoint,
                  "PRE_START_HOOKS_MOUNTPOINT" = length(local.pre_start_hooks) > 0 ? "/var/lib/abfs/pre-start-hooks.d/" : "",
                  "PUBLISH_ARG"                = "8086:8086"
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
            content = base64gzip(templatefile("${local.templates_files_root}/abfs-server.service.tftpl",
              {
                type = "uploader"
            }))
          }
        ],
        # static script files used during startup
        local.static_script_files,
        # config for systemd services, targets, paths, etc
        local.systemd_files,
        local.pre_start_hooks,
      )
      runcmd  = local.runcmd,
      bootcmd = local.bootcmd
    })
  }
}
