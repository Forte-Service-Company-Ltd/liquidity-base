// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";

/// @notice Builds the TKNX and TKNY (x/y token symbol + truncated address) pills.
library SVGTokenFields {
    using Strings for uint256;

    /// @notice returns the x token of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateXToken(SVGParams memory params) internal pure returns (string memory svg) {
        string memory addr = string(abi.encodePacked(SVGUtils.substring(params.xToken, 0, 6), "...", SVGUtils.substring(params.xToken, 36, 42)));
        uint labelLen = bytes(params.xTokenSymbol).length;
        uint width = 12 + labelLen * 9 + 16 + 15 * 9 + 12;
        uint valueX = 60 + labelLen * 9 + 16;
        svg = string(
            abi.encodePacked(
                '<rect x="48" y="420" width="',
                width.toString(),
                '" height="28" rx="8" fill="black" fill-opacity="0.6"/>',
                '<text fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0.5px"><tspan x="60" y="439">',
                params.xTokenSymbol,
                "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0.5px"><tspan x="',
                valueX.toString(),
                '" y="439">',
                addr,
                "</tspan></text>"
            )
        );
    }

    /// @notice returns the y token of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateYToken(SVGParams memory params) internal pure returns (string memory svg) {
        string memory addr = string(abi.encodePacked(SVGUtils.substring(params.yToken, 0, 6), "...", SVGUtils.substring(params.yToken, 36, 42)));
        uint labelLen = bytes(params.yTokenSymbol).length;
        uint width = 12 + labelLen * 9 + 16 + 15 * 9 + 12;
        uint valueX = 60 + labelLen * 9 + 16;
        svg = string(
            abi.encodePacked(
                '<rect x="48" y="468" width="',
                width.toString(),
                '" height="28" rx="8" fill="black" fill-opacity="0.6"/>',
                '<text fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0.5px"><tspan x="60" y="487">',
                params.yTokenSymbol,
                "</tspan></text>",
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="16" letter-spacing="0.5px"><tspan x="',
                valueX.toString(),
                '" y="487">',
                addr,
                "</tspan></text></g>"
            )
        );
    }
}
