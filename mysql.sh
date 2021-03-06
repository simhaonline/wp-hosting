#!/bin/bash

. "$(dirname "$0")/_scripts/base.sh"


TTY_OPT=-t
if [ "x$NO_TTY" = "x1" ]; then
	TTY_OPT=
fi

# Chec if there's a docker-compose.yml file
if test -e $PROJECT/docker-compose.yml; then
    shift
    docker exec -i $TTY_OPT ${APPNAME}_db_1 mysql -u admin -p${ADMIN_PASSWORD} wordpress "$@" # 2>&1 | grep -v "Warning: Using a password"
else
    echo "ERROR: Project not initialized."
fi
