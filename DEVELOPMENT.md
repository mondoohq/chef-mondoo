# Development

This document is for contributors and maintainers of the `mondoo` cookbook.

## Testing

This repo uses [Test Kitchen](https://kitchen.ci/) for integration tests, [ChefSpec](https://github.com/chefspec/chefspec) for unit tests, and [Cookstyle](https://docs.chef.io/workstation/cookstyle/) for linting. All three run in CI.

```bash
# Lint
cookstyle .

# Unit tests
chef exec rspec

# Integration tests (requires Docker)
MONDOO_TOKEN=ey...Bp kitchen test
```

For integration tests, add `MONDOO_API_PROXY` to the variables to exercise the proxy setting. You can "enter" the resulting test environment by changing the `kitchen test` command to `kitchen login`. To speed up local testing, comment out unneeded entries in `kitchen.yml`. See [TESTING.MD](TESTING.MD) for more Test Kitchen commands.

The `Makefile` provides additional checks used in CI:

```bash
make test/spell-check       # spell check via typos
make license                # check copyright/license headers
make license/headers/apply  # apply missing license headers
```

## Releasing

Releases are published to [Chef Supermarket](https://supermarket.chef.io/cookbooks/mondoo) automatically by the **Supermarket Release** GitHub Action. To cut a release:

1. Bump the `version` in `metadata.rb`.
2. Update `CHANGELOG.md`.
3. Merge to `main`.

When `metadata.rb`'s version changes on `main`, the workflow installs the [Cinc CLI](https://github.com/tas50/cinc-cli) and runs `cinc supermarket share` using the `SUPERMARKET_USER` / `SUPERMARKET_PEM` repository secrets. A release can also be triggered manually from the Actions tab (`workflow_dispatch`).
