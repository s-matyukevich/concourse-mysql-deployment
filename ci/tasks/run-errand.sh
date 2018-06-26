#!/bin/bash -e

set -o pipefail

bosh -n -d mysql run-errand $BOSH_ERRAND

