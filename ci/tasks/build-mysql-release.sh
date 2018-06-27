#!/bin/bash -e

set -o pipefail

git clone $CF_MYSQL_RELEASE_URL
cd cf-mysql-release 
git checkout $CF_MYSQL_RELEASE_TAG

echo "------Building cf mysql release ------"
git submodule init
git submodule update
#Update cf broker in the standard release
cd src/cf-mysql-broker/
git remote add fork $CF_MYSQL_BROKER_URL
git fetch fork
git checkout fork/master
cd ../..
bosh create-release --name cf-mysql-custom --timestamp-version --force --tarball cf-mysql-release.tgz
bosh -n upload-release cf-mysql-release/cf-mysql-release.tgz

