// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TBCInputOption} from "test/util/TestConstants.sol";

/**
 * @title Test Common Foundry Setup Pure Abstract Functions
 */
abstract contract TestCommonSetupAbs { 
    function _deployFactory() internal virtual {}
    function _getFactoryAddress() internal virtual returns (address) {}
    function _deployPool(address,address,uint16,bool,TBCInputOption) internal virtual returns (PoolBase) {}
    function _getMaxXTokenSupply() internal virtual returns (uint) {}
}