// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";
import {SVGFontMetrics} from "./SVGFontMetrics.sol";

/// @notice Builds the TKNX and TKNY (x/y token symbol + truncated address) pills.
library SVGTokenFields {
    using Strings for uint256;

    uint256 constant LEFT_PAD = 12;
    uint256 constant RIGHT_PAD = 12;
    uint256 constant LETTER_SPACING_TENTHS = 5; // 0.5px, matches the "0.5px" letter-spacing on these labels

    /// @notice returns the x token of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateXToken(SVGParams memory params) internal pure returns (string memory svg) {
        string memory addr = string(
            abi.encodePacked(" ", SVGUtils.substring(params.xToken, 0, 6), "...", SVGUtils.substring(params.xToken, 36, 42))
        );
        uint labelWidth = SVGFontMetrics.measureWidth(params.xTokenSymbol, 16, LETTER_SPACING_TENTHS);
        uint valueWidth = SVGFontMetrics.measureWidth(addr, 16, LETTER_SPACING_TENTHS);
        uint width = LEFT_PAD + labelWidth + valueWidth + RIGHT_PAD;
        uint valueX = 40 + LEFT_PAD + labelWidth;
        svg = string(
            abi.encodePacked(
                SVGUtils.pillRect("436", width.toString()),
                SVGUtils.textTag("#999999", "16", "0.5px", "52", "457.52", params.xTokenSymbol),
                SVGUtils.textTag("white", "16", "0.5px", valueX.toString(), "457.52", addr)
            )
        );
    }

    /// @notice returns the y token of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateYToken(SVGParams memory params) internal pure returns (string memory svg) {
        string memory addr = string(
            abi.encodePacked(" ", SVGUtils.substring(params.yToken, 0, 6), "...", SVGUtils.substring(params.yToken, 36, 42))
        );
        uint labelWidth = SVGFontMetrics.measureWidth(params.yTokenSymbol, 16, LETTER_SPACING_TENTHS);
        uint valueWidth = SVGFontMetrics.measureWidth(addr, 16, LETTER_SPACING_TENTHS);
        uint width = LEFT_PAD + labelWidth + valueWidth + RIGHT_PAD;
        uint valueX = 40 + LEFT_PAD + labelWidth;
        svg = string(
            abi.encodePacked(
                SVGUtils.pillRect("480", width.toString()),
                SVGUtils.textTag("#999999", "16", "0.5px", "52", "501.52", params.yTokenSymbol),
                SVGUtils.textTag("white", "16", "0.5px", valueX.toString(), "501.52", addr),
                "</g>"
            )
        );
    }
}
