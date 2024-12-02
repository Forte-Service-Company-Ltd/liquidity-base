#!/bin/bash

#####################################################################
## Usage:                                                          ##
##  ./script/interactions/addDeployerAndCollateralToFactory.sh     ##
##   <NETWORK> <YTOKEN_ADDRESS_TO_BE_ALLOWED>                      ## 
##   <DEPLOYER_ADDRESS_TO_BE_ALLOWED>                              ##
#####################################################################

yTokenAllowList=$Y_TOKEN_ALLOWLIST
deployerAllowList=$DEPLOYER_ALLOWLIST

./script/interactions/addAllowedAddress.sh $1 $yTokenAllowList $2
./script/interactions/addAllowedAddress.sh $1 $deployerAllowList $3