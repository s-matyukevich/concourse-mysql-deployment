#!/bin/bash -e

set -o pipefail

git clone $CF_MYSQL_RELEASE_URL
cd cf-mysql-release 
git checkout $CF_MYSQL_RELEASE_TAG

git_commit=$(git rev-parse  --short  HEAD)
bosh_commit=$(bosh --json releases | jq -r '[.Tables[0].Rows[] | select(.name=="cf-mysql-custom")][0].commit_hash' | sed s/+//g)

if [ "$git_commit" != "$bosh_commit" ]; then
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
fi
cd ..

if ! bosh --json releases | jq -e '.Tables[0].Rows[] | select(.name=="wavefront-proxy")' > /dev/null; then
	bosh -n upload-release $WAVEFRONT_PROXY_RELEASE_URL
fi

git clone $TELEGRAF_AGENT_RELEASE_URL
cd telegraf-agent-bosh-release
git_commit=$(git rev-parse  --short  HEAD)
bosh_commit=$(bosh --json releases | jq -r '[.Tables[0].Rows[] | select(.name=="telegraf-agent")][0].commit_hash' | sed s/+//g)

if [ "$git_commit" != "$bosh_commit" ]; then
	echo "------Building telegraf-agent release ------"
	bosh create-release --timestamp-version --force --tarball telegraf-agent-release.tgz
	bosh -n upload-release telegraf-agent-release.tgz
fi
cd ..


if ! bosh --json stemcells | jq -e --arg STEMCELL_VERSION $STEMCELL_VERSION '.Tables[0].Rows[] | select(.name=="bosh-vsphere-esxi-ubuntu-trusty-go_agent" and (.version | contains($STEMCELL_VERSION)))' > /dev/null; then
	bosh -d mysql -n upload-stemcell "${STEMCELL_URL}${STEMCELL_VERSION}"
fi

