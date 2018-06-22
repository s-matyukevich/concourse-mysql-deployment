#!/bin/bash -e

set -o pipefail

bosh -n -d mysql deploy concourse-mysql-deployment/ci/manifests/mysql.yml \
    -v cf_api_url_dc1=$CF_API_URL_DC1 \
    -v cf_admin_password_dc1=$CF_ADMIN_PASSWORD_DC1 \
    -v cf_skip_ssl_validation_dc1=$CF_SKIP_SSL_VALIDATION_DC1 \
    -v cf_api_url_dc2=$CF_API_URL_DC2 \
    -v cf_admin_password_dc2=$CF_ADMIN_PASSWORD_DC2 \
    -v cf_skip_ssl_validation_dc2=$CF_SKIP_SSL_VALIDATION_DC2 \
    -v broker_ip_dc1=$BROKER_IP_DC1 \
    -v broker_ip_dc2=$BROKER_IP_DC2 

