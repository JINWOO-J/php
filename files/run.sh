#!/bin/bash
export FPM_LISTEN=${FPM_LISTEN:-"0.0.0.0:9000"}
export FPM_USER=${FPM_USER:-"app"}
export FPM_GROUP=${FPM_GROUP:-"app"}
export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}
export PHP_INI_DIR=${PHP_INI_DIR:-"/etc/php"}
export EXTRACONF=${EXTRACONF:-";"}

if [ $USE_DOCKERIZE == "yes" ];
then
    echo "USE the dockerize template";
    dockerize -template /etc/php/php-fpm.tmpl > /etc/php/php-fpm.conf
fi

source /usr/local/etc/envvars
php-fpm-env > ${PHP_INI_DIR}/php-fpm-env.conf
/usr/local/sbin/php-fpm -c ${PHP_INI_DIR} --nodaemonize
