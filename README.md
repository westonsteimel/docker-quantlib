# QuantLib in Docker
Dockerized environment with [QuantLib](http://quantlib.org) based on [Alpine Linux](https://alpinelinux.org).

## Pull command
`docker pull quay.io/westonsteimel/quantlib`

## Usage notes

The following command will execute the `quantlib-test-suite` within the container:

`docker run --rm -it --cap-drop all -e BOOST_TEST_LOG_LEVEL=message quay.io/westonsteimel/quantlib quantlib-test-suite`

Everything within the container executes as the non-root quantlib user by default.
