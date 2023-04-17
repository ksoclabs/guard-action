#!/bin/sh -l

EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
echo "results<<$EOF" >> $GITHUB_OUTPUT
/app/policy-executor policies execute >> $GITHUB_OUTPUT
exit_code=$?
echo "$EOF" >> $GITHUB_OUTPUT
exit $exit_code
