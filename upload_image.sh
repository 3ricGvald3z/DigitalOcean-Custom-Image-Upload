#!/bin/bash

# --- Configuration ---
# Replace these with your actual values
IMAGE_URL="https://example.com/path/to/your/image.qcow2"
IMAGE_NAME="my-custom-image-name"
IMAGE_REGION="nyc3"
IMAGE_FORMAT="qcow2" # e.g., raw, qcow2, vmdk, vdi, iso

# --- Main Script ---

echo "Starting image upload process..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "Error: doctl is not installed. Please install it and try again."
    exit 1
fi

# Check for a DigitalOcean access token
# You can set this as an environment variable or configure it with `doctl auth init`
if [ -z "$DO_TOKEN" ]; then
    echo "Warning: DO_TOKEN environment variable is not set."
    echo "Please configure doctl with your Personal Access Token using:"
    echo "doctl auth init"
    echo "or set the environment variable like so:"
    echo "export DO_TOKEN='your_token_here'"
fi

# Execute the doctl command to create the image
doctl compute image create "$IMAGE_NAME" \
  --url "$IMAGE_URL" \
  --region "$IMAGE_REGION" \
  --image-format "$IMAGE_FORMAT" \
  --wait

# Check the exit status of the previous command
if [ $? -eq 0 ]; then
    echo "Success! Image '$IMAGE_NAME' has been uploaded and is available in '$IMAGE_REGION'."
else
    echo "Error: Image upload failed. Please check the command output for more details."
    exit 1
fi
