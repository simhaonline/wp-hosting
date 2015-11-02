#!/bin/bash

cat << EOF

server {
	listen 80;
	client_max_body_size 32m;
	server_name $PROJECT www.$PROJECT ${PROJECT}.ggs.ovh;
	location / {
		proxy_pass http://127.0.0.1:$WORDPRESS_PORT;
                include /etc/nginx/proxy_params;
	}
}

server {
	listen 80;
	client_max_body_size 32m;
	server_name phpmyadmin.$PROJECT phpmyadmin.${PROJECT}.ggs.ovh;
	location / {
		proxy_pass http://127.0.0.1:$PHPMYADMIN_PORT;
                include /etc/nginx/proxy_params;
	}
}

EOF
