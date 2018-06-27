#!/bin/bash -e

bosh -n -d mysql start backup/0
bosh -n -d mysql stop backup/0

