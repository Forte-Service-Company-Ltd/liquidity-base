// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Uint1024} from "uint1024/Uint1024.sol";

/**
 * @title Utility function for equations
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve
 */
library MathUtils {
    uint256 constant WAD = 1e18;
    using Uint1024 for uint256;

    /**
     * @dev This function provides an abstraction layer for division between aquifi-liquidity and the underlying math library
     * @notice This function expects the parameters to not have been multiplied by WAD, and the result will be a WAD number.
     * @param x represents the first factor
     * @param y represents the second factor
     * @return result of the division operation
     */
    function uncheckedMultiply(uint256 x, uint256 y) internal pure returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := mul(x, y)
        }
    }

    /**
     * @dev This function converts a raw number to a WAD number
     * @param value The number to be converted
     * @return result resulting WAD number
     */
    function convertToWAD(uint256 value) internal pure returns (uint256 result) {
        result = value * WAD;
    }

    /**
     * @dev This function converts a WAD number to a raw number
     * @param value The number to be converted
     * @return result resulting raw number
     */
    function convertToRaw(uint256 value) internal pure returns (uint256 result) {
        result = value / WAD;
    }

    /**
     * @dev this function tells how many WADs a number needs to be divided by to get to 0
     * @param x the number to be divided
     * @return precisionSlashingFactor the number of WADs needed to be divided to get to 0
     */
    function findWADsToSlashTo0(uint256 x) internal pure returns (uint256 precisionSlashingFactor) {
        // this loop could be possibly run only 5 times since a 256-bit number can only shift 59 bits
        // 5 times to cover the totality of the bits.
        while (x > 0) {
            // we shift enough bits to the right to emulate a division by WAD
            x = x >> 59; // shifting 59 bits to the right is the same as dividing by 0.57e18
            unchecked {
                ++precisionSlashingFactor;
            }
        }
    }

    /**
    * @dev Divides a 512 bit unsigned integer by WAD where the result can be a 512 bit unsigned integer.
    * @param a0 A uint256 representing the low bits of the numerator
    * @param a1 A uint256 representing the high bits of the numerator
    * @return r0 The lower bits of the result
    * @return r1 The highre bits of the result
    * @notice this function requires a0 to be greater than 0 and less or equal than 2**254
    */
    function convertToRaw512(uint a0, uint a1) internal pure returns(uint256 r0, uint256 r1){
        (r0, r1) = a0.div512x256In512(a1, 1e18);
    }
    
}
