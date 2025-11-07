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

resource "google_monitoring_alert_policy" "oom_killings" {
  provider = google-beta

  project      = var.project_id
  display_name = "Container OOM Killings"
  enabled      = "true"
  combiner     = "OR"
  conditions {
    display_name = "Container OOM Killings"
    condition_prometheus_query_language {
      query               = "sum(increase(compute_googleapis_com:guest_system_problem_count{reason=\"OOMKilling\"}[30m])) by (project_id) >= 3"
      duration            = "60s"
      evaluation_interval = "60s"
    }
  }
  notification_channels = [google_monitoring_notification_channel.email.name]
  #user_labels = {
  #  alert_policy_id = "gke_ooms"
  #  severity        = "ticket"
  #}
  documentation {
    subject = "Container OOM Killings"
    content = <<EOT
    Container OOM Killings \
      FIXME
    EOT
    links {
      display_name = "alert playbook"
      url          = "https://FIXME.com/fixme"
    }
    mime_type = "text/markdown"
  }
}