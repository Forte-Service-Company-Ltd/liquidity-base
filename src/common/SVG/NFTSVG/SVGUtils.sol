// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGFontMetrics} from "./SVGFontMetrics.sol";

/// @notice Small string helpers shared across the SVG generation libraries.
library SVGUtils {
    using Strings for uint256;

    string constant FONT_FAMILY = "Helvetica, Arial, sans-serif";
    uint256 constant CARD_CONTENT_X = 40;
    uint256 constant PILL_LEFT_PAD = 12;
    uint256 constant PILL_RIGHT_PAD = 12;
    uint256 constant PILL_LETTER_SPACING_TENTHS = 5; // 0.5px, matches the "0.5px" letter-spacing on these labels

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
            abi.encodePacked(
                '<rect x="',
                CARD_CONTENT_X.toString(),
                '" y="',
                y,
                '" width="',
                width,
                '" height="32" rx="8" fill="black" fill-opacity="0.6"/>'
            )
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

    /// @notice Builds a complete "label value" pill: a dark rounded background sized to exactly
    /// fit `label` (gray) immediately followed by `value` (white), both at 16px/0.5px
    /// letter-spacing - the shared shape behind the ID, TKNX, and TKNY badges.
    /// @param pillY The y-coordinate of the background rect
    /// @param textY The y-coordinate (baseline) of both text elements
    /// @param label The gray label text (e.g. "ID", a token symbol)
    /// @param value The white value text (e.g. " #1", a truncated address) - any leading space
    /// meant to visually separate it from the label must already be part of this string
    function labelValuePill(
        string memory pillY,
        string memory textY,
        string memory label,
        string memory value
    ) internal pure returns (string memory) {
        uint256 labelWidth = SVGFontMetrics.measureWidth(label, 16, PILL_LETTER_SPACING_TENTHS);
        uint256 valueWidth = SVGFontMetrics.measureWidth(value, 16, PILL_LETTER_SPACING_TENTHS);
        uint256 width = PILL_LEFT_PAD + labelWidth + valueWidth + PILL_RIGHT_PAD;
        uint256 labelX = CARD_CONTENT_X + PILL_LEFT_PAD;
        uint256 valueX = labelX + labelWidth;
        return string(
            abi.encodePacked(
                pillRect(pillY, width.toString()),
                textTag("#999999", "16", "0.5px", labelX.toString(), textY, label),
                textTag("white", "16", "0.5px", valueX.toString(), textY, value)
            )
        );
    }
}
