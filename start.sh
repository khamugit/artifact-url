#!/bin/sh -e

cmd=$1

if [ -z $cmd ]; then
    ruby /app.rb help
    exit 1
fi

conjur env run -c $cmd.secrets -- ruby /app.rb $@
