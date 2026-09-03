// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice Fixed-length hex string conversion (no "0x" prefix).
library HexStrings {
    bytes16 internal constant ALPHABET = "0123456789abcdef";

    /// @notice Convert a number to a fixed-width hex string without the '0x' prefix
    /// @param value The number to convert
    /// @param length The number of bytes to render, taken from the least-significant end of `value` -
    /// the output is `length * 2` hex characters (e.g. length=3 renders a 3-byte RGB color as 6 hex digits)
    /// @return The hex string
    function toHexStringNoPrefix(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length);
        for (uint256 i = buffer.length; i > 0; i--) {
            buffer[i - 1] = ALPHABET[value & 0xf];
            value >>= 4;
        }
        return string(buffer);
    }
}
