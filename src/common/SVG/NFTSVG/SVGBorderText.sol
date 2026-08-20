// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {SVGParams} from "./SVGTypes.sol";

/// @notice Builds the animated "Pool • 0x..." marquee text that follows the card's rounded border,
/// plus the shared <defs> (border path, blur filters, clip paths) it and the gradient circles rely on.
library SVGBorderText {
    string constant DEFS =
        "<defs>"
        '<path id="borderPath" d="M58,26 L362,26 A32,32 0 0 1 394,58 L394,502 A32,32 0 0 1 362,534 L58,534 A32,32 0 0 1 26,502 L26,58 A32,32 0 0 1 58,26 z" fill="none"/>'
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
        '<rect width="420" height="560" rx="20" fill="white"/>'
        "</clipPath>"
        '<clipPath id="clip1_2943_19260">'
        '<rect width="682" height="682" fill="white"/>'
        "</clipPath>"
        "</defs>";

    /// @dev Unused legacy fragment kept from the original implementation; superseded by
    /// generateBorderTextAndBackground below, which builds both animation directions dynamically.
    string constant BEGIN_ANIMATION =
        '<g transform="translate(0,0)">'
        '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">'
        '<textPath href="#borderPath" startOffset="0%">'
        '<animate attributeName="startOffset" '
        'from="-100%" to="0%" begin="0s" dur="30s" '
        'repeatCount="indefinite" />'
        "Pool &#x2022;&#xa0;";

    function generateBorderTextAndBackground(SVGParams memory params) public pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g transform="translate(0,0)">',
                '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">',
                '<textPath href="#borderPath" startOffset="0%">',
                '<animate attributeName="startOffset" ',
                'from="-100%" to="0%" begin="0s" dur="30s" ',
                'repeatCount="indefinite" />',
                "Pool &#x2022;&#xa0;",
                params.poolAddress,
                "</textPath>",
                "</text>",
                '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">',
                '<textPath href="#borderPath" startOffset="0%">',
                '<animate attributeName="startOffset" ',
                'from="0%" to="100%" ',
                'begin="0s" dur="30s" ',
                'repeatCount="indefinite" />',
                "Pool &#x2022;&#xa0;",
                params.poolAddress,
                "</textPath>",
                "</text>",
                "</g>",
                "</svg>"
            )
        );
    }
}
