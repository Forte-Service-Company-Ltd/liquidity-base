#!/bin/bash

#####################################################################
## Usage:                                                          ##
##  ./script/interactions/common/approvePool.sh <NETWORK>          ##
##   <TOKEN_ADDRESS> <POOL_ADDRESS> <ALLOWANCE_IN_WAD>             ## 
#####################################################################
. $PWD/script/interactions/common/getEnvironmentVars

url=$(getNetworkURL $1)
key=$(getNetworkKey $1)
legacyArg=$(getLegacyArg $1)
sig="approve(address,uint256)"

cast send $legacyArg --rpc-url $url --private-key $key $2 $sig $3 $4