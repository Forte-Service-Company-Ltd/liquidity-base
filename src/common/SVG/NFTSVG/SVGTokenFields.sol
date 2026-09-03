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
        svg = SVGUtils.labelValuePill("436", "457.52", params.xTokenSymbol, addr);
    }

    /// @notice returns the y token of the SVG
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateYToken(SVGParams memory params) internal pure returns (string memory svg) {
        string memory addr = string(
            abi.encodePacked(" ", SVGUtils.substring(params.yToken, 0, 6), "...", SVGUtils.substring(params.yToken, 36, 42))
        );
        svg = string(abi.encodePacked(SVGUtils.labelValuePill("480", "501.52", params.yTokenSymbol, addr), "</g>"));
    }
}
