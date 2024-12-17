#!/bin/bash

#####################################################################
## Usage:                                                          ##
##  ./script/interactions/swap.sh                                  ##
##   <NETWORK> <POOL_ADDRESS> <Y_TOKEN_ADDRESS>                    ## 
##   <AMOUNT_TO_SELL>                                              ##
#####################################################################

. $PWD/script/interactions/common/getEnvironmentVars

url=$(getNetworkURL $1)
key=$(getNetworkKey $1)
legacyArg=$(getLegacyArg $1)

simSwap="simSwap(address,uint256)(uint256,uint256,uint256)"
swap="swap(address,uint256,uint256)(uint256,uint256,uint256)"

read expected expScientific expFee < <(cast call $legacyArg --rpc-url $url $2 $simSwap $3 $4)
echo $expected
cast send $legacyArg --rpc-url $url --private-key $key $2 $swap $3 $4 $expected
