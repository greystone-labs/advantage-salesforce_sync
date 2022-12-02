export COMPOSE_PROJECT_NAME=advantage
export DOCKER_BUILDKIT=1

.PHONY: docker-build
docker-build:
	docker-compose build --progress=plain

.PHONY: docker-down
docker-down:
	docker-compose down

.PHONY: bundle
bundle:
	docker-compose run --rm salesforce-sync bundle install -j4

.PHONY: setup
setup: docker-build

.PHONY: serve
serve:
	echo "no implemented"

.PHONY: test
test:
	docker-compose run --rm salesforce-sync bundle exec rspec

.PHONY: shell
shell:
	docker-compose run --rm salesforce-sync /bin/bash

.PHONY: lint
lint:
	docker-compose run --rm salesforce-sync rubocop

.PHONY: check
check: lint test
	echo 'Deployable!'
