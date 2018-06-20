#!/bin/bash -e

set -o pipefail

bosh -n -d mysql deploy concourse-mysql-deployment/ci/manifests/mysql.yml
