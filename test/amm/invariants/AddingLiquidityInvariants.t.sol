/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {TestCommonSetup} from "test/util/TestCommonSetup.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TBCType} from "src/common/TBC.sol";
import {ALTBCCalculator} from "src/amm/altbc/ALTBCCalculator.sol";
import {URQTBCCalculator} from "src/amm/urqtbc/URQTBCCalculator.sol";

/**
 * @title Test all invariants in relation to adding liquidity to the pool.
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract AddingLiquidityInvariants is TestCommonSetup {
    uint xTokenLiquidity;
    uint yTokenLiquidity;
    TBCType tbcType;

    function _setUp(TBCType _tbcType) internal endWithStopPrank {
        tbcType = _tbcType;
        pool = _setupPool(false, _tbcType);
        uint amountToTrade = 50_000 * ERC20_DECIMALS;

        vm.startPrank(admin);
        (uint _expected, , ) = pool.simSwap(pool.yToken(), amountToTrade);
        pool.swap(pool.yToken(), amountToTrade, _expected);
        xTokenLiquidity = pool.xTokenLiquidity();
        yTokenLiquidity = pool.yTokenLiquidity();
        vm.startPrank(admin);
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = PoolBase(address(pool)).addXSupply.selector;
        targetContract(address(pool));
        targetSelector(FuzzSelector({addr: address(pool), selectors: selectors}));
        targetSender(admin);
    }

    function invariant_liquidityCanNeverDecreaseCallingAddLiquidity_TokenX() public startAsAdmin {
        assertGe(pool.xTokenLiquidity(), xTokenLiquidity);
    }

    function invariant_liquidityCanNeverDecreaseCallingAddLiquidity_TokenY() public view {
        assertGe(pool.yTokenLiquidity(), yTokenLiquidity);
    }

    function invariant_liquidityCanNeverIncreasePastMaxSupply() public view {
        if (tbcType == TBCType.ALTBC) {
            (uint maxTokenSupply, , , , , , , , ) = ALTBCCalculator(address(pool)).tbc();
            assertLe(pool.xTokenLiquidity(), maxTokenSupply);
        } else {
            (, , , , , uint maxTokenSupply) = URQTBCCalculator(address(pool)).tbc();
            assertLe(pool.xTokenLiquidity(), maxTokenSupply);
        }
    }
}

contract AddingLiquidityInvariants_ALTBC is AddingLiquidityInvariants {
    function setUp() public {
        _setUp(TBCType.ALTBC);
    }
}

contract AddingLiquidityInvariants_URQTBC is AddingLiquidityInvariants {
    function setUp() public {
        _setUp(TBCType.URQTBC);
    }
}
