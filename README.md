LXC Appliance:

```
$ docker run \
	--rm \
	-v $HOME/.netrc:/root/.netrc \
	conjurinc/artifact-url \
	appliance-lxc -v 2015-05-14_010025 -e 1440
```

Docker appliance:

```
$ docker run \
	--rm \
	-v $HOME/.netrc:/root/.netrc \
	conjurinc/artifact-url \
	appliance-docker -v 4.5.0 -e 1440
```

Debian package:

```
$ docker run \
	--rm \
	-v $HOME/.netrc:/root/.netrc \
	conjurinc/artifact-url \
	deb -v 0.3.3 -e 1440 conjur-authn-ldap-appliance
```
