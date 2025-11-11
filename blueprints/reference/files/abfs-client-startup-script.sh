#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- 1. Install Base Dependencies ---
echo "Updating package lists..."
sudo apt update
echo "Installing base dependencies..."
sudo apt install -y --no-install-recommends curl gnupg psmisc git rsync zip unzip

# --- 2. Add Google Cloud SDK Key ---
GPG_KEY_FILE="/usr/share/keyrings/cloud.google.gpg"
if [ ! -f "$GPG_KEY_FILE" ]; then
  echo "Adding Google Cloud SDK GPG key..."
  curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o "$GPG_KEY_FILE"
else
  echo "Google Cloud SDK GPG key already exists."
fi

# --- 3. Add Source for apt-transport-artifact-registry ---
AR_TRANSPORT_SOURCE_FILE="/etc/apt/sources.list.d/apt-transport-artifact-registry.list"
AR_TRANSPORT_LINE="deb [signed-by=$GPG_KEY_FILE] https://packages.cloud.google.com/apt apt-transport-artifact-registry-stable main"

if [ ! -f "$AR_TRANSPORT_SOURCE_FILE" ]; then
  echo "Adding Artifact Registry transport source..."
  echo "$AR_TRANSPORT_LINE" | sudo tee "$AR_TRANSPORT_SOURCE_FILE"
  # Run apt update immediately after adding the source for the transport package
  sudo apt update
else
  echo "Artifact Registry transport source file already exists."
fi

# --- 4. Install apt-transport-artifact-registry ---
echo "Installing apt-transport-artifact-registry..."
sudo apt install -y --no-install-recommends apt-transport-artifact-registry

# --- 5. Add Source for ABFS Binaries (using ar+) ---
ABFS_SOURCE_FILE="/etc/apt/sources.list.d/abfs-binaries.list"
ABFS_SOURCE_LINE="deb [signed-by=$GPG_KEY_FILE] ar+https://us-apt.pkg.dev/projects/abfs-binaries abfs-apt-alpha-public main"

if [ ! -f "$ABFS_SOURCE_FILE" ]; then
  echo "Adding ABFS binaries Artifact Registry source..."
  echo "$ABFS_SOURCE_LINE" | sudo tee "$ABFS_SOURCE_FILE"
else
  echo "ABFS binaries Artifact Registry source file already exists."
fi

# --- 6. Update Apt Cache for Final Packages ---
echo "Updating package lists for final installs..."
sudo apt update

# --- 7. Install Final Packages ---
echo "Installing abfs-client and casfs-kmod..."
sudo apt install -y --no-install-recommends abfs-client "casfs-kmod-$(uname -r)"

echo "Script finished."