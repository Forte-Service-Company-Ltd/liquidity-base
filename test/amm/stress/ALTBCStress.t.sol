/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {PoolCommonUnitTest} from "test/amm/common/PoolCommon.t.u.sol";
import {ALTBCDef} from "src/common/TBC.sol";
import {ALTBCPool} from "src/amm/altbc/ALTBCPool.sol";
import {TBCType} from "src/common/TBC.sol";
import {MathLibs} from "src/amm/mathLibs/MathLibs.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract ALTBCPoolStressTest is PoolCommonUnitTest {
    uint8 constant MAX_TOLERANCE_X = 2;
    uint8 constant TOLERANCE_PRECISION_X = 17;
    uint256 constant TOLERANCE_DEN_X = 10 ** TOLERANCE_PRECISION_X;

    uint8 constant MAX_TOLERANCE_B = 5;
    uint8 constant TOLERANCE_PRECISION_B = 17;
    uint256 constant TOLERANCE_DEN_B = 10 ** TOLERANCE_PRECISION_B;

    uint8 constant TOLERANCE_PRECISION_B_WMATIC = 12;
    uint256 constant TOLERANCE_DEN_B_WMATIC = 10 ** TOLERANCE_PRECISION_B_WMATIC;

    uint8 constant MAX_TOLERANCE_C = 5;
    uint8 constant TOLERANCE_PRECISION_C = 16;
    uint256 constant TOLERANCE_DEN_C = 10 ** TOLERANCE_PRECISION_C;

    uint8 constant TOLERANCE_PRECISION_C_WMATIC = 13;
    uint256 constant TOLERANCE_DEN_C_WMATIC = 10 ** TOLERANCE_PRECISION_C_WMATIC;

    uint8 constant MAX_TOLERANCE_ABS_X = 2;
    uint8 constant TOLERANCE_PRECISION_ABS_X = 17;
    uint256 constant TOLERANCE_DEN_ABS_X = 10 ** TOLERANCE_PRECISION_ABS_X;

    string constant PATH = "./test/amm/simTrades/simTrades";
    
    uint previousSolX;
    uint previousPyX;
    uint previousSolBn;
    uint previousPyBn;
    uint previousSolCn;
    uint previousPyCn;

    function testLiquidity_ALTBCPoolUnit_simGeneratedSwaps() public startAsAdmin endWithStopPrank {
        uint count = 910;

        string memory fileEnd = withStableCoin ? "StableCoin-v1.1.txt" : "WETH-v1.1.txt";
        for (uint i = 0; i < count; i++) {
            string memory swap = vm.readLine(string.concat(PATH, fileEnd));
            uint swapAmount = vm.parseJsonUint(swap, ".swap_amount");
            uint x = vm.parseJsonUint(swap, ".x");
            uint buy = vm.parseJsonUint(swap, ".buy");
            uint bn = vm.parseJsonUint(swap, ".bn");
            uint cn = vm.parseJsonUint(swap, ".cn");

            if (buy == 1) {
                (uint expected, , ) = pool.simSwap(address(_yToken), swapAmount);
                pool.swap(address(_yToken), swapAmount, expected);
            } else {
                (uint256 expected, , ) = pool.simSwap(address(xToken), swapAmount);
                pool.swap(address(xToken), swapAmount, expected);
            }
            {
                // absolute x
                uint xPool = pool.x();
                assertTrue(areWithinTolerance(x, xPool, MAX_TOLERANCE_ABS_X, TOLERANCE_DEN_ABS_X), "x out of tolerance");

                // delta x
                uint deltaSolX = absoluteDiff(xPool, previousSolX);
                uint deltaPyX = absoluteDiff(x, previousPyX);
                assertTrue(areWithinTolerance(deltaSolX, deltaPyX, MAX_TOLERANCE_X, TOLERANCE_DEN_X), "delta x out of tolerance");
                previousSolX = xPool;
                previousPyX = x;
            }
            {
                (, , , , uint b, , , , ) = ALTBCPool(address(pool)).tbc();

                uint deltaSolBn = absoluteDiff(b, previousSolBn);
                uint deltaPyBn = absoluteDiff(bn, previousPyBn);
                if (wMatic)
                    assertTrue(
                        areWithinTolerance(deltaSolBn, deltaPyBn, MAX_TOLERANCE_B, TOLERANCE_DEN_B_WMATIC),
                        "delta bn out of tolerance - matic"
                    );
                else assertTrue(areWithinTolerance(deltaSolBn, deltaPyBn, MAX_TOLERANCE_B, TOLERANCE_DEN_B), "delta bn out of tolerance");

                previousSolBn = b;
                previousPyBn = bn;
            }
            {
                (, , , , , uint c, , , ) = ALTBCPool(address(pool)).tbc();

                uint deltaSolCn = absoluteDiff(c, previousSolCn);
                uint deltaPyCn = absoluteDiff(cn, previousPyCn);

                if (wMatic)
                    assertTrue(
                        areWithinTolerance(deltaSolCn, deltaPyCn, MAX_TOLERANCE_C, TOLERANCE_DEN_C_WMATIC),
                        "cn out of tolerance - matic"
                    );
                else assertTrue(areWithinTolerance(deltaSolCn, deltaPyCn, MAX_TOLERANCE_C, TOLERANCE_DEN_C), "cn out of tolerance");

                previousSolCn = c;
                previousPyCn = cn;
            }
        }
    }
}

contract ALTBCStressTestStableCoin is ALTBCPoolStressTest {
    function setUp() public endWithStopPrank {
        _setUp(true);
    }
}

contract ALTBCStressTestWETH is ALTBCPoolStressTest {
    function setUp() public endWithStopPrank {
        _setUp(false);
    }
}

