#!/bin/bash

#####################################################################
## Usage:                                                          ##
##  ./script/interactions/initializePool/initializeSupply.sh       ##
##  <NETWORK> <POOL_ADDRESS> <MAX_X_TOKEN_SUPPLY>                  ##
#####################################################################

. $PWD/script/interactions/common/getEnvironmentVars

url=$(getNetworkURL $1)
key=$(getNetworkKey $1)
legacyArg=$(getLegacyArg $1)
sig="addXSupply(uint256)"

cast send $legacyArg --rpc-url $url --private-key $key $2 $sig $3