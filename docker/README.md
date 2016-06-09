# Testing in docker

## Prerequisite
tox

## Set up dox

```sh
git clone --branch gd-patches https://github.com/hrubi/dox
tox -c dox/tox.ini -e venv --notest
source dox/.tox/venv/bin/activate
```

## Run tests
```sh
dox
```
