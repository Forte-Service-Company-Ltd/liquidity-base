/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonUnitTest} from "test/amm/common/PoolCommon.t.u.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
contract PoolWETHUnitTest is PoolCommonUnitTest {
    function setUp() public endWithStopPrank {
        _setUp(false);
    }
}
