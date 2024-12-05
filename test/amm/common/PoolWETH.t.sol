/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonTest} from "test/amm/common/PoolCommon.t.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
abstract contract PoolWETHTest is PoolCommonTest {
    function _setUp() internal endWithStopPrank {
        pool = _setupPool(false);
        _setupCollateralToken();
    }

    function testLiquidity_Pool_LiquidityExcess(uint256 _initialAmount) public virtual override {
        super.testLiquidity_Pool_LiquidityExcess(_initialAmount);
    }
}