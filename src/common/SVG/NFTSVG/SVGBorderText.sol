// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {SVGParams} from "./SVGTypes.sol";
import {SVGUtils} from "./SVGUtils.sol";

/// @notice Builds the animated "Pool • 0x..." marquee text that follows the card's rounded border,
/// plus the shared <defs> (border path, blur filters, clip paths) it and the gradient circles rely on.
library SVGBorderText {
    string constant DEFS =
        "<defs>"
        '<path id="borderPath" d="M48,16 L372,16 A32,32 0 0 1 404,48 L404,512 A32,32 0 0 1 372,544 L48,544 A32,32 0 0 1 16,512 L16,48 A32,32 0 0 1 48,16 z" fill="none"/>'
        '<filter id="filter0_f_2943_19260" x="-357" y="-574" width="1370" height="1370" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">'
        '<feFlood flood-opacity="0" result="BackgroundImageFix"/>'
        '<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>'
        '<feGaussianBlur stdDeviation="202" result="effect1_foregroundBlur_2943_19260"/>'
        "</filter>"
        '<filter id="filter1_f_2943_19260" x="-689" y="-166" width="1446" height="1446" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">'
        '<feFlood flood-opacity="0" result="BackgroundImageFix"/>'
        '<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>'
        '<feGaussianBlur stdDeviation="202" result="effect1_foregroundBlur_2943_19260"/>'
        "</filter>"
        '<clipPath id="clip0_2943_19260">'
        '<rect width="420" height="560" rx="32" fill="white"/>'
        "</clipPath>"
        "</defs>";

    /// @notice Builds one animated "Pool • 0x..." text-on-path block, scrolling from `fromOffset` to `toOffset`.
    function _animatedPoolText(string memory fromOffset, string memory toOffset, string memory poolAddress)
        private
        pure
        returns (string memory)
    {
        return string(
            abi.encodePacked(
                '<text font-family="',
                SVGUtils.FONT_FAMILY,
                '" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">',
                '<textPath href="#borderPath" startOffset="0%">',
                '<animate attributeName="startOffset" ',
                'from="',
                fromOffset,
                '" to="',
                toOffset,
                '" begin="0s" dur="30s" ',
                'repeatCount="indefinite" />',
                "Pool &#x2022;&#xa0;",
                poolAddress,
                "</textPath>",
                "</text>"
            )
        );
    }

    function generateBorderTextAndBackground(SVGParams memory params) public pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g transform="translate(0,0)">',
                _animatedPoolText("-100%", "0%", params.poolAddress),
                _animatedPoolText("0%", "100%", params.poolAddress),
                "</g>",
                "</svg>"
            )
        );
    }
}
