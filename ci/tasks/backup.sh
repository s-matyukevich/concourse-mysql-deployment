#!/bin/bash -e

bosh -n start backup/0
bosh -n stop backup/0

