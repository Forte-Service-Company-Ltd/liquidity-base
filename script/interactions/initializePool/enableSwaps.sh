#!/bin/bash

#####################################################################
## Usage:                                                          ##
##  ./script/interactions/initializePool/enableSwaps.sh <NETWORK>  ##
##  <POOL_ADDRESS>                                                 ##
##  If swaps are already enabled on the specified pool,             ##
##  this script will error out with custom error 0x8dfc202b        ##
#####################################################################

. $PWD/script/interactions/common/getEnvironmentVars

url=$(getNetworkURL $1)
key=$(getNetworkKey $1)
legacyArg=$(getLegacyArg $1)
sig="enableSwaps(bool)"

cast send $legacyArg --rpc-url $url --private-key $key $2 $sig true