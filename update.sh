#!/bin/bash

# Exit script if any command fails
set -e

# Pull the latest changes from the Git repository
git pull origin master

# Use docker-compose to build (or rebuild) services
docker-compose build

# Stop and remove the current containers
docker-compose down

# Start up the containers in the background
docker-compose up -d

echo "Update complete."
