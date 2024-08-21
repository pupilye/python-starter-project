REQUIREMENTS_IN_FILES ?= $(shell find . -name '*.in' -name '*requirements*')
REQUIREMENTS_TXT_FILES ?= $(REQUIREMENTS_IN_FILES:.in=.txt)

PYTHON_VERSION=3.12.4
PROJECT_NAME_SHORT=example-project
venv_name=$(PROJECT_NAME_SHORT)-$(PYTHON_VERSION)

DOCKER_DEFAULT_PLATFORM=linux/amd64

.PHONY: init
init: ## initialize the environment
	$(call run-install-python)
	$(call run-create-virtualenv)
	poetry check --lock
	poetry install
	@pyenv rehash

.PHONY: poetry-init
poetry-init: ## initialize the project toml file
	poetry init

.PHONY: poetry-lock-update
poetry-lock-update: ## update the poetry.lock file
	poetry lock

.PHONY: poetry-lock-no-update
poetry-lock-no-update: ## Do not update locked versions, only refresh lock file.
	poetry lock --no-update

define run-install-python
	@pyenv install $(PYTHON_VERSION) -s
	@echo -e "\033|0;32m $(PYTHON_VERSION) installed \033|0m"
endef

define run-create-virtualenv
	@if ! [ -d "$(pyenv root)/versions/$(venv_name)" ]; then\
		pyenv virtualenv $(PYTHON_VERSION) $(venv_name);\
		pyenv local $(venv_name);\
		pip install --upgrade pip pip-tools setuptools wheel;\
		pip install poetry;\
	fi;
	@pyenv local $(venv_name)
	@echo -e "\033|0;32m $(venv_name) virtualenv activated \033|0m"
endef
