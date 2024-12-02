/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {TestCommonSetup} from "test/util/TestCommonSetup.sol";
import {TBCType} from "src/common/TBC.sol";
/**
 * @title Test all invariants in relation to removing liquidity from the pool.
 * @dev invariant test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract RemovingLiquidityInvariants is TestCommonSetup {
    uint constant Y_TOKEN_LIQUIDITY = 1e5 * 1e18;
    uint xTokenLiquidity;
    function _setUp(TBCType _tbcType) internal endWithStopPrank {
        pool = _setupPool(false, _tbcType);
        xTokenLiquidity = IERC20(pool.xToken()).totalSupply();
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = pool.closePool.selector;
        selectors[1] = pool.collectLPFees.selector;
        targetContract(address(pool));
        targetSelector(FuzzSelector({addr: address(pool), selectors: selectors}));
        targetSender(admin);
    }

    function invariant_liquidityCanNeverIncreaseCallingRemoveLiquidity_TokenX() public view {
        assertLe(pool.xTokenLiquidity(), xTokenLiquidity);
    }

    function invariant_liquidityCanNeverIncreaseCallingRemoveLiquidity_TokenY() public view {
        assertLe(pool.yTokenLiquidity(), Y_TOKEN_LIQUIDITY);
    }
}

contract RemovingLiquidityInvariants_ALTBC is RemovingLiquidityInvariants {
    function setUp() public {
        _setUp(TBCType.ALTBC);
    }
}

contract RemovingLiquidityInvariants_URQTBC is RemovingLiquidityInvariants {
    function setUp() public {
        _setUp(TBCType.URQTBC);
    }
}