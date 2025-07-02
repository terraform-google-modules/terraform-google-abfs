#!/bin/bash
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

set -e

source "$(dirname "$0")/abfs_base.sh"

# Defend against docker issues potentially causing the boot disk to fill up
if [[ "$(df /mnt/stateful_partition --output=pcent | egrep -o '[0-9]+')" -ge 90 ]]; then
  docker system prune -a -f \
    || echo "docker system prune failed, continuing with GCR warmup"
fi
AR_HOSTS=("us-docker.pkg.dev","europe-docker.pkg.dev","europe-north1-docker.pkg.dev","europe-west3-docker.pkg.dev")
docker-credential-gcr configure-docker --registries "${AR_HOSTS[*]}"
docker pull "${ABFS_DOCKER_IMAGE_URI}"

if [[ -z "$(docker image ls -q "${ABFS_DOCKER_IMAGE_URI}")" ]]; then
  while ! 'docker image inspect -f true "${ABFS_DOCKER_IMAGE_URI}" &> /dev/null'; do
    echo "waiting for image to be fully pulled"
    sleep 1
  done
fi
