#!/bin/bash -e

set -o pipefail

if ! bosh --json stemcells | jq -e --arg STEMCELL_VERSION $STEMCELL_VERSION '.Tables[0].Rows[] | select(.name=="bosh-vsphere-esxi-ubuntu-trusty-go_agent" and (.version | contains($STEMCELL_VERSION)))' > /dev/null; then
	bosh -d mysql -n upload-stemcell "${STEMCELL_URL}${STEMCELL_VERSION}"
fi
