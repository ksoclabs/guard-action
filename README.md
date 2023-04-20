# KSOC Guard Action

KSOC finds misconfigurations in your Kubernetes posture as part of your GitHub Actions CI workflow.

This action is used to execute a set of KSOC policies against the Kubernetes manifests in a given repository. There are two sources of policies that can be used:

- Policies fetched from your KSOC account. This requires the `ksoc_account_id`, `ksoc_access_key_id` and `ksoc_secret_key` inputs to be provided.
- Policies from the `/policies` directory embedded in this action. This requires the `policy_dir` input to be provided with `/policies` value.

## Example Usage With Policies From KSOC Account

```yaml
name: ksoc-guard

on:
  pull_request:

jobs:
  ksoc-guard:
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: KSOC Guard
        uses: ksoclabs/guard-action@v0.0.8
        with:
          ksoc_account_id: <KSOC_ACCOUNT_ID>
          ksoc_access_key_id: ${{ secrets.KSOC_ACCESS_KEY_ID }}
          ksoc_secret_key: ${{ secrets.KSOC_SECRET_KEY }}
```

## Example Usage With Policies From Repository

```yaml
name: ksoc-guard

on:
  pull_request:

jobs:
  ksoc-guard:
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: KSOC Guard
        uses: ksoclabs/guard-action@v0.0.8
        with:
          policy_dir: /policies
```

## Optional Inputs

There are numerous optional inputs that can be used to configure the action:
- `fail_on_severity`: The severity level that will cause the action to fail. If not provided, the action will never fail.
- `format`: The format of the output. If not provided, the default `ci-table` format will be used which is suitable for use in a CI environment.
- `ignored_paths`: A comma separated list of paths to ignore. If not provided, no paths will be ignored.
- `ksoc_api_url`: The URL of the KSOC API. If not provided, the default `https://api.ksoc.com` will be used.
- `paths`: A comma separated list of paths to scan. If not provided, all paths in the repository will be scanned.
- `policy_ids`: A comma separated list of policy IDs to execute. If not provided, all policies in the KSOC account will be executed.
- `policy_tags`: A comma separated list of policy tags to execute. If not provided, all policies in the KSOC account will be executed.

## Outputs

KSOC Guard Action is storing the results of the scan in the output called `results`. This can be used to create a comment on the PR with the results of the scan. The following example shows how to do this (note that `pull-resuests` permission is required for this):

```yaml
name: ksoc-guard

on:
  pull_request:

jobs:
  ksoc-guard:
    permissions:
      contents: read
      pull-requests: write
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: KSOC Guard
        uses: ksoclabs/guard-action@v0.0.8
        with:
          ksoc_account_id: <KSOC_ACCOUNT_ID>
          ksoc_access_key_id: ${{ secrets.KSOC_ACCESS_KEY_ID }}
          ksoc_secret_key: ${{ secrets.KSOC_SECRET_KEY }}
      - name: comment
        if: success() || failure()
        uses: actions/github-script@v6
        env:
          STATUS: ${{ steps.ksoc-guard.outcome == 'success' && 'success ✅' || 'failure ❌' }}
        with:
          script: |
            const output = `
              Policy Executor: ${{ env.STATUS }}

              \`\`\`
              ${{ steps.ksoc-guard.outputs.results }}
              \`\`\`
              `
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })
```

## Embedded Policies

The following policies are embedded in this action if used with the `policy_dir` input:

| Policy ID                       | Policy Title                                                   | Severity |
|---------------------------------|----------------------------------------------------------------|----------|
| KSOC-K8S-RUN-AS-HIGH-UID        | Container(s) not running with a high UID                       | low      |
| KSOC-K8S-PRIV-ESC               | Container(s) allow privilege escalation                        | medium   |
| KSOC-K8S-IMAGE-LATEST           | Container(s) image tag is set to latest                        | low      |
| KSOC-K8S-CAP-SYSADMIN           | CAP_SYS_ADMIN Linux capability is in use in container(s)       | high     |
| KSOC-K8S-HOST-PID               | Host PID flag set to true in container(s)                      | low      |
| KSOC-K8S-HOST-IPC               | hostIPC flag set to true in container(s)                       | low      |
| KSOC-K8S-HOST-NETWORK           | hostNetwork flag set to true                                   | low      |
| KSOC-K8S-NET-RAW                | NET_RAW capability detected in container(s)                    | medium   |
| KSOC-K8S-ROLE-CLUSTERADMIN      | Ensure that the cluster-admin role is only used where required | high     |
| KSOC-K8S-WILDCARD-APIGROUPS     | Minimize wildcard use in Roles and ClusterRoles:ApiGroups      | medium   |
| KSOC-K8S-WILDCARD-RESOURCES     | Minimize wildcard use in Roles and ClusterRoles:Resources      | medium   |
| KSOC-K8S-WILDCARD-VERBS         | Minimize wildcard use in Roles and ClusterRoles:Verbs          | medium   |
| KSOC-K8S-DEFAULT-SERVICEACCOUNT | Ensure that default service accounts are not actively used.    | medium   |
| KSOC-K8S-SECURITYCONTEXT        | Container(s) running without defined securityContext           | medium   |
| KSOC-K8S-SECURITYCONTEXT-POD    | Pod running without defined securityContext                    | medium   |
