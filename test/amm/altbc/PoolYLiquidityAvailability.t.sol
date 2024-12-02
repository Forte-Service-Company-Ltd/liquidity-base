/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {ALTBCPool} from "src/amm/altbc/ALTBCPool.sol";
import {ALTBCCalculator} from "src/amm/altbc/ALTBCCalculator.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TestCommonSetup} from "test/util/TestCommonSetup.sol";
import {TBCType} from "src/common/TBC.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55
 */
contract PoolYLiquidityAvailabilityTest is TestCommonSetup {
    uint MAX_SUPPLY = 10e4 * ERC20_DECIMALS;
    PoolBase wadPool;
    PoolBase sdPool;

    IERC20 wadYToken;
    IERC20 sdYToken;
    IERC20 wadXToken;
    IERC20 sdXToken;

    function setUp() public endWithStopPrank {
        (wadPool, sdPool) = _setupPrecisionPools(MAX_SUPPLY, 0, TBCType.ALTBC);
        console2.log(" got pools ", address(wadPool));
        wadXToken = IERC20(wadPool.xToken());
        sdXToken = IERC20(sdPool.xToken());
        wadYToken = IERC20(wadPool.yToken());
        sdYToken = IERC20(sdPool.yToken());
    }

    function _normalizeTokenDecimals(uint rawAmount) internal pure returns (uint normalizedAmount) {
        normalizedAmount = rawAmount / (10 ** 12);
    }

    function _buyXWithExpected(
        PoolBase _pool,
        uint expected
    ) internal returns (uint256 amountOut, uint256 feeAmount, uint256 expectedSim, uint256 swapAmount) {
        IERC20 _yToken = IERC20(_pool.yToken());
        IERC20 _xToken = IERC20(_pool.xToken());

        try _pool.simSwapReversed(address(_xToken), expected) returns (uint expectedAmount, uint, uint) {
            swapAmount = expectedAmount;
        } catch {
            console2.log("buy x failed");
            console2.log("x", ALTBCPool(address(_pool)).x());
            (uint maxXTokenSupply,,,,,,,,) = ALTBCCalculator(address(wadPool)).tbc();
            console2.log("xMaxSupply", maxXTokenSupply);
        }

        (expectedSim, , ) = _pool.simSwap(address(_yToken), swapAmount);

        expected < expectedSim ? 
        (amountOut, feeAmount, ) = _pool.swap(address(_yToken), swapAmount, expected):
        (amountOut, feeAmount, ) = _pool.swap(address(_yToken), swapAmount, expectedSim);
    }

    function _sellXWithSwapAmount(
        PoolBase _pool,
        uint swapAmount
    ) internal returns (uint256 amountOut, uint256 feeAmount, uint256 expected, uint256 expectedReverse) {
        IERC20 _yToken = IERC20(_pool.yToken());
        IERC20 _xToken = IERC20(_pool.xToken());
        (expected, , ) = _pool.simSwap(address(_xToken), swapAmount);

        try _pool.simSwapReversed(address(_yToken), expected) returns (uint expectedAmount, uint, uint) {
            expectedReverse = expectedAmount;
        } catch {
            console2.log("sell x failed");
        }

        (amountOut, feeAmount, ) = _pool.swap(address(_xToken), swapAmount, expected);
    }

    function testLiquidity_YLiquidityAvailability_main(uint16 swaps, uint8 _amount) public startAsAdmin endWithStopPrank {
        uint expectedAmountOfX = bound(_amount, 50, 250) * ERC20_DECIMALS;

        (uint maxXTokenSupply,,,,,,,,) = ALTBCCalculator(address(wadPool)).tbc();
        uint SWAPS = bound(swaps, 10, maxXTokenSupply / expectedAmountOfX);

        // Swap out the extra token greater than maxXTokenSupply
        wadXToken.transfer(alice, 1);
        sdXToken.transfer(alice, 1);

        for (uint i = 0; i < SWAPS; i++) {
            (uint256 amountOutWad, , uint256 expectedSimWad, uint256 swapAmountWad) = _buyXWithExpected(wadPool, expectedAmountOfX);
            (uint256 amountOutSd, , uint256 expectedSimSd, uint256 swapAmountSd) = _buyXWithExpected(sdPool, expectedAmountOfX);
            amountOutWad; // silence warnings
            amountOutSd; // silence warnings
            expectedSimWad; // silence warnings
            expectedSimSd; // silence warnings
            swapAmountWad; // silence warnings
            swapAmountSd; // silence warnings
        }


        uint xBalanceAdminWad = wadXToken.balanceOf(address(admin));
        uint xBalanceAdminSd = sdXToken.balanceOf(address(admin));

        _sellXWithSwapAmount(wadPool, xBalanceAdminWad);

        _sellXWithSwapAmount(sdPool, xBalanceAdminSd);
    }
}
