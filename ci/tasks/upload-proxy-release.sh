#!/bin/bash -e

set -o pipefail

bosh -n upload-release $WAVEFRONT_PROXY_RELEASE_URL
