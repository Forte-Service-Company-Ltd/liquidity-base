/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {PoolCommonUnitTest} from "test/amm/common/PoolCommon.t.u.sol";
import {URQTBCDef} from "src/common/TBC.sol";
import {URQTBCPool} from "src/amm/urqtbc/URQTBCPool.sol";
import {TBCType} from "src/common/TBC.sol";
import {MathLibs} from "src/amm/mathLibs/MathLibs.sol";

/**
 * @title Test Pool functionality
 * @dev unit test
 * @author @oscarsernarosero @mpetersoCode55 @cirsteve
 */
abstract contract URQTBCPoolStressTest is PoolCommonUnitTest {
    uint8 constant MAX_TOLERANCE_X = 1;
    uint8 constant TOLERANCE_PRECISION_X = 18;
    uint256 constant TOLERANCE_DEN_X = 10 ** TOLERANCE_PRECISION_X;

    uint8 constant MAX_TOLERANCE_L = 1;
    uint8 constant TOLERANCE_PRECISION_L = 16;
    uint256 constant TOLERANCE_DEN_L = 10 ** TOLERANCE_PRECISION_L;

    uint8 constant MAX_TOLERANCE_C = 1;
    uint8 constant TOLERANCE_PRECISION_C = 16;
    uint256 constant TOLERANCE_DEN_C = 10 ** TOLERANCE_PRECISION_C;

    uint8 constant MAX_TOLERANCE_ABS_X = 1;
    uint8 constant TOLERANCE_PRECISION_ABS_X = 18;
    uint256 constant TOLERANCE_DEN_ABS_X = 10 ** TOLERANCE_PRECISION_ABS_X;

    string constant PATH = "./test/amm/simTrades/simTrades";

    uint previousSolX;
    uint previousPyX;
    uint previousSolLn;
    uint previousPyLn;
    uint previousSolCn;
    uint previousPyCn;

    function testLiquidity_URQTBCPoolUnit_simGeneratedSwaps() public startAsAdmin endWithStopPrank {
        uint count = 1000;

        string memory fileEnd = withStableCoin ? "StableCoin-urqtbc.txt" : "WETH-urqtbc.txt";
        
        (,, uint c ,, uint l, ) = URQTBCPool(address(pool)).tbc();
        uint xPool;
        for (uint i = 0; i < count; i++) {
            string memory swap = vm.readLine(string.concat(PATH, fileEnd));
            uint swapAmount = vm.parseJsonUint(swap, ".b_swap_amount");
            uint x = vm.parseJsonUint(swap, ".c_x");
            uint buy = vm.parseJsonUint(swap, ".a_buy");
            uint ln = vm.parseJsonUint(swap, ".i_l");
            uint cn = vm.parseJsonUint(swap, ".g_c");
            ln = ln / 1e18; // ln has 1 WAD excess precision
            x = x / 1e18; // x has 1 WAD excess precision
            
            if (buy == 1) {
                (uint expected, , ) = pool.simSwap(address(_yToken), swapAmount);
                pool.swap(address(_yToken), swapAmount, expected);
            } else {
                swapAmount = swapAmount / 1e18; // if selling x swapAmount has 1 WAD excess precision
                (uint256 expected, , ) = pool.simSwap(address(xToken), swapAmount);
                pool.swap(address(xToken), swapAmount, expected);
            }

            xPool = pool.x();
            (, ,  c ,,  l,   ) = URQTBCPool(address(pool)).tbc();
            {
                // absolute x
                xPool = pool.x();
                assertTrue(areWithinTolerance(x, xPool, MAX_TOLERANCE_ABS_X, TOLERANCE_DEN_ABS_X), "x out of tolerance");

                // delta x
                uint deltaSolX = absoluteDiff(xPool, previousSolX);
                uint deltaPyX = absoluteDiff(x, previousPyX);
                assertTrue(areWithinTolerance(deltaSolX, deltaPyX, MAX_TOLERANCE_X, TOLERANCE_DEN_X), "delta x out of tolerance");
                previousSolX = xPool;
                previousPyX = x;
            }
            {

                uint deltaSolLn = absoluteDiff(l, previousSolLn);
                uint deltaPyLn = absoluteDiff(ln, previousPyLn);
                assertTrue(areWithinTolerance(deltaSolLn, deltaPyLn, MAX_TOLERANCE_L, TOLERANCE_DEN_L), "delta ln out of tolerance");

                previousSolLn = l;
                previousPyLn = ln;
            }
            {
                uint deltaSolCn = absoluteDiff(c, previousSolCn);
                uint deltaPyCn = absoluteDiff(cn, previousPyCn);

                assertTrue(areWithinTolerance(deltaSolCn, deltaPyCn, MAX_TOLERANCE_C, TOLERANCE_DEN_C), "cn out of tolerance");

                previousSolCn = c;
                previousPyCn = cn;
            }
        }
    }
}

contract URQTBCStressTestStableCoin is URQTBCPoolStressTest {
        function setUp() public endWithStopPrank {
        _setUp(true, TBCType.URQTBC);
    }
}

contract URQTBCStressTestWETH is URQTBCPoolStressTest {
        function setUp() public endWithStopPrank {
        _setUp(false, TBCType.URQTBC);
    }
}
