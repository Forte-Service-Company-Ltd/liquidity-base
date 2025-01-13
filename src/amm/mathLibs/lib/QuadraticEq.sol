// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Uint512} from "uint1024/Uint512.sol";
import {Uint512Extended} from "uint1024/Uint512Extended.sol";

library QuadraticEquation {
    uint256 constant WAD = 1e18;

    /**
     * @dev Solves a quadratic equation of the form ax^2 + bx + c = 0
     * @notice all parameters are bounded to a max value of type(uint192).max. This means that the max value of  
     * a, b and c is 6_277_101_735_386_680_763_835 without counting the decimals (36 decimals), and a minimum
     * value of 1e18 which can be interpreted as a value of 1e(-18) or 0.000000000000000001.
     * @param a The coefficient of x^2 expected with 36 decimals of precision
     * @param b The coefficient of x^1 expected with 36 decimals of precision
     * @param c The coefficient of x^0 expected with 36 decimals of precision
     * @param isBNegative Sign indicator of param b, true if negative
     * @return The solution of the equation whith the positive result of the square-root term with 36 decimals of
     * precision. The actual precision of the result is perfect up until the 2 least significant digits.
     */
    function solveQuadraticEquation(uint a, uint b, uint c, bool isBNegative) internal pure returns (uint256) {
        if(a >> 192 > 0) revert("a too large");
        if(b >> 192 > 0) revert("b too large");
        if(c >> 192 > 0) revert("c too large");
        if(a== 0) revert("a too small");
        uint sqrtTerm;
        uint numerator0;
        uint numerator1;
        {
            (uint bSq0, uint bSq1) = Uint512.mul256x256(b * WAD, b * WAD); // WAD ** 6
            (uint fourAC0, uint fourAC1) = Uint512.mul256x256((a << 1) * WAD, (c << 1) * WAD); // WAD ** 6

            (uint sqrtTerm0, uint sqrtTerm1)  = Uint512Extended.safeAdd512x512(bSq0, bSq1, fourAC0, fourAC1); // WAD ** 6
            sqrtTerm = Uint512.sqrt512(sqrtTerm0, sqrtTerm1); // WAD ** 3

        }
        if (isBNegative) {
            (numerator0, numerator1) = Uint512.mul256x256(b * WAD + sqrtTerm, WAD);
        } else {
            if(sqrtTerm < b * WAD) revert("QuadraticEquation: negative result");
            ( numerator0,  numerator1) = Uint512.mul256x256(sqrtTerm - b * WAD, WAD);
        }
        return  Uint512Extended.safeDiv512x256(numerator0, numerator1, a << 1);
    }
}