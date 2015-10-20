#!/bin/sh -e

cmd=$1

if [ -z $cmd ]; then
    ruby ./app.rb help
    exit 1
fi

# Select the account based on the artifact type
if [ $cmd == "appliance-lxc" ]; then
	secrets_file=dev.secrets
else
	secrets_file=ci.secrets
fi

conjur env run -c $secrets_file -- ruby ./app.rb $@
