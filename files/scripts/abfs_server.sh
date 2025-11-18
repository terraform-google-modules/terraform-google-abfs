#!/bin/bash
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

set -ex

source "$(dirname "$0")/abfs_base.sh"

DOCKER_RUN_ARGS=(--privileged \
    --cap-add=all \
    --pid=host \
    --env-file /var/run/abfs/abfs_container.env \
    --publish 50051:50051
)

if [[ -n "${DATADISK_MOUNTPOINT}" ]]; then
  DOCKER_RUN_ARGS+=(--volume ${DATADISK_MOUNTPOINT}:/abfs-storage)
fi

if [[ -n "${PRE_START_HOOKS_MOUNTPOINT}" ]]; then
  DOCKER_RUN_ARGS+=(--mount type=bind,src=${PRE_START_HOOKS_MOUNTPOINT},dst=/etc/abfs/pre-start.d,readonly,bind-recursive=writable)
fi

docker run --name=abfs-server --log-driver=journald \
  "${DOCKER_RUN_ARGS[@]}" "${ABFS_DOCKER_IMAGE_URI}" \
  ${ABFS_CMD} 

# Wait until the container is definitely started
while "$( docker container inspect -f '{{.State.Running}}' abfs-server )" != "true"; do
  echo "waiting for image to be fully started"
  sleep 1
done
