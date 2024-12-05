/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonTest} from "test/amm/common/PoolCommon.t.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
contract PoolStableCoinTest is PoolCommonTest {
    function setUp() internal endWithStopPrank {
        pool = _setupPool(true);
        _setupCollateralToken();
    }
}