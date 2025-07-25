#!/bin/bash -ex
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

function setup_disk() {
  device_by_id="$1"
  disk_mountpoint="$2"
  if mountpoint -q "$disk_mountpoint"; then
    echo "$disk_mountpoint already mounted, skip mounting"
  else
    mkdir -p "$disk_mountpoint"
    # Check if disk is formatted.
    if cmp -n 4096 /dev/zero "$device_by_id"; then
      mkfs.ext4 -F "$device_by_id"
    else
      fsck.ext4 -tvy "$device_by_id"
    fi
    mount -o discard,errors=panic "$device_by_id" "$disk_mountpoint"
  fi
}

source "$(dirname "$0")/abfs_base.sh"
echo "running abfs_datadisk.sh"
echo "DATADISK_MOUNTPOINT: $DATADISK_MOUNTPOINT"

set -x
setup_disk /dev/disk/by-id/google-abfs-server-storage "${DATADISK_MOUNTPOINT}"
set +x
