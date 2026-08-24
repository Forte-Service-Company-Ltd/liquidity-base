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
        string memory addr = string(
            abi.encodePacked(" ", SVGUtils.substring(params.xToken, 0, 6), "...", SVGUtils.substring(params.xToken, 36, 42))
        );
        uint labelLen = bytes(params.xTokenSymbol).length;
        uint width = 12 + labelLen * 9 + 12 + 16 * 9 + 12;
        uint valueX = 40 + 12 + labelLen * 9 + 12;
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
        uint labelLen = bytes(params.yTokenSymbol).length;
        uint width = 12 + labelLen * 9 + 12 + 16 * 9 + 12;
        uint valueX = 40 + 12 + labelLen * 9 + 12;
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
