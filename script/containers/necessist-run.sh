#!/bin/bash
set -e

python3 -m venv .venv
source .venv/bin/activate
necessist --verbose --framework foundry -- --ffi

date=$(date +"%Y-%m-%d")
aws s3 cp necessist.db s3://necessist-database/aquifi-liquidity-necessist-${date}.db
