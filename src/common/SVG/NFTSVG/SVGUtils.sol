// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice Small string helpers shared across the SVG generation libraries.
library SVGUtils {
    string constant FONT_FAMILY = "Helvetica, Arial, sans-serif";

    /// @notice Substring of a string
    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    /// @notice Builds the dark rounded "pill" background rect shared by the ID/token-symbol/address badges.
    function pillRect(string memory y, string memory width) internal pure returns (string memory) {
        return string(
            abi.encodePacked('<rect x="40" y="', y, '" width="', width, '" height="32" rx="8" fill="black" fill-opacity="0.6"/>')
        );
    }

    /// @notice Builds a `<text><tspan>...</tspan></text>` block using the shared font-family and the
    /// xml:space/white-space preamble common to every text label in the NFT SVG.
    function textTag(
        string memory fill,
        string memory fontSize,
        string memory letterSpacing,
        string memory x,
        string memory y,
        string memory content
    ) internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                '<text fill="',
                fill,
                '" xml:space="preserve" style="white-space: pre" font-family="',
                FONT_FAMILY,
                '" font-size="',
                fontSize,
                '" letter-spacing="',
                letterSpacing,
                '"><tspan x="',
                x,
                '" y="',
                y,
                '">',
                content,
                "</tspan></text>"
            )
        );
    }
}
