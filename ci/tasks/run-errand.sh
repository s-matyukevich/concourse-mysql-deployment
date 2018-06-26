#!/bin/bash -e

set -o pipefail

bosh -n run-errand $BOSH_ERRAND

