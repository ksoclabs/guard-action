# Releasing KSOC Guard Action

## Creating a new Tag

Releasing a new version of KSOC Guard Action is done by creating a new tag in the repository. The tag name should be in the format `vX.Y.Z` where `X`, `Y` and `Z` are numbers (standard semver format). Tagging can be automated with `semtag final -s patch` command. Before tagging, the version in README.md should be updated as it is reflected in the GitHub Marketplace documentation: https://github.com/marketplace/actions/ksoc-guard.

## Publishing to GitHub Marketplace

To publish a new version of KSOC Guard Action to GitHub Marketplace, go to https://github.com/ksoclabs/guard-action/releases and click on the `Draft a new release` button. Make sure that `Publish this Action to the GitHub Marketplace` is checked and `Continuos Integration` and `Security` are selected as categories. Choose a tag created in the previous step and click on `Generate release notes` button. The release notes will be generated based on the commit messages since the last release. Make sure that the release notes are correct and `Set as the latest release` is checked. Click on `Publish release` button and the new version of KSOC Guard Action should be available in the GitHub Marketplace shortly after that.
