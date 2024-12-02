#!/bin/bash
# This script should only be run after the environment variables are set
# correctly according to docs/userGuides/deployment/DEPLOY-PROTOCOL.md

echo "################################################################"
echo Deploying the ecosystem
echo "################################################################"

if [[ $2 == "local" ]]; then
    url=$LOCAL_RPC_URL
    key=$LOCAL_DEPLOYER_KEY
    legacyArg=""
elif [[ $2 == "amoy" ]]; then
    url=$AMOY_RPC_URL
    key=$AMOY_DEPLOYER_KEY
    legacyArg=""
elif [[ $2 == "sepolia" ]]; then
    url=$SEPOLIA_RPC_URL
    key=$SEPOLIA_DEPLOYER_KEY
    legacyArg="--legacy"
else
    echo "Error - Deployment chain required" 1>&2
    exit 64
fi

forge script $legacyArg --rpc-url $url --ffi --private-key $key --broadcast --force -vvv --non-interactive script/deploy/deploy.s.sol:$1