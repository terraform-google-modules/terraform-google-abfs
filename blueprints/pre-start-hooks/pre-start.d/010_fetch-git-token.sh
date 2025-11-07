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

# Configuration
# Read PROJECT_NUMBER from environment variable, otherwise it will be an empty string
PROJECT_NUMBER="${PROJECT_NUMBER}"
SECRET_NAME="${SECRET_NAME:-GIT_TOKEN}" # Default to "GIT_TOKEN" if not set
SECRET_VERSION="${SECRET_VERSION:-latest}" # Default to "latest" if not set
GITHUB_USERNAME="${GITHUB_USERNAME:-git}" # Default to "git" if not set

# Function to handle errors
handle_error() {
    local exit_code="$1"
    local message="$2"
    if [ "$exit_code" -ne 0 ]; then
        echo "Error: $message" >&2
        exit "$exit_code"
    fi
}

# 1. Get the project number, falling back to the metadata server if not set
if [ -z "$PROJECT_NUMBER" ]; then
    echo "PROJECT_NUMBER not set. Attempting to retrieve from GCP metadata server..."
    PROJECT_NUMBER=$(curl -f "http://metadata.google.internal/computeMetadata/v1/project/numeric-project-id" \
      --header "Metadata-Flavor: Google" \
      --silent)
    handle_error $? "Failed to retrieve project number from metadata server. Ensure the script is running on a GCP resource."
fi

# 2. Retrieve the access token from the metadata server
ACCESS_TOKEN=$(curl -f "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token?scopes=https://www.googleapis.com/auth/cloud-platform" \
  --header "Metadata-Flavor: Google" \
  --silent | jq -r .access_token)
handle_error $? "Failed to retrieve access token. Is this script running on a GCP resource?"

# 3. Access the secret from Secret Manager
API_URL="https://secretmanager.googleapis.com/v1/projects/${PROJECT_NUMBER}/secrets/${SECRET_NAME}/versions/${SECRET_VERSION}:access"
RESPONSE=$(curl -f -s -X GET "${API_URL}" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json")
handle_error $? "Failed to access secret. Check project number, secret name, version, and IAM permissions."

# 4. Parse and decode the secret payload
BASE64_PAYLOAD=$(echo "$RESPONSE" | jq -r .payload.data)
if [ -z "$BASE64_PAYLOAD" ]; then
    handle_error 1 "The secret payload is empty. The secret may not exist or the retrieved data is invalid."
fi

SECRET_VALUE=$(echo "$BASE64_PAYLOAD" | base64 --decode)

# 5. Configure Git
git config --global url."https://${GITHUB_USERNAME}:${SECRET_VALUE}@github.com".insteadOf "https://github.com"
echo "Successfully configured Git with the secret from Secret Manager."
