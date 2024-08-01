#!/bin/bash

# Get the list of changed files compared to the base branch
changed_files=$(git diff --name-only origin/dev | grep 'services/.*/routes/.*\.js' | grep -v 'services/.*/lambda/')
echo "Changed files: $changed_files"

# Function to extract router constant
extract_router_const() {
  file=$1
  router_const=$(grep -oP '(?<=const )\w+(?=\s*=\s*express\.Router\(\)\s*;)' "$file")
  echo "$router_const"
}

# Function to capture changes in router block
capture_router_block_changes() {
  diff_output=$1
  router_const=$2

  # Use awk to capture the router block and check for changes
  router_block_changes=$(echo "$diff_output" | awk -v router_const="$router_const" '
  /router_const\.(get|post|put|patch|options|head|delete)\(/ {flag=1}
  flag {print}
  /);/ {flag=0}' | grep -E '^[+-]')

  echo "Router block changes: '$router_block_changes'"
  if [ -n "$router_block_changes" ]; then
    return 0
  else
    return 1
  fi
}

# Initialize a flag to check if router changes are detected
router_changes_detected=false

# Iterate over changed files and check for router changes
for file in $changed_files; do
  echo "Processing file: $file"
  router_const=$(extract_router_const "$file")
  if [ -n "$router_const" ]; then
    echo "Found router constant '$router_const' in file '$file'"

    # Get the diff output for the file
    diff_output=$(git diff origin/dev "$file")
    echo "Diff output: $diff_output"

    # Capture changes in router blocks using the extracted router constant
    if capture_router_block_changes "$diff_output" "$router_const"; then
      echo "Change detected in router block of file: $file"
      router_changes_detected=true
    fi
  else
    echo "No router constant found in file '$file'"
  fi
done

# Check if any router changes were detected
if [ "$router_changes_detected" = true ]; then
  echo "Router changes detected. Proceeding with the pipeline."
  exit 0
else
  echo "No relevant changes detected."
  exit 1
fi