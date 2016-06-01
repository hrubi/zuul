# Testing in docker

```sh
./docker/build              # build the container
./docker/tox -e py26        # run the tox for py26 env in container
```
# Testing in docker on Mac

Find out the user ID of the user running docker inside the boot2docker or
dockermachine:
```sh
id -u
```

Run the tests with right user ID:
```sh
DOCKER_USER_ID=<UID> ./docker/tox -e py26
```
