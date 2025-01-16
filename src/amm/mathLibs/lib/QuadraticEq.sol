// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Uint512} from "uint1024/Uint512.sol";
import {Uint512Extended} from "uint1024/Uint512Extended.sol";
import {Uint1024} from "uint1024/Uint1024.sol";


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

    /**
     * @dev Gets the square root term to solve the quadratic equation
     * @param a The coefficient of x^2 expected with 36 decimals of precision
     * @param b The coefficient of x^1 expected with 36 decimals of precision
     * @param c The coefficient of x^0 expected with 36 decimals of precision
     * @return The solution of the equation as a uint512 with the positive result of the square-root term with 36 decimals of
     * precision. The actual precision of the result is perfect up until the 2 least significant digits.
     */
    function getSquareTerm(uint a, uint b, uint c) internal pure returns (uint, uint) {
        (uint bSq0, uint bSq1) = Uint512.mul256x256(b, b); // WAD ** 4
        (uint fourAC0, uint fourAC1) = Uint512.mul256x256((a << 1), (c << 1)); // WAD ** 4

        (uint sqrtTerm0, uint sqrtTerm1)  = Uint512Extended.safeAdd512x512(bSq0, bSq1, fourAC0, fourAC1); // WAD ** 4
        (uint wad20, uint wad21) = Uint512.mul256x256(WAD, WAD);
        uint sqrtTerm2;
        uint sqrtTerm3;
        (sqrtTerm0, sqrtTerm1, sqrtTerm2, sqrtTerm3)  = Uint1024.mul512x512In1024(sqrtTerm0, sqrtTerm1, wad20, wad21); // WAD ** 6
        return Uint1024.sqrt1024(sqrtTerm0, sqrtTerm1, sqrtTerm2, sqrtTerm3); // WAD ** 3

    }

    /**
     * @dev Gets the numerator to solve the quadratic equation
     * @param b The coefficient of x^1 expected with 36 decimals of precision
     * @param sqrtTerm0 The lower bits of the square root term
     * @param sqrtTerm1 The upper bits of the square root term
     * @param isBNegative Sign indicator of param b, true if negative
     * @return The solution of the equation as a uint512 with the positive result of the square-root term with 72 decimals of
     * precision. The actual precision of the result is perfect up until the 2 least significant digits.
     */
    function getNumerator(uint b, uint sqrtTerm0, uint sqrtTerm1, bool isBNegative) internal pure returns (uint, uint) {
        uint numerator0;
        uint numerator1;
        
        (uint b0, uint b1) = Uint512.mul256x256(b, WAD); // WAD ** 3

        if (isBNegative) {
            (numerator0, numerator1) = Uint512Extended.safeAdd512x512(sqrtTerm0, sqrtTerm1, b0, b1);
        } else {
            if(Uint512Extended.lt512(sqrtTerm0, sqrtTerm1, b0, b1)) revert("QuadraticEquation: negative result");
            (numerator0,  numerator1) = Uint512Extended.safeSub512x512(sqrtTerm0, sqrtTerm1, b0, b1);
        }
        return Uint512.mul512x256(numerator0,  numerator1, WAD); // WAD ** 4
    }

    /**
     * @dev Solves a quadratic equation of the form ax^2 + bx + c = 0
     * @notice all parameters are bounded to a minimum
     * value of 1e18 which can be interpreted as a value of 1e(-18) or 0.000000000000000001.
     * @param a The coefficient of x^2 expected with 36 decimals of precision
     * @param b The coefficient of x^1 expected with 36 decimals of precision
     * @param c The coefficient of x^0 expected with 36 decimals of precision
     * @param isBNegative Sign indicator of param b, true if negative
     * @return The solution of the equation whith the positive result of the square-root term with 36 decimals of
     * precision. The actual precision of the result is perfect up until the 2 least significant digits.
     */
    function solveQuadraticEquationLargeInput(uint a, uint b, uint c, bool isBNegative) internal pure returns (uint256) {
        if(a == 0) revert("a too small");
        if(a > 10000000000000000000001999999999999999998000000000000000000000000000000000000) revert("a too large");
        if(b > 10000000000000000000001999999799999999997999999999980000000000000000000000000) revert("b too large");
        if(c > 10000000000000000000002000000199999999999999999999979999999000000000000000000) revert("c too large");

        (uint sqrtTerm0, uint sqrtTerm1) = getSquareTerm(a, b, c);
        (uint numerator0, uint numerator1) = getNumerator(b, sqrtTerm0, sqrtTerm1, isBNegative);
        return  Uint512Extended.safeDiv512x256(numerator0, numerator1, a << 1);
    }
}
