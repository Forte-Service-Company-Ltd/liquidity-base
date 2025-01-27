// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "solady/utils/FixedPointMathLib.sol";
import "./lib/MathUtils.sol";
import {Uint512} from "uint1024/Uint512.sol";
import {Uint512Extended} from "uint1024/Uint512Extended.sol";
import {Uint1024} from "uint1024/Uint1024.sol";
import {uint512, uint768, uint1024} from "uint1024/UintTypes.sol";
import {LN} from "./lib/LN.sol";
import {QuadraticEquation} from "./lib/QuadraticEq.sol";

/**
 * @title Abstraction Layer between Equations and the underlying Math libraries
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve
 * @dev Wrapper functions to act as an abstraction layer between Equations and the Math library we're using.
 * @notice current implementation is using the FixedPointMathLib library from Solady and the Solidity_Uint512 library
 */
library MathLibs {
    using FixedPointMathLib for uint256;
    using FixedPointMathLib for int256;
    using MathUtils for uint256;
    using Uint512 for uint256;
    using Uint512Extended for uint256;
    using Uint1024 for uint256;
    using Uint1024 for uint512;
    using Uint1024 for uint768;
    using Uint1024 for uint1024;
    using LN for uint256;
    using QuadraticEquation for uint256;

    uint256 constant WAD = FixedPointMathLib.WAD;

    /**
     * @dev Provides an abstraction layer for division between aquifi-liquidity and the underlying math library
     * @notice expects the parameters to not have been multiplied by WAD, and the result will be a WAD number
     * @param numerator the numerator for the division
     * @param denominator the denominator for the division
     * @return result of the division operation
     */
    function divideToWAD(uint256 numerator, uint256 denominator) internal pure returns (uint256 result) {
        result = numerator.divWad(denominator);
    }

    /**
     * @dev Provides an abstraction layer for multiplication between aquifi-liquidity and the underlying math library
     * @notice expects the parameters to not have been multiplied by WAD, and the result will be a WAD number
     * @param x one of the factors for the multiplication
     * @param y the other factors for the multiplication
     * @return result of the multiplication operation
     */
    function uncheckedMultiply(uint256 x, uint256 y) internal pure returns (uint256 result) {
        result = x.uncheckedMultiply(y);
    }

    function powWad(int256 x, int256 y) internal pure returns (int256) {
        return x.powWad(y);
    }

    /**
     * @dev Converts a raw number to a WAD number
     * @param value The number to be converted
     * @return result resulting WAD number
     */
    function convertToWAD(uint256 value) internal pure returns (uint256 result) {
        result = value.convertToWAD();
    }

    /**
     * @dev Converts a WAD number to a raw number
     * @param value The number to be converted
     * @return result resulting raw number
     */
    function convertToRaw(uint256 value) internal pure returns (uint256 result) {
        result = value.convertToRaw();
    }

    /**
     * @notice Calculates the product of two uint256
     * @dev Used the chinese remainder theoreme
     * @param a A uint256 representing the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The result as an uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function mul256x256(uint256 a, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a.mul256x256(b);
    }

    /**
     * @notice Calculates the product of two uint512 and uint256
     * @dev Used the chinese remainder theoreme
     * @param a0 A uint256 representing lower bits of the first factor
     * @param a1 A uint256 representing higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The result as an uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function mul512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a0.safeMul512x256(a1, b);
    }

    /**
     * @notice Calculates the product of a uint512 and uint256. The result is a uint768.
     * @dev Used the chinese remainder theoreme
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function mul512x256In768(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        (r0, r1, r2) = a0.mul512x256In768(a1, b);
    }

    /**
     * @notice Calculates the product of two uint512. The result is a uint1024.
     * @dev Used the chinese remainder theoreme
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the higher bits of the first factor
     * @param b0 A uint256 representing the lower bits of the second factor
     * @param b1 A uint256 representing the higher bits of the second factor
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function mul512x512In1024(
        uint256 a0,
        uint256 a1,
        uint256 b0,
        uint256 b1
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        (r0, r1, r2, r3) = a0.mul512x512In1024(a1, b0, b1);
    }

    /**
     * @notice Calculates the product and remainder of two uint256
     * @dev Used the chinese remainder theoreme
     * @param a A uint256 representing the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The result as an uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     * @return r2 The remainder
     */
    function mulMod256x256(uint256 a, uint256 b, uint256 c) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        (r0, r1, r2) = a.mulMod256x256(b, c);
    }

    /**
     * @notice Calculates the difference of two uint512
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param b0 A uint256 representing the lower bits of the seccond addend
     * @param b1 A uint256 representing the higher bits of the seccond addend
     * @return r0 The result as an uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function add512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a0.safeAdd512x512(a1, b0, b1);
    }

    /**
     * @notice Calculates the sum of two uint768. The result is a uint768.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param a2 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the second addend
     * @param b1 A uint256 representing the higher bits of the second addend
     * @param b2 A uint256 representing the highest bits of the second addend
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function add768x768(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 b0,
        uint256 b1,
        uint256 b2
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        (r0, r1, r2) = a0.add768x768(a1, a2, b0, b1, b2);
    }

    /**
     * @notice Calculates the sum of two Uint1024. The result is a Uint1024.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the high bits of the first addend
     * @param a2 A uint256 representing the higher bits of the first addend
     * @param a3 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the second addend
     * @param b1 A uint256 representing the high bits of the second addend
     * @param b2 A uint256 representing the higher bits of the second addend
     * @param b3 A uint256 representing the highest bits of the second addend
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function add1024x1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        (r0, r1, r2, r3) = a0.add1024x1024(a1, a2, a3, b0, b1, b2, b3);
    }

    /**
     * @notice Calculates the difference of two uint512
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the higher bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the higher bits of the subtrahend
     * @return r0 The result as an uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function sub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a0.safeSub512x512(a1, b0, b1);
    }

    /**
     * @notice Calculates the difference of two uint768. The result is a uint768.
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the higher bits of the minuend
     * @param a2 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the higher bits of the subtrahend
     * @param b2 A uint256 representing the highest bits of the subtrahend
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function sub768x768(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 b0,
        uint256 b1,
        uint256 b2
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        (r0, r1, r2) = a0.sub768x768(a1, a2, b0, b1, b2);
    }

    /**
     * @notice Calculates the difference of two Uint1024. The result is a Uint1024.
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param a3 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @param b3 A uint256 representing the highest bits of the subtrahend
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function sub1024x1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        (r0, r1, r2, r3) = a0.sub1024x1024(a1, a2, a3, b0, b1, b2, b3);
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a 256 bit integer. It
     * requires the remainder to be known and the result must fit in a 256 bit integer
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/internalation/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a0 A uint256 representing the low bits of the nominator
     * @param a1 A uint256 representing the high bits of the nominator
     * @param b A uint256 representing the denominator
     * @param rem A uint256 representing the remainder of the devision. The algorithm is cheaper to compute if the remainder is known.
     * The remainder often be retreived cheaply using the mulmod and addmod operations
     * @return r The result as an uint256. Result must have at most 256 bit
     */
    function divRem512x256(uint256 a0, uint256 a1, uint256 b, uint256 rem) internal pure returns (uint256 r) {
        r = a0.divRem512x256(a1, b, rem);
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a 256 bit integer. It
     * requires the result to fit in a 256 bit integer
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/internalation/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a0 A uint256 representing the low bits of the nominator
     * @param a1 A uint256 representing the high bits of the nominator
     * @param b A uint256 representing the denominator
     * @return r The result as an uint256. Result must have at most 256 bit
     */
    function div512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r) {
        r = a0.safeDiv512x256(a1, b);
    }

    /**
     * @notice Calculates the square root of x, rounding down
     * @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
     * @param x The uint256 number for which to calculate the square root
     * @return s The square root as an uint256
     */
    function sqrt256(uint256 x) internal pure returns (uint256 s) {
        s = x.sqrt256();
    }

    /**
     * @notice Calculates the square root of a 512 bit unsigned integer, rounding down
     * @dev Uses the Karatsuba Square Root method. See https://hal.inria.fr/inria-00072854/document for details
     * @param a0 A uint256 representing the low bits of the input
     * @param a1 A uint256 representing the high bits of the input
     * @return s The square root as an uint256. Result has at most 256 bit
     */
    function sqrt512(uint256 a0, uint256 a1) internal pure returns (uint256 s) {
        s = a0.sqrt512(a1);
    }

    /**
     * @dev Tells if x is greater than y where x and y are 512 bit numbers
     * @notice x > y
     * @param x0 lower bits of x
     * @param x1 higher bits of y
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return gt boolean. True if x > y
     */
    function gt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool gt) {
        gt = x0.gt512(x1, y0, y1);
    }

    /**
     * @dev Tells if x is equal to y where x and y are 512 bit numbers
     * @notice x == y
     * @param x0 lower bits of x
     * @param x1 higher bits of y
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return eq boolean. True if x = y
     */
    function eq512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool eq) {
        eq = x0.eq512(x1, y0, y1);
    }

    /**
     * @dev Tells if x is greater or equal than y where x and y are 512 bit numbers
     * @notice x >= y
     * @param x0 lower bits of x
     * @param x1 higher bits of y
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return ge boolean. True if x >= y
     */
    function ge512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool ge) {
        ge = x0.ge512(x1, y0, y1);
    }

    /**
     * @dev Tells if x is less than y where x and y are 512 bit numbers
     * @notice x < y
     * @param x0 lower bits of x
     * @param x1 higher bits of y
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return lt boolean. True if x < y
     */
    function lt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool lt) {
        lt = x0.lt512(x1, y0, y1);
    }

    /**
     * @notice Checks the minuend(a0-a2) is greater than the right operand(b0-b2)
     * @dev Used as an underflow/negative result indicator for subtraction methods
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @return Returns true if there would be an underflow/negative result
     */
    function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool) {
        return a0.lt768(a1, a2, b0, b1, b2);
    }

    /**
     * @notice Checks the minuend(a0-a3) is greater than the right operand(b0-b3)
     * @dev Used as an underflow/negative result indicator for subtraction methods
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param a3 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @param b3 A uint256 representing the highest bits of the subtrahend
     * @return Returns true if there would be an underflow/negative result
     */
    function lt1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (bool) {
        return a0.lt1024(a1, a2, a3, b0, b1, b2, b3);
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a denominator which is
     * a power of 2. It doesn't require the result to be a uint256.
     * @dev very useful if a division of a 512 is expected to be also a 512.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return remainder of the division
     */
    function div512ByPowerOf2(uint256 a0, uint256 a1, uint8 n) internal pure returns (uint256 r0, uint256 r1, uint256 remainder) {
        (r0, r1, remainder) = a0.div512ByPowerOf2(a1, n);
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a 256-bit uint where the result
     * can be a 512 bit unsigned integer.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @param b A uint256 representing the denominator
     * @return r0 The lower bits of the result
     * @return r1 The highre bits of the result
     * @notice this function requires a0 to be greater than 0 and less or equal than 2**254
     */
    function div512x256ResultIn512(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a0.div512x256In512(a1, b);
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a 256-bit uint where the result
     * can be a 512 bit unsigned integer.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @param b0 A uint256 representing thehigh bits of the denominator
     * @param b1 A uint256 representing the low bits of the denominator
     * @return result
     */
    function div512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 result) {
        if (b1 == 0) return a0.safeDiv512x256(a1, b0);
        return a0.div512x512(a1, b0, b1);
    }

    /**
     * @dev Calculates the division of a uint768 by a uint256. The result is a uint768.
     * @notice Used long division
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the middle bits of the first factor
     * @param a2 A uint256 representing the higher bits of the first factor
     * @param b A uint256 representing the divisor
     * @return r0 The lower bits of the result
     * @return r1 The middle bits of the result
     * @return r2 The higher bits of the result
     */
    function div768x256(uint256 a0, uint256 a1, uint256 a2, uint256 b) internal pure returns (uint256 r0, uint r1, uint r2) {
        (r0, r1, r2) = a0.div768x256(a1, a2, b);
    }

    /**
     * @dev Calculates the division of a 768-bit unsigned integer by a denominator which is
     * a power of 2 less than 256.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the middle bits of the numerator
     * @param a2 A uint256 representing the high bits of the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r0 The lower bits of the result
     * @return r1 The middle bits of the result
     * @return r2 The higher bits of the result
     * @return remainder of the division
     */
    function div768ByPowerOf2(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint8 n
    ) internal pure returns (uint256 r0, uint256 r1, uint r2, uint256 remainder) {
        (r0, r1, r2, remainder) = a0.div768ByPowerOf2(a1, a2, n);
    }

    /**
     * @dev Calculates the division of a 768-bit dividend by a 512-bit divisor. The result will be a uint512.
     * @param a A uint768 representing the numerator
     * @param b A uint512 representing the denominator
     * @return result uint512 value
     */
    function div768x512(uint768 memory a, uint512 memory b) internal pure returns (uint512 memory result) {
        result = Uint1024.div768x512(a, b);
    }

    /**
     * @dev Calculates the division *a* / *b* where *a* is a 1024-bit unsigned integer and *b* is
     * a uint512.
     * @notice it requires to previously know the remainder of the division
     * @param a0 A uint256 representing the lowest bits of *a*
     * @param a1 A uint256 representing the mid-lower bits of *a*
     * @param a2 A uint256 representing the mid-higher bits of *a*
     * @param a3 A uint256 representing the highest bits of *a*
     * @param b0 A uint256 representing the lower bits of *b*
     * @param b1 A uint256 representing the higher bits of *b*
     * @param rem0 A uint256 representing the lower bits of the remainder of the division
     * @param rem1 A uint256 representing the higher bits of the remainder of the division
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     */
    function divRem1024x512In512(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 rem0,
        uint256 rem1
    ) internal pure returns (uint256 r0, uint r1) {
        (r0, r1) = a0.divRem1024x512In512(a1, a2, a3, b0, b1, rem0, rem1);
    }

    /**
     * @dev Divides a 512 bit unsigned integer by WAD where the result can be a 512 bit unsigned integer.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @return r0 The lower bits of the result
     * @return r1 The highre bits of the result
     * @notice this function requires a0 to be greater than 0 and less or equal than 2**254
     */
    function convertToRaw512(uint a0, uint a1) internal pure returns (uint256 r0, uint256 r1) {
        (r0, r1) = a0.convertToRaw512(a1);
    }

    /**
     * @param x the number to take the natural log of. Expressed as a WAD ** 2
     * @return result the ln of x multiplied by -1. Expressed as a WAD ** 2
     */
    function lnWAD2Negative(uint256 x) internal pure returns (uint256 result) {
        result = x.lnWAD2Negative();
    }

    /**
     * @dev Solves a quadratic equation of the form ax^2 + bx + c = 0
     * @param a The coefficient of x^2 expected with 36 decimals of precision
     * @param b The coefficient of x^1 expected with 36 decimals of precision
     * @param c The coefficient of x^0 expected with 36 decimals of precision
     * @param isBNegative Indicates sign of b. True if b is negative.
     * @return The solution of the equation whith the positive result of the square-root term with 36 decimals of precision
     */
    function solveQuadraticEquation(uint a, uint b, uint c, bool isBNegative) internal pure returns (uint256) {
        return a.solveQuadraticEquation(b, c, isBNegative);
    }
    
    /**
     * @dev this function tells how many WADs a number needs to be divided by to get to 0
     * @param x the number to be divided
     * @return precisionSlashingFactor the number of WADs needed to be divided to get to 0
     */
    function findWADsToSlashTo0(uint256 x) internal pure returns (uint256 precisionSlashingFactor) {
        precisionSlashingFactor = x.findWADsToSlashTo0();
    }
}
