.PHONY: test/spell-check
test/spell-check:
	act -j spelling --container-architecture linux/amd64

# Copywrite Check Tool: https://github.com/hashicorp/copywrite
license: license/headers/check

license/headers/check:
	copywrite headers --plan

license/headers/apply:
	copywrite headers
