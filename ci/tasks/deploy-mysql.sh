#!/bin/bash -e

set -o pipefail

mysql_ips_dc1_raw=${MYSQL_IPS_DC1/[/}
mysql_ips_dc1_raw=${mysql_ips_dc1_raw/]/}
mysql_ips_dc2_raw=${MYSQL_IPS_DC2/[/}
mysql_ips_dc2_raw=${mysql_ips_dc2_raw/]/}
combined_ips="[$mysql_ips_dc1_raw,$mysql_ips_dc2_raw,$BACKUP_IP_DC1]"
combined_instances=$(echo "$combined_ips" | yaml2json | jq "map_values({address: .})")
bosh -n -d mysql deploy concourse-mysql-deployment/ci/manifests/mysql.yml \
    --vars-store=creds.yml \
    -v cf_api_url_dc1=$CF_API_URL_DC1 \
    -v cf_admin_password_dc1=$CF_ADMIN_PASSWORD_DC1 \
    -v cf_skip_ssl_validation_dc1=$CF_SKIP_SSL_VALIDATION_DC1 \
    -v cf_api_url_dc2=$CF_API_URL_DC2 \
    -v cf_admin_password_dc2=$CF_ADMIN_PASSWORD_DC2 \
    -v cf_skip_ssl_validation_dc2=$CF_SKIP_SSL_VALIDATION_DC2 \
    -v wavefront_url=$WAVEFRONT_URL \
    -v wavefront_token=$WAVEFRONT_TOKEN \
    -v friendly_hostname=$FRIENDLY_HOSTNAME \
    -v mysql_ips_dc1=$MYSQL_IPS_DC1 \
    -v mysql_ips_dc2=$MYSQL_IPS_DC2 \
    -v combined_mysql_instances="$combined_instances" \
    -v proxy_ip_dc1=$PROXY_IP_DC1 \
    -v proxy_ip_dc2=$PROXY_IP_DC2 \
    -v broker_ip_dc1=$BROKER_IP_DC1 \
    -v broker_ip_dc2=$BROKER_IP_DC2 \
    -v backup_ip_dc1=$BACKUP_IP_DC1  

vault write /concourse/$CONCOURSE_TEAM/mysql_creds value=@creds.yml 
	
