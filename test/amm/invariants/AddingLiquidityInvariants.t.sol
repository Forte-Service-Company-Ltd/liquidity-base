/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {TestCommonSetup} from "test/util/TestCommonSetup.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Test all invariants in relation to adding liquidity to the pool.
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract AddingLiquidityInvariants is TestCommonSetup {
    uint xTokenLiquidity;
    uint yTokenLiquidity;

    function setUp() public endWithStopPrank {
        pool = _setupPool(false);
        uint amountToTrade = 50_000 * ERC20_DECIMALS;

        vm.startPrank(admin);
        (uint _expected, , ) = pool.simSwap(pool.yToken(), amountToTrade);
        pool.swap(pool.yToken(), amountToTrade, _expected);
        xTokenLiquidity = IERC20(pool.xToken()).balanceOf(address(pool));
        yTokenLiquidity = pool.yTokenLiquidity();
        vm.startPrank(admin);
        bytes4[] memory selectors = new bytes4[](1);
        // selectors[0] = PoolBase(address(pool)).depositLiquidity.selector; // TODO enable this with depositLiquidity
        targetContract(address(pool));
        targetSelector(FuzzSelector({addr: address(pool), selectors: selectors}));
        targetSender(admin);
    }

    function invariant_liquidityCanNeverDecreaseCallingAddLiquidity_TokenX() public startAsAdmin {
        assertGe(IERC20(pool.xToken()).balanceOf(address(pool)), xTokenLiquidity);
    }

    function invariant_liquidityCanNeverDecreaseCallingAddLiquidity_TokenY() public view {
        assertGe(pool.yTokenLiquidity(), yTokenLiquidity);
    }

    function invariant_liquidityCanNeverIncreasePastMaxSupply() public {
        uint maxTokenSupply = _getMaxXTokenSupply();
        assertLe(IERC20(pool.xToken()).balanceOf(address(pool)), maxTokenSupply);
    }
}
