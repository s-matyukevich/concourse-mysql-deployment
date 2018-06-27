#!/bin/bash -e

set -o pipefail

if ! bosh --json releases | jq -e '.Tables[0].Rows[] | select(.name=="wavefront-proxy")' > /dev/null; then
	bosh -n upload-release $WAVEFRONT_PROXY_RELEASE_URL
fi
