# Use pre-start hooks to modify the ABFS container before launching ABFS

This example shows how to use pre-start hooks to run custom scripts inside the ABFS (Android Build File System) uploader container before the main ABFS service starts.

Pre-start hooks are useful for preparing the container environment. For example, you can use them to:

*   Fetch credentials or secrets required to use your Android source.
*   Install additional packages or dependencies.

## How it works

The `abfs_uploaders` Terraform module accepts a `pre_start_hooks` variable, which is a path to a local directory containing one or more scripts.

When you run the `terraform apply` command:

1.  Terraform uses cloud-init to copy the scripts from the specified directory to the ABFS uploader host VMs.
2.  This directory is then mounted to the ABFS Docker container as a read-only volume at `/etc/abfs/pre-start.d`.
3.  An entrypoint script inside the container checks for this directory. Before starting the main ABFS service, it executes any executable scripts (<code>+x</code>) it finds there.
4.  The entrypoint script executes the scripts in alphabetical order. The entrypoint script waits for each hook to complete before proceeding to the next one. If any hook script fails (returns a non-zero exit code), the container startup stops.

## This example: Fetching a Git Token

This example provides a practical pre-start hook script, `pre-start.d/fetch-git-token.sh`, that securely fetches a Git token from Google Cloud Secret Manager and configures Git for `github.com` authentication. This is useful if your Android build needs to clone private repositories from GitHub.

### The hook script: `pre-start.d/fetch-git-token.sh`

This script performs the following steps:

1.  Determine the Google Cloud project number, either from a `PROJECT_NUMBER` environment variable or by querying the Google Cloud metadata server.
2.  Retrieve an access token for the VM's service account from the metadata server.
3.  Use this access token to call the `Secret Manager API` and retrieve a secret. By default, it looks for a secret named `GIT_TOKEN`.
4.  Configure Git to use the retrieved secret as an authentication token for all HTTPS requests to `github.com`.

### Terraform Configuration: `main.tf`

The `main.tf` file in this example shows how to use the `pre_start_hooks` variable:

```
module "abfs_uploaders" {
  source = "github.com/terraform-google-modules/terraform-google-abfs//modules/uploaders?ref=v0.8.0"

  # Other configuration here
  pre_start_hooks = "${path.module}/pre-start.d"
}
```

This configuration tells Terraform to package the contents of the local `pre-start.d` directory and make them available to the ABFS uploader containers.

## How to use this example

1.  Store your Git token in Secret Manager:
    *   Create a new secret in Google Cloud Secret Manager (for example, named `GIT_TOKEN`).
    *   Add your GitHub personal access token as the secret value.
2.  Grant permissions:
    *   Ensure the service account used by the ABFS uploader VMs has the **Secret Manager Secret Accessor** (`roles/secretmanager.secretAccessor`) IAM role for the secret you just created.
3.  Deploy with Terraform:
    *   Customize the `main.tf` file with your project details, such as project ID and zone, similar to the simple example.
    *   Run the `terraform init` and `terraform apply` commands.

After the ABFS uploader instances start, the hook script automatically runs, and your ABFS uploaders can authenticate against your private GitHub repositories. You can check the container logs to see the output from the hook script and verify that it ran successfully.
