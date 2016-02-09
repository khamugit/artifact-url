# artifact-url

To generate an expiring link to a Docker tarball:

```sh-session
$ docker build -t conjurinc/artifact-url .

$ docker run \
	--rm \
	-v $HOME/.netrc:/root/.netrc \
	conjurinc/artifact-url \
	appliance-docker -v 4.6.0 -e 1440
https://conjur-ci-images.s3.amazonaws.com/docker/conjur-appliance-4.6.0.tar?AWSAccessKeyId=AKIAJPO6V53S56MPS6SQ&Expires=1455135183&Signature=z6zUQskd39WQZGAlf3ydZ52hGdc%3D
```
