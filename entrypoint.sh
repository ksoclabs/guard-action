#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "policy_results=$time" >> $GITHUB_OUTPUT