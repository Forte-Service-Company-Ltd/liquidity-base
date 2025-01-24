// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { TBCInputOption} from "test/util/TestConstants.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";

/**
 * @title Test Common Foundry Setup Pure Abstract Functions
 */
interface ITestSetupHelper  { 
    function deployFactory() external;
    function getFactoryAddress() external returns (address);
    function deployPool(address,address,uint16,bool,TBCInputOption) external returns (PoolBase);
    function getMaxXTokenSupply() external returns (uint);
}