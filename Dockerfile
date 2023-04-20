FROM us.gcr.io/ksoc-public/policy-executor:v0.0.9

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
