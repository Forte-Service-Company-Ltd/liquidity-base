// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice Small string helpers shared across the SVG generation libraries.
library SVGUtils {
    /// @notice Substring of a string
    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}
