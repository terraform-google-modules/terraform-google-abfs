# ABFS Environment Blueprint

This blueprint deploys a complete Android Build Filesystem (ABFS) environment on
Google Cloud. It provides a scalable and secure solution for building Android
and is ideal for teams looking to modernize their Android development
infrastructure. The blueprint also includes a sophisticated CI/CD pipeline for
creating and maintaining custom developer environments using Cloud Workstations.

## Deployed Resources

This blueprint will deploy the following key resources to stand up a fully
functional ABFS environment:

-   **Spanner Instance and Database**: A fully managed, mission-critical,
    relational database service that provides a scalable and highly available
    backend for ABFS.
-   **ABFS Server**: The core component of the Android Build Filesystem,
    deployed on Google Compute Engine (GCE).
-   **ABFS Uploaders**: Services responsible for uploading build artifacts into
    the ABFS environment.
-   **Optional ABFS Client**: A Compute Engine instance can be optionally
    created to act as a client for interacting with and testing the ABFS setup.

## ABFS Licensing and Deployment Flow

Deploying the ABFS environment involves a two-step process due to licensing
requirements:

1.  **Initial `terraform apply`**: Run `terraform apply` for the first time.
    This will provision the necessary project infrastructure and output the
    license information.

2.  **Submit EAP Form**: Use the license information from the Terraform output
    to fill out the EAP (Early Access Program) form provided by the Google team.
    This will initiate the licensing process for your service account.

3.  **Update `terraform.tfvars`**: Once you receive the license key, add it to
    your `terraform.tfvars` file. For example:
    ```hcl
    abfs_license = "your-license-key-here"
    ```

4.  **Final `terraform apply`**: Run `terraform apply` a second time. With the
    license key in place, Terraform will now deploy and start all the ABFS
    components, including the server and uploaders.

5.  **Seeding and Building**: After the deployment is complete, the ABFS
    uploaders will begin seeding the environment with data from the Gerrit
    server. Once this process is finished, you can use the ABFS client to mount
    the filesystem and start your first Android build.

## Automated Custom Images for Cloud Workstations

A key feature of this blueprint is its ability to create and manage custom
container images for
[Cloud Workstations](https://cloud.google.com/workstations). This allows you to
provide developers with tailored, up-to-date, and secure development
environments like **Android Studio (AS)**,
**Android Studio for Platform (ASfP)**, and more.

The blueprint sets up a complete, GitOps-driven CI/CD pipeline to automate the
build, deployment, and maintenance of these custom images.

### The CI/CD Workflow for Custom Images

The process is designed to be fully automated after the initial setup:

1.  **Initial Deployment (`terraform apply`)**:
    When you first apply the Terraform configuration for this blueprint, it
    provisions the entire CI/CD foundation, including:
    *   A **Secure Source Manager (SSM)** repository to host the source code for
        your custom images.
    *   A **Cloud Build trigger** configured with a webhook to automatically
        start a build on a `git push` to the SSM repository.
    *   An **Artifact Registry** repository to securely store the built
        container images.
    *   **Cloud Workstations configurations** that are pre-configured to use the
        `:latest` tag of your custom images.
    *   A **Cloud Scheduler** job to periodically rebuild the images.

2.  **Adding Image Source Code**:
    After the infrastructure is deployed, you push the source code for your
    custom workstation images to the repository. An example
    repository with Dockerfiles and build configurations can be found here:
    [Android Open Source Project Images](https://github.com/GoogleCloudPlatform/cloud-workstations-custom-image-examples/tree/main/examples/images/android-open-source-project).
    ```bash
    # Configure the gcloud helper for Secure Source Manager
    git config --global credential.'https://*.*.sourcemanager.dev'.helper gcloud.sh

    # Clone the example repository
    git clone https://github.com/GoogleCloudPlatform/cloud-workstations-custom-image-examples.git
    cd cloud-workstations-custom-image-examples/examples/images/android-open-source-project

    # Add your repository as a remote
    git remote add private $(terraform output -raw secure_source_manager_repository_git_https)

    # Push the code to the main branch
    git push private main
    ```

3.  **Automated Build and Deployment**:
    The `git push` automatically triggers the Cloud Build pipeline via a
    webhook. Cloud Build:
    *   Builds the container image from your Dockerfile.
    *   Pushes the newly built image to Artifact Registry.
    *   Tags the image as `:latest`.

4.  **Periodic Rebuilds for Security**:
    The Cloud Scheduler job runs on a defined schedule (e.g., nightly) and
    triggers the same Cloud Build pipeline. This is critical for security and
    maintenance, as it ensures your custom images are regularly rebuilt on top
    of their base layers. This process automatically incorporates the latest OS
    updates and security patches into your development environments without any
    manual intervention.

5.  **Seamless User Experience**:
    When a developer starts a new Cloud Workstation, it automatically pulls the
    `:latest` image tag from Artifact Registry. Because of the automated build
    and periodic rebuild process, they are always launching a workstation that
    is up-to-date, secure, and contains the preinstalled tools they need.
