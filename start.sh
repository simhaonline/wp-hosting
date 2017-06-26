#!/bin/bash

. _scripts/base.sh

if test -e $PROJECT/docker-compose.yml; then
    cd $PROJECT
    docker-compose up -d
    cd ..
    sleep 2
    ./fix-permissions.sh $PROJECT
    if ./wp-cli.sh $PROJECT core is-installed; then
        echo "Wordpress already installed."
    else
        echo "Installing Wordpress..."
        ./wp-cli.sh $PROJECT core install --url=http://$DOMAIN --title=$DOMAIN --admin_user=admin --admin_password=$ADMIN_PASSWORD --admin_email=admin@$DOMAIN
        ./wp-cli.sh $PROJECT plugin install hectane --activate
        ./wp-cli.sh $PROJECT option set hectane_settings '{"host":"mail","port":"8025","tls_ignore":"on","username":"","password":""}' --format=json
    fi
    ./fix-permissions.sh $PROJECT

    # Add the PHP "zip" extension
    function docker_php_ext_install() {
        docker exec -it ${APPNAME}_wordpress_1 sh -c "test -e /usr/local/lib/php/extensions/*/${1}.so || docker-php-ext-install $1"
    }
    docker_php_ext_install zip

    # Add the Imagemagick extension
    docker exec -it ${APPNAME}_wordpress_1 sh -c "test -e /usr/local/lib/php/extensions/*/imagick.so || (apt-get update && apt-get install -y --no-install-recommends libmagickwand-dev && rm -rf /var/lib/apt/lists/* && pecl install imagick-3.4.1 && docker-php-ext-enable imagick)"

    echo
    echo "$PROJECT is available at the following ports:"
    echo
    echo " - wordpress: $WORDPRESS_PORT"
    echo " - phpMyAdmin: $PHPMYADMIN_PORT"
    echo
    echo "Make sure to setup your links into the master proxy."
    echo
    echo "SFTP is open on port $SFTP_PORT"
    echo
else
    echo "ERROR: no docker-compose.yml file"
    echo "Run the command below instead:"
    echo
    echo "./initialize.sh $PROJECT"
    echo
fi
