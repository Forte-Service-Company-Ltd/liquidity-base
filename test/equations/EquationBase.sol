/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {TestCommon} from "test/util/TestCommon.sol";
import {MathLibs} from "src/amm/mathLibs/MathLibs.sol";


contract EquationBase is TestCommon {
    uint256 constant MAX_SUPPLY = 1e11 * ERC20_DECIMALS;
    using MathLibs for uint256;

    function checkForNegativeValue(URQTBCDef memory urqtbc, uint256 Xn) internal pure returns (bool) {
        (uint256 cnSqLow, uint256 cnSqHigh) = urqtbc.c.mul256x256(MathLibs.WAD ** 3); // WAD ** 4
        uint256 cnSqrt = cnSqLow.sqrt512(cnSqHigh); // WAD ** 2
        (cnSqLow, cnSqHigh) = urqtbc.l.mul256x256(MathLibs.WAD ** 3); // WAD ** 4
        uint256 secondTerm = cnSqLow.div512x256(cnSqHigh, cnSqrt); // WAD ** 2
        if (secondTerm <= (Xn * MathLibs.WAD)) return true;
        return false;
    }
}
