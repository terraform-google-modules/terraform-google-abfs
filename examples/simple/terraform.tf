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

terraform {
  required_version = ">= 1.9.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.11.0"
    }
  }
  # grant Storage Object Admin role to the Google Identity invoking Terraform
  # backend "gcs" {
  #   bucket = "YOUR_BUCKET"
  #   # folder in the bucket (will be created) to store the .tfstate
  #   prefix = "terraform/abfs"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
