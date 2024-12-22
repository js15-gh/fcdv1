#!/bin/bash

# Set project variables
export PROJECT_ID=fcdv1-20241222
export PROJECT_NAME_GCP=fcdv1
export REGION=us-west1
export SA_NAME=fcdv1-service

# Print configuration
echo "Project configuration:"
echo "Project ID: $PROJECT_ID"
echo "Project Name: $PROJECT_NAME_GCP"
echo "Region: $REGION"
echo "Service Account: $SA_NAME"

# Create new project
echo "Creating new GCP project..."
gcloud projects create $PROJECT_ID --name="$PROJECT_NAME_GCP"

# Set as default project
echo "Setting as default project..."
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "Enabling required APIs..."
gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com \
    containerregistry.googleapis.com \
    secretmanager.googleapis.com

# Create service account
echo "Creating service account..."
gcloud iam service-accounts create $SA_NAME \
    --display-name="$PROJECT_NAME_GCP Service Account"

# Get service account email
export SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
echo "Service account email: $SA_EMAIL"

# Grant necessary roles
echo "Granting IAM roles..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/secretmanager.secretAccessor"

# Create and download key
echo "Creating service account key..."
gcloud iam service-accounts keys create ./service-account-key.json \
    --iam-account=$SA_EMAIL

# Create .env file
echo "Creating .env file..."
cat > .env << EOF
# Project settings
PROJECT_ID=${PROJECT_ID}
REGION=${REGION}
GITHUB_USERNAME=js15-gh

# Service account
GOOGLE_APPLICATION_CREDENTIALS=./service-account-key.json

# Application settings
APP_ENV=development
LOG_LEVEL=debug
EOF

echo "Setup complete!"
