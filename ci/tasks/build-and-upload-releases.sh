#!/bin/bash -e

set -o pipefail

git clone $CF_MYSQL_RELEASE_URL
cd cf-mysql-release 
git checkout $CF_MYSQL_RELEASE_TAG

cur_commit=$(git rev-parse  --short  HEAD)
bosh_commit=$(bosh --json releases | jq -r '[.Tables[0].Rows[] | select(.name=="cf-mysql-custom")][0].commit_hash')

git submodule init
git submodule update
#Update cf broker in the standard release
cd src/cf-mysql-broker/
git remote add fork $CF_MYSQL_BROKER_URL
git fetch fork
git checkout fork/master
cd ../..
bosh create-release --name cf-mysql-custom --timestamp-version --force --tarball cf-mysql-release.tgz
cd ..

# Build custom release
#git clone $VMWARE_MYSQL_RELEASE_URL
#cd vmware-cf-mysql
#bosh create-release --timestamp-version --force --tarball vmware-cf-mysql-release.tgz
#cd ..


bosh -d mysql -n upload-release cf-mysql-release/cf-mysql-release.tgz
#bosh -d mysql -n upload-release vmware-cf-mysql/cf-mysql-release.tgz
bosh -d mysql -n upload-stemcell vsphere-stemcell/stemcell.tgz

