/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonTest} from "test/amm/common/PoolCommon.t.sol";
import {TBCType} from "src/common/TBC.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
abstract contract PoolStableCoinTest is PoolCommonTest {
    function _setUpStableCoinTest(TBCType _tbcType) internal endWithStopPrank {
        pool = _setupPool(true, _tbcType);
        _setupCollateralToken();
        tbcType = _tbcType;
    }
}

/**
 * @title Test ALTC Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract ALTBCPoolStableCoinTest is PoolStableCoinTest {
    function setUp() public {
        _setUpStableCoinTest(TBCType.ALTBC);
    }
}

/**
 * @title Test URQTBC Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract URQTBCPoolStableCoinTest is PoolStableCoinTest {
    function setUp() public {
        _setUpStableCoinTest(TBCType.URQTBC);
    }

    function testLiquidity_Pool_LiquidityExcess(uint256 _initialAmount) public override {
        _initialAmount;
        vm.skip(true);
    }
}