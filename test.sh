#!/bin/bash

# Get the diff output for the file
diff_output=$(git diff --no-prefix -U1000 origin/dev ./my-express-app/services/my-express-app/subfolder2/subfolder3/routes/route2.js)

# Use awk to capture the router block and filter lines using grep
changed=$(echo "$diff_output" | awk '
/^[-+ ]*router\.(get|post|put|patch|options|head)\(/ {flag=1}
flag && /^[+-]/ {print $0; next}
flag && /^[ ]/ {print; next}
flag && /^\s*\);/ {flag=0}
' | grep '^[+-]')

# Print changed lines
echo -e "Changed lines:\n$changed"

if [ -n "$changed" ]; then
  echo "Changes detected in router block."
else
  echo "No changes detected in router block."
fi