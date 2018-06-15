SOURCES := sources.tar
VIRTUALENV ?= /usr/bin/virtualenv
VENV_DIR := .venv
VENV_ACTIVATE := . $(VENV_DIR)/bin/activate
PWD := $(shell pwd)
WEBAPP_DIR := etc/status

# Create source archive
.PHONY: tarball
tarball:
	git archive --format=tar HEAD^{tree} > $(SOURCES)

# Build zuul bundle
.PHONY: build
build: build.state

build.state:
	$(VIRTUALENV) $(VENV_DIR)
	$(VENV_ACTIVATE) && pip install -U pip
	$(VENV_ACTIVATE) && pip install -r requirements.txt
	$(VENV_ACTIVATE) && ./etc/status/fetch-dependencies.sh # web assets fetch
	$(VENV_ACTIVATE) && python setup.py install
	rm -f $(VENV_DIR)/pip-selfcheck.json
	$(VIRTUALENV) --relocatable $(VENV_DIR)
	touch $@

# Install zuul bundle into DESTDIR
.PHONY: install
install:
	install -d -m 755 '$(DESTDIR)'
	cp -a $(VENV_DIR)/* '$(DESTDIR)'
	cp -a $(WEBAPP_DIR) '$(DESTDIR)'

.PHONY: clean
clean:
	rm -rf $(SOURCES) $(PIP_DEPS_DIR) $(VENV_DIR)

.PHONY: check
check: build.state
	$(VENV_ACTIVATE) && \
		pip install --requirement test-requirements.txt
	$(VENV_ACTIVATE) && \
        OS_TEST_TIMEOUT=60 python setup.py testr --slowest
