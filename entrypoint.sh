#!/bin/sh -l

EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
if [ $FORMAT = "sarif" ]; then
  SARIF_OUTPUT_FILE_NAME="./report.sarif"
  /app/policy-executor policies execute > $SARIF_OUTPUT_FILE_NAME
  exit_code=$?
  echo "sarif=$SARIF_OUTPUT_FILE_NAME" >> $GITHUB_OUTPUT
else
  echo "results<<$EOF" >> $GITHUB_OUTPUT
  /app/policy-executor policies execute >> $GITHUB_OUTPUT
  exit_code=$?
  echo "$EOF" >> $GITHUB_OUTPUT
fi
exit $exit_code
