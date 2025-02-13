/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TestCommonSetup} from "test/util/TestCommonSetup.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
abstract contract PoolPrecisionUnitTest is TestCommonSetup {
    uint8 constant MAX_TOLERANCE_X = 12;
    uint8 constant TOLERANCE_PRECISION_X = 12;
    uint256 constant TOLERANCE_DEN_X = 10 ** TOLERANCE_PRECISION_X;

    uint MAX_SUPPLY = 10e4 * ERC20_DECIMALS;
    PoolBase wadPool;
    PoolBase sdPool;
    IERC20 wadYToken;
    IERC20 sdYToken;
    IERC20 wadXToken;
    IERC20 sdXToken;

    function _assignTokens() internal {
        wadXToken = IERC20(wadPool.xToken());
        sdXToken = IERC20(sdPool.xToken());
        wadYToken = IERC20(wadPool.yToken());
        sdYToken = IERC20(sdPool.yToken());
    }

    function _normalizeTokenDecimals(uint rawAmount) internal pure returns (uint normalizedAmount) {
        normalizedAmount = rawAmount / (10 ** 12);
    }

    function _swapX(
        bool isBuy,
        PoolBase _pool,
        uint swapAmount
    ) internal returns (uint256 amountOut, uint256 feeAmount, uint256 expected, uint256 expectedReverse) {
        IERC20 _yToken = IERC20(_pool.yToken());
        IERC20 _xToken = IERC20(_pool.xToken());

        IERC20 tokenIn = isBuy ? _yToken : _xToken;
        IERC20 tokenOut = isBuy ? _xToken : _yToken;

        (expected, , ) = _pool.simSwap(address(tokenIn), swapAmount);
        try _pool.simSwapReversed(address(tokenOut), expected) returns (uint expectedAmount, uint, uint) {
            expectedReverse = expectedAmount;
        } catch {
            console2.log("buy x failed");
        }

        (amountOut, feeAmount, ) = _pool.swap(address(tokenIn), swapAmount, expected);
    }

    function testLiquidity_PoolUnit_PrecisionComparison() public endWithStopPrank {
        console2.log("Before _precisionSetUp");
        (wadPool, sdPool) = _setupPrecisionPools(MAX_SUPPLY, 0);
        console2.log("Before _precisionSetUp");
        _assignTokens();
        console2.log("After assign tokens");
        _runSwaps();
        console2.log("After run swaps");
    }

    function testLiquidity_PoolUnit_PrecisionComparisonWithFee() public endWithStopPrank {
        (wadPool, sdPool) = _setupPrecisionPools(MAX_SUPPLY, 30);
        _assignTokens();
        _runSwaps();
    }

    function _runSwaps() internal startAsAdmin endWithStopPrank {
        uint buyAmountSixDecimal = 1_000_000;
        uint buyAmountWad = 1_000_000_000_000_000_000;

        uint SWAPS = 1000;

        for (uint i = 0; i < SWAPS; i++) {
            console2.log("buy: ", i);
            (uint256 amountOutWad, , uint256 expectedWad, uint256 expectedReverseWad) = _swapX(true, wadPool, buyAmountWad);
            (uint256 amountOutSd, , uint256 expectedSd, uint256 expectedReverseSd) = _swapX(true, sdPool, buyAmountSixDecimal);

            assertTrue(buyAmountWad >= expectedReverseWad);
            assertTrue(buyAmountSixDecimal >= expectedReverseSd);

            console2.log("wad: ", amountOutWad, expectedWad, expectedReverseWad);
            console2.log(" sd: ", amountOutSd, expectedSd, expectedReverseSd);

            uint yBalanceWad = wadYToken.balanceOf(address(wadPool));
            uint xBalanceWad = wadXToken.balanceOf(address(wadPool));

            uint yBalanceSd = sdYToken.balanceOf(address(sdPool));
            uint xBalanceSd = sdXToken.balanceOf(address(sdPool));

            console2.log("wad y: ", yBalanceWad, " wad x: ", xBalanceWad);
            console2.log(" sd y:  ", yBalanceSd * 10 ** 12, " sd x: ", xBalanceSd);
            assertTrue(areWithinTolerance(xBalanceWad, xBalanceSd, 9, 10 ** 9), "x balances should be within tolerance after buy");
            assertTrue(areWithinTolerance(yBalanceSd * 10 ** 12, yBalanceWad, MAX_TOLERANCE_X, TOLERANCE_DEN_X), "x out of tolerance");
        }

        uint xBalanceAdminWad = wadXToken.balanceOf(address(admin));
        uint xBalanceAdminSd = sdXToken.balanceOf(address(admin));
        uint sellAmountSixDecimal = xBalanceAdminSd / SWAPS;
        uint sellAmountWad = xBalanceAdminWad / SWAPS;

        for (uint i = 0; i < SWAPS; i++) {
            console2.log("sell: ", i);
            (uint256 amountOutWad, , uint256 expectedWad, uint256 expectedReverseWad) = _swapX(false, wadPool, sellAmountWad);
            (uint256 amountOutSd, , uint256 expectedSd, uint256 expectedReverseSd) = _swapX(false, sdPool, sellAmountSixDecimal);
            assertTrue(amountOutSd <= amountOutWad, "amount out in six decimal should not exceed amount out in wad");
            console2.log("wad: ", amountOutWad, expectedWad, expectedReverseWad);
            console2.log(" sd: ", amountOutSd, expectedSd, expectedReverseSd);

            uint yBalanceWad = wadYToken.balanceOf(address(wadPool));
            uint xBalanceWad = wadXToken.balanceOf(address(wadPool));

            uint yBalanceSd = sdYToken.balanceOf(address(sdPool));
            uint xBalanceSd = sdXToken.balanceOf(address(sdPool));

            console2.log("wad y: ", yBalanceWad, " wad x: ", xBalanceWad);
            console2.log(" sd y: ", yBalanceSd, " sd x: ", xBalanceSd);
            assertTrue(areWithinTolerance(xBalanceWad, xBalanceSd, 9, 10 ** 9), "x pool balances should be within tolerance");
            assertTrue(yBalanceWad <= (yBalanceSd * 10 ** 12), "y balance in six decimal should not exceed amount out in wad");
        }
    }
}
