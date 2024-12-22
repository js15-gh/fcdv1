#!/bin/bash

# Load saved project variables
if [ -f ~/.project-env ]; then
    source ~/.project-env
else
    echo "Warning: ~/.project-env not found. Some variables might not be set."
fi

# Activate virtual environment
if [ -f venv/bin/activate ]; then
    source venv/bin/activate
else
    echo "Error: Virtual environment not found. Please run: python3 -m venv venv"
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "Error: .env file not found"
    exit 1
fi

# Export additional variables
export PYTHONPATH=${PYTHONPATH:+${PYTHONPATH}:}$(pwd)

# Verify critical environment variables
MISSING_VARS=0

# Check PROJECT_ID
if [ -z "$PROJECT_ID" ]; then
    echo "Error: PROJECT_ID is not set"
    MISSING_VARS=1
fi

# Check REGION
if [ -z "$REGION" ]; then
    echo "Error: REGION is not set"
    MISSING_VARS=1
fi

# Check GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
    echo "Error: GITHUB_USERNAME is not set"
    MISSING_VARS=1
fi

# Check GOOGLE_APPLICATION_CREDENTIALS
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "Error: GOOGLE_APPLICATION_CREDENTIALS is not set"
    MISSING_VARS=1
fi

if [ $MISSING_VARS -eq 1 ]; then
    echo "Some critical environment variables are missing. Please check .env file."
    exit 1
fi

# Verify Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Print environment status
echo "Environment Setup Complete!"
echo "=========================="
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "GitHub Username: $GITHUB_USERNAME"
echo "Python Version: $(python --version)"
echo "Docker Version: $(docker --version)"
echo "Virtual Environment: Active"
echo "Working Directory: $(pwd)"
echo "=========================="
