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

# Initialize a flag to check if router changes are detected
router_changes_detected=false

# Iterate over changed files and check for router changes
for file in $changed_files; do
  echo "Processing file: $file"
  cat "$file"
  router_const=$(extract_router_const "$file")
  if [ -n "$router_const" ]; then
    echo "Found router constant '$router_const' in file '$file'"
    # Check if there are changes in router.* blocks
    echo "Running command: git diff -U5 origin/dev \"$file\""
    diff_output=$(git diff -U5 origin/dev "$file")
    echo "Diff output: $diff_output"

    # Check for changes within the router block
    router_block_changes=$(echo "$diff_output" | awk '
    BEGIN { inside_router_block = 0 }
    {
      if (inside_router_block) {
        if ($0 ~ /^\s*\)/) { inside_router_block = 0 }
        print $0
      }
      if ($0 ~ /'"${router_const}"'\.[a-z]+\(/) { inside_router_block = 1; print $0 }
    }' | grep -E '^[+-]')

    echo "Router block changes: '$router_block_changes'"
    if [ -n "$router_block_changes" ]; then
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