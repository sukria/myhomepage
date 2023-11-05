#!/bin/bash

# Exit script if any command fails
set -e

# File containing the dependencies
DEPS_FILE="docker.cpandeps"

# Function to check if a module is available on CPAN with the specified version
check_module() {
  local module=$1
  local version=$2
  if cpanm --info "$module" | grep -q "$version"; then
    echo "Module $module version $version is available on CPAN."
  else
    echo "Module $module version $version is NOT available on CPAN."
    exit 1
  fi
}

# Check each module listed in the dependencies file
while IFS=';' read -r module version; do
  check_module "$module" "$version"
done < "$DEPS_FILE"

# If all modules are available, continue with the update process
echo "All modules are available on CPAN. Starting the update process."

# Pull the latest changes from the Git repository
git pull origin master

# Use docker-compose to build (or rebuild) services
docker-compose build

# Stop and remove the current containers
docker-compose down

# Start up the containers in the background
docker-compose up -d

echo "Update complete."
