/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import {MathLibs, packedFloat} from "src/amm/mathLibs/MathLibs.sol";
import {TestCommon} from "test/util/TestCommon.sol";
import {QuadraticEquation} from "src/amm/mathLibs/lib/QuadraticEq.sol";

/**
 * @title Test Math Library
 * @dev tests the limits of the math library to better understand what can be done what cannot.
 * @author @oscarsernarosero @mpetersoCode55
 */
contract MathLibTests is TestCommon {
    using MathLibs for uint256;
    using MathLibs for packedFloat;
    using MathLibs for int256;

    uint one = 1;
    uint two = 2;
    uint max256 = 2 ** 256 - 1;
    uint max256Sub1 = 2 ** 256 - 2;

    /**
     * @dev this test is just an informational test
     * @notice 340282366920938463463374607431768211456 is the number at which the sqr starts overflowing
     */
    function testEquation_MathLibTests_MaxSquareableNumberPureSol() public {
        uint maxSqr = 340_282_366_920_938_463_463_374607431768211455;
        maxSqr * maxSqr;
        vm.expectRevert();
        (maxSqr + 1) * (maxSqr + 1);
    }

    function testEquation_MathLibTests_gt512() public view {
        assertTrue(two.gt512(0, one, 0), "2 > 1");
        assertFalse(one.gt512(0, two, 0), "1 !> 2");
        assertFalse(one.gt512(0, one, 0), "1 !> 1");

        assertTrue(max256.gt512(0, max256Sub1, 0), "max256 > max256-1");
        assertFalse(max256Sub1.gt512(0, max256, 0), "max256-1 !> max256");
        assertFalse(max256Sub1.gt512(0, max256Sub1, 0), "max256-1 !> max256-1");

        assertTrue(max256.gt512(one, max256, 0), "max256+1 > max256");
        assertFalse(max256.gt512(0, max256, one), "max256 !> max256+1");
        assertFalse(max256.gt512(one, max256, one), "max256+1 !> max256+1");

        assertTrue(max256.gt512(max256, max256, max256Sub1), "max512 > max512-1");
        assertFalse(max256.gt512(max256Sub1, max256, max256), "max512-1 !> max512");
    }

    function testEquation_MathLibTests_ge512() public view {
        assertTrue(two.ge512(0, one, 0), "2 >= 1");
        assertFalse(one.ge512(0, two, 0), "1 !>= 2");
        assertTrue(one.ge512(0, one, 0), "1 >= 1");

        assertTrue(max256.ge512(0, max256Sub1, 0), "max256 >= max256-1");
        assertFalse(max256Sub1.ge512(0, max256, 0), "max256-1 !>= max256");
        assertTrue(max256Sub1.ge512(0, max256Sub1, 0), "max256-1 >= max256-1");

        assertTrue(max256.ge512(one, max256, 0), "max256+1 >= max256");
        assertFalse(max256.ge512(0, max256, one), "max256 !>= max256+1");
        assertTrue(max256.ge512(one, max256, one), "max256+1 >= max256+1");

        assertTrue(max256.ge512(max256, max256, max256Sub1), "max512 >= max512-1");
        assertFalse(max256.ge512(max256Sub1, max256, max256), "max512-1 !>= max512");
    }

    function testEquation_MathLibTests_lt512() public view {
        assertFalse(one.lt512(0, one, 0), "1 !> 1");
        assertFalse(two.lt512(0, one, 0), "2 !> 1");
        assertTrue(one.lt512(0, two, 0), "1 < 2");

        assertFalse(max256Sub1.lt512(0, max256Sub1, 0), "max256-1 !< max256-1");
        assertFalse(max256.lt512(0, max256Sub1, 0), "max256 !< max256-1");
        assertTrue(max256Sub1.lt512(0, max256, 0), "max256-1 < max256");

        assertFalse(max256.lt512(one, max256, one), "max256+1 !< max256+1");
        assertFalse(max256.lt512(one, max256, 0), "max256+1 !< max256");
        assertTrue(max256.lt512(0, max256, one), "max256 < max256+1");

        assertFalse(max256.lt512(max256, max256, max256Sub1), "max512 !< max512-1");
        assertTrue(max256.lt512(max256Sub1, max256, max256), "max512-1 < max512");
    }

    function testEquation_MathLibTests_eq512() public view {
        assertTrue(one.eq512(0, one, 0), "1 == 1");
        assertTrue(two.eq512(0, two, 0), "2 == 2");
        assertFalse(one.eq512(0, two, 0), "1 !== 2");

        assertTrue(max256.eq512(0, max256, 0), "max256 == max256");
        assertTrue(max256Sub1.eq512(0, max256Sub1, 0), "max256-1 == max256-1");
        assertFalse(max256Sub1.eq512(0, max256, 0), "max256-1 !== max256");

        assertFalse(max256.eq512(one, max256, 0), "max256+1 !== max256");
        assertFalse(max256.eq512(2, max256, one), "max256+2 !== max256+1");

        assertTrue(max256.eq512(max256Sub1, max256, max256Sub1), "max512-1 == max512-1");
        assertFalse(max256.eq512(max256Sub1, max256, max256), "max512-1 !== max512");
    }

    function testEquation_MathLibTests_Sqrt256FuzzLowerRange(uint256 x) public {
        uint8 MAX_TOLERANCE = 5;
        uint TOLERANCE_DEN = 1e13;
        x = x % 9999999999999999;
        uint256 solidityRes = x.sqrt256();

        string[] memory inputs = _buildBaseFFIsqrt(x);
        bytes memory pythonRes = vm.ffi(inputs);
        uint resUint;
        if (isPossiblyAnAscii(pythonRes)) {
            /// we decode the ascii into a uint
            resUint = decodeAsciiUint(pythonRes);
            if (resUint == 0) {
                return;
            }
            if (!areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN)) resUint = decodeFakeDecimalBytes(pythonRes);
        } else {
            resUint = decodeFakeDecimalBytes(pythonRes);
        }
        console2.log("solidityRes:", solidityRes);
        console2.log("pythonRes:", resUint);
        assertTrue(areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN));
    }

    function testEquation_MathLibTests_Sqrt256FuzzMidRange(uint256 x) public {
        uint8 MAX_TOLERANCE = 5;
        uint TOLERANCE_DEN = 1e11;
        uint floor = 9999999999999999;
        x = (x % floor) * 1e18;
        x += floor;
        uint256 solidityRes = (x + 1).sqrt256();
        // solidityRes /= 30;

        string[] memory inputs = _buildBaseFFIsqrt(x);
        bytes memory pythonRes = vm.ffi(inputs);
        uint resUint;
        if (isPossiblyAnAscii(pythonRes)) {
            /// we decode the ascii into a uint
            resUint = decodeAsciiUint(pythonRes);
            if (resUint == 0) {
                return;
            }
            if (!areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN)) resUint = decodeFakeDecimalBytes(pythonRes);
        } else {
            resUint = decodeFakeDecimalBytes(pythonRes);
        }
        console2.log("solidityRes:", solidityRes);
        console2.log("pythonRes:", resUint);
        assertTrue(areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN));
    }

    function testEquation_MathLibTests_Sqrt256FuzzUpperRange(uint256 x) public {
        uint8 MAX_TOLERANCE = 5;
        uint TOLERANCE_DEN = 1e15;
        uint floor = 9999999999999999 * 1e18;
        x = type(uint256).max - floor - 1;
        x += floor;
        uint256 solidityRes = (x + 1).sqrt256();

        string[] memory inputs = _buildBaseFFIsqrt(x);
        bytes memory pythonRes = vm.ffi(inputs);
        uint resUint;
        if (isPossiblyAnAscii(pythonRes)) {
            /// we decode the ascii into a uint
            resUint = decodeAsciiUint(pythonRes);
            if (resUint == 0) {
                return;
            }
            if (!areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN)) resUint = decodeFakeDecimalBytes(pythonRes);
        } else {
            resUint = decodeFakeDecimalBytes(pythonRes);
        }
        console2.log("solidityRes:", solidityRes);
        console2.log("pythonRes:", resUint);
        assertTrue(areWithinTolerance(solidityRes, resUint, MAX_TOLERANCE, TOLERANCE_DEN));
    }

    function testEquations_MathLibTests_NaturalLogarithmWAD2(uint256 x) public {
        x = bound(x, 1, 1e36);

        string[] memory inputs = _buildFFICalculateLogarithmNaturalWAD2(x);
        bytes memory res = vm.ffi(inputs);
        int pyVal = abi.decode(res, (int256));
        uint resUint = uint(-pyVal);

        uint256 solVal = x.lnWAD2Negative();
        console2.log("returnValLo: ", solVal);

        console2.log("Res: ", resUint);
        if (!areWithinTolerance(resUint, solVal, 1, 1e27)) {
            revert("out of tolerance");
        }
    }

    function testEquations_MathLibTests_QuadraticEquation(uint256 a, uint256 b, uint256 c, bool isBNegative) public {
        a = bound(a, 2, 2 ** 256 - 1);
        b = bound(b, 0, 2 ** 256 - 1);
        c = bound(c, 0, 2 ** 255 - 1);

        string[] memory inputs = _buildFFIQuadraticEquation(a, b, c, isBNegative);
        bytes memory res = vm.ffi(inputs);
        uint flag;
        uint pyVal;
        (pyVal, flag) = abi.decode(res, (uint256, uint256));

        if (flag == 1) {
            vm.expectRevert("QuadraticEquation: Imaginary result");
            QuadraticEquation.solveQuadraticEquation(a, b, c, isBNegative);
        } else if (flag == 2) {
            vm.expectRevert("QuadraticEquation: negative result");
            QuadraticEquation.solveQuadraticEquation(a, b, c, isBNegative);
        } else if (flag == 3) {
            vm.expectRevert("Uint512: a1 >= b div512x256");
            QuadraticEquation.solveQuadraticEquation(a, b, c, isBNegative);
        }
        uint solVal = QuadraticEquation.solveQuadraticEquation(a, b, c, isBNegative);
        console2.log("returnVal: ", solVal, pyVal, isBNegative);

        // NOTE: perfect precision excluding the last 18 precision decimals out of the 36.
        assertEq(pyVal / 1e18, solVal / 1e18);
    }

    function testEquation_MathLibTests_div512ByPowerOf2(uint a0, uint a1, uint8 n) public {
        a1 = a1 % (2 ** 254);
        n = (n % 254) + 1;

        (uint solR0, uint solR1, uint solRemainder) = a0.div512ByPowerOf2(a1, n);

        string[] memory inputs = _buildFFIDiv512ByPowerOf2(a0, a1, n);
        bytes memory res = vm.ffi(inputs);
        (uint pyValLo, uint pyValHi, uint remainder) = abi.decode(res, (uint, uint, uint));

        assertEq(pyValLo, solR0);
        assertEq(pyValHi, solR1);
        assertEq(remainder, solRemainder);
    }

    function testEquation_MathLibTests_testDiv512x256ResultIn512(uint a0, uint a1, uint b) public {
        uint8 MAX_TOLERANCE = 1;
        uint TOLERANCE_PRECISION_WAD1 = 59;
        uint TOLERANCE_PRECISION_WAD2 = 41;
        uint TOLERANCE_DEN_WAD1 = 10 ** TOLERANCE_PRECISION_WAD1;
        uint TOLERANCE_DEN_WAD2 = 10 ** TOLERANCE_PRECISION_WAD2;

        uint bWad1 = bound(b, 2, 1e18);
        uint bWad12 = bound(b, 2, 1e36);
        a1 = bound(a1, 1, 2 ** 254);

        _testDiv512x256ResultIn512(a0, a1, bWad1, MAX_TOLERANCE, TOLERANCE_DEN_WAD1);
        _testDiv512x256ResultIn512(a0, a1, bWad12, MAX_TOLERANCE, TOLERANCE_DEN_WAD2);
    }

    function _testDiv512x256ResultIn512(uint a0, uint a1, uint b, uint8 MAX_TOLERANCE, uint TOLERANCE_DEN) internal {
        (uint solR0, uint solR1) = a0.div512x256ResultIn512(a1, b);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFIDiv512x256ResultIn512(a0, a1, b);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyValLo, pyValHi);

        if (pyValHi / (MathLibs.WAD) > 1e54) {
            assertTrue(areWithinTolerance(solR1, pyValHi, MAX_TOLERANCE, TOLERANCE_DEN));
        } else if (!areWithinTolerance512(solR0, solR1, pyValLo, pyValHi, MAX_TOLERANCE, TOLERANCE_DEN)) {
            revert("assertion failed");
        }
    }

    function testEquation_MathLibTests_testConvertToRaw512(uint a0, uint a1) public {
        uint8 MAX_TOLERANCE = 1;
        uint TOLERANCE_DEN = 10 ** 58;
        a1 = bound(a1, 1, 2 ** 254);
        (uint solR0, uint solR1) = a0.convertToRaw512(a1);
        console2.log("solRes ", solR0, solR1);
        string[] memory inputs = _buildFFIConvertToRaw512(a0, a1);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyValLo, pyValHi);
        if (pyValHi == 0) {
            assertTrue(areWithinTolerance(solR0, pyValLo, MAX_TOLERANCE, TOLERANCE_DEN));
        } else if (!areWithinTolerance512(solR0, solR1, pyValLo, pyValHi, MAX_TOLERANCE, TOLERANCE_DEN)) {
            revert("assertion failed");
        }
    }

    function testEquation_MathLibTests_testDiv512x512(uint a0, uint a1, uint b0, uint b1) public {
        b1 = bound(b1, 1, 1e18);
        a1 = bound(a1, b1 * 2 + 1, type(uint256).max);
        console2.log(a0, a1, b0, b1);
        uint solVal = a0.div512x512(a1, b0, b1);
        console2.log("solVal:", solVal);

        string[] memory inputs = _buildFFIDiv512x512(a0, a1, b0, b1);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        uint pyVal = abi.decode(res, (uint));
        console2.log("pythonRes:", pyVal);

        uint perfectPrecisionRange = 1e23 - 1;

        if (solVal <= perfectPrecisionRange) {
            assertEq(solVal, pyVal, "solVal not equal to pyVal when value has 22 digits or less");
        } else {
            if (absoluteDiff(solVal, pyVal) > 1)
                revert(
                    string.concat(
                        "absolute difference is greater than 1 and the number is greater than ",
                        vm.toString(perfectPrecisionRange)
                    )
                );
        }
    }

    function testconvertpackedFloatToWADPositive() public {
        int256 manA = 2000;
        int256 expA = -16;
        packedFloat floA = manA.toPackedFloat(expA);

        int256 result = MathLibs.convertpackedFloatToWAD(floA);
        console2.log(result);
        assertEq(200000, result);
    }

    function testconvertpackedFloatToWADNegative() public {
        int256 manA = 2000;
        int256 expA = -20;
        packedFloat floA = manA.toPackedFloat(expA);

        int256 result = MathLibs.convertpackedFloatToWAD(floA);
        console2.log(result);
        assertEq(20, result);
    }

    function testconvertpackedFloatToDoubleWADPositive() public {
        int256 manA = 2000;
        int256 expA = -34;
        packedFloat floA = manA.toPackedFloat(expA);

        int256 result = MathLibs.convertpackedFloatToDoubleWAD(floA);
        console2.log(result);
        assertEq(200000, result);
    }

    function testconvertpackedFloatToDoubleWADNegative() public {
        int256 manA = 2000;
        int256 expA = -38;
        packedFloat floA = manA.toPackedFloat(expA);

        int256 result = MathLibs.convertpackedFloatToDoubleWAD(floA);
        console2.log(result);
        assertEq(20, result);
    }
}
