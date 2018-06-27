#!/bin/bash -e

set -o pipefail

git clone $TELEGRAF_AGENT_RELEASE_URL
cd telegraf-agent-bosh-release

echo "------Building telegraf-agent release ------"
bosh create-release --timestamp-version --force --tarball telegraf-agent-release.tgz
bosh -n upload-release telegraf-agent-release.tgz
