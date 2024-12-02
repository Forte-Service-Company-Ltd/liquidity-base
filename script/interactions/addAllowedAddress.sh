#!/bin/bash

######################################################################
## Usage:                                                           ##
##  ./script/interactions/addAllowedAddress.sh <NETWORK>            ##
##    <ALLOW_LIST_ADDRESS> <ADDRESS_TO_ALLOW>                          ## 
######################################################################

. $PWD/script/interactions/common/getEnvironmentVars

url=$(getNetworkURL $1)
key=$(getNetworkKey $1)
legacyArg=$(getLegacyArg $1)
sig="addToAllowList(address)"

cast send $legacyArg --rpc-url $url --private-key $key $2 $sig $3