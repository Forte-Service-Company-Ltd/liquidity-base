/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {PoolCommonTest} from "test/amm/common/PoolCommon.t.sol";
import {TBCType} from "src/common/TBC.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
abstract contract PoolWETHTest is PoolCommonTest {
    function _setUpWETHTest(TBCType _tbcType) internal endWithStopPrank {
        pool = _setupPool(false, _tbcType);
        _setupCollateralToken();
        tbcType = _tbcType;
    }

    function testLiquidity_Pool_LiquidityExcess(uint256 _initialAmount) public virtual override {
        super.testLiquidity_Pool_LiquidityExcess(_initialAmount);
    }
}

/**
 * @title Test ALTC Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract ALTBCPoolWETHTest is PoolWETHTest {
    function setUp() public {
        _setUpWETHTest(TBCType.ALTBC);
    }
}


/**
 * @title Test URQTBC Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
contract URQTBCPoolWETHTest is PoolWETHTest {
    function setUp() public {
        _setUpWETHTest(TBCType.URQTBC);
    }

    function testLiquidity_Pool_LiquidityExcess(uint256 _initialAmount) public override {
        _initialAmount;
        vm.skip(true);
    }
}