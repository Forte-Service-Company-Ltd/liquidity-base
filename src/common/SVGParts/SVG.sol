// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SVGLinesPart1} from "src/common/SVGParts/SVGLinesPart1.sol";
import {SVGLinesPart2} from "src/common/SVGParts/SVGLinesPart2.sol";
import {SVGLinesPart3} from "src/common/SVGParts/SVGLinesPart3.sol";

library SVG {
    using Strings for uint256;

    string constant SVG_LINE_STARTER = '<g opacity="0.1" clip-path="url(#clip1_2943_19260)">'
        '<path d="M220.178 44.5353C206.427 40.624 189.267 51.1145 171.104 62.2207C169.269 63.3416 167.433 64.4664 165.598 65.5754C157.697 70.3707 143.93 74.2859 130.614 78.0709C111.137 83.6082 90.9965 89.3349 87.0576 98.2309C82.7517 107.802 96.8219 120.633 110.43 133.041C118.024 139.968 125.199 146.508 128.404 151.879C131.995 157.894 136.005 163.112 140.256 168.633C146.555 176.823 153.067 185.289 159.058 197.437C161.596 202.599 163.976 208.306 166.502 214.349C174.024 232.365 181.808 250.994 194.638 257.412C198.289 259.227 202.319 260.016 206.692 260.016C219.349 260.016 234.844 253.414 252.087 246.069C256.61 244.143 261.283 242.149 266.047 240.22C274.892 236.581 289.148 232.231 305.653 227.195C342.61 215.919 388.57 201.896 399.495 187.601H399.538L399.657 187.44C407.578 176.704 411.489 167.137 411.619 158.182C411.758 148.627 407.641 139.392 399.041 129.947C389.178 119.129 356.337 111.208 324.578 103.551C299.863 97.5915 276.518 91.9595 267.109 85.5658C257.191 78.8444 249.593 70.4457 242.891 63.0416C235.077 54.4061 228.328 46.9467 220.19 44.5471L220.178 44.5353ZM266.659 86.2091C276.186 92.6857 299.599 98.3296 324.388 104.309C356.033 111.942 388.752 119.832 398.453 130.472C414.777 148.39 414.986 165.243 399.136 186.804H399.096L398.978 186.962C388.428 201.103 342.401 215.146 305.42 226.433C288.895 231.477 274.623 235.831 265.747 239.485C260.98 241.419 256.303 243.412 251.776 245.338C228.758 255.146 208.878 263.616 194.99 256.705C182.419 250.418 174.695 231.927 167.228 214.045C164.698 207.99 162.311 202.271 159.765 197.089C153.738 184.87 147.202 176.373 140.884 168.156C136.649 162.65 132.651 157.452 129.087 151.477C125.823 146.006 118.608 139.427 110.967 132.461C98.1915 120.81 83.7108 107.608 87.7839 98.5585C91.5727 89.998 111.532 84.3225 130.835 78.8326C144.199 75.0319 158.02 71.1048 166.009 66.2543C167.844 65.1452 169.683 64.0204 171.518 62.8995C186.33 53.8417 201.581 44.5195 214.096 44.5195C216.129 44.5195 218.09 44.7642 219.965 45.297C227.886 47.6335 234.568 55.0139 242.303 63.5626C249.037 71.0022 256.666 79.4365 266.663 86.213L266.659 86.2091Z" fill="white"/>'
        '<path d="M197.2 98.5351C193.103 101.227 186.844 103.626 180.217 106.168C169.565 110.253 158.549 114.48 156.047 120.337C153.414 126.447 159.962 133.965 166.293 141.235C169.715 145.162 172.943 148.868 174.403 152.037C176.562 156.726 179.439 160.906 182.482 165.334C185.427 169.612 188.466 174.033 191.501 179.688C192.815 182.155 194.094 184.792 195.447 187.578C200.614 198.234 205.958 209.25 214.127 212.431C215.86 213.098 217.707 213.398 219.665 213.398C226.824 213.398 235.424 209.396 245.05 204.912C248.275 203.412 251.61 201.857 255.04 200.389C260.281 198.128 268.845 195.456 277.911 192.63C298.083 186.339 320.947 179.203 326.677 171.412C335.044 159.864 334.804 149.077 325.919 137.47C320.71 130.709 303.802 125.464 287.45 120.392C275.468 116.674 264.153 113.166 259.223 109.491C254.862 106.243 251.14 102.64 247.541 99.1587C241.585 93.3925 236.439 88.4116 230.266 86.8882C220.494 84.5557 208.598 91.1112 197.2 98.5469V98.5351ZM258.75 110.115C263.79 113.868 275.168 117.397 287.214 121.134C302.693 125.937 320.236 131.376 325.292 137.94C333.931 149.231 334.168 159.714 326.034 170.934C320.457 178.516 296.733 185.92 277.67 191.864C268.585 194.698 260.001 197.378 254.72 199.655C251.278 201.131 247.939 202.686 244.711 204.19C232.618 209.822 222.175 214.684 214.408 211.689C206.53 208.622 201.253 197.745 196.154 187.227C194.796 184.428 193.518 181.788 192.195 179.309C189.141 173.618 185.948 168.977 183.13 164.88C180.106 160.483 177.249 156.331 175.118 151.702C173.614 148.434 170.346 144.685 166.889 140.714C160.716 133.63 154.334 126.301 156.773 120.649C159.145 115.096 170.003 110.932 180.501 106.906C187.167 104.349 193.466 101.933 197.634 99.1942C207.331 92.8715 217.376 87.1842 226.035 87.1842C227.42 87.1842 228.774 87.3302 230.084 87.642C236.048 89.1142 241.119 94.0239 246.996 99.7112C250.611 103.212 254.353 106.831 258.753 110.111L258.75 110.115Z" fill="white"/>'
        '<path d="M205.18 119.733C198.869 123.261 192.345 126.908 190.498 131.396C188.675 135.828 191.469 140.757 194.169 145.525C195.503 147.877 196.762 150.103 197.35 152.104C198.672 156.497 201.182 160.46 204.091 165.046C205.251 166.873 206.447 168.763 207.69 170.859C208.263 171.83 208.843 172.84 209.431 173.867C213.358 180.726 217.806 188.501 223.844 189.985C224.618 190.175 225.411 190.265 226.228 190.265C230.779 190.265 235.997 187.507 241.893 184.389C244.344 183.09 246.882 181.752 249.522 180.529C252.983 178.919 258.319 177.198 263.971 175.378C274.758 171.901 286.981 167.958 290.213 163.431L290.288 163.329V163.289C294.783 156.856 294.503 149.851 289.404 141.255C286.535 136.471 277.635 132.509 269.027 128.672C263.351 126.142 257.992 123.755 255.296 121.462C254.124 120.475 252.96 119.457 251.835 118.474C246.4 113.722 241.269 109.238 235.266 108.074C228.857 106.835 220.719 109.377 212.936 115.048C210.848 116.572 208.097 118.107 205.184 119.733H205.18ZM231.923 108.552C233.029 108.552 234.094 108.65 235.112 108.848C240.906 109.969 245.962 114.385 251.314 119.066C252.443 120.053 253.607 121.071 254.783 122.061C257.562 124.43 262.973 126.841 268.703 129.391C276.802 132.998 285.982 137.087 288.721 141.657C293.667 150.001 293.935 156.761 289.566 162.934L289.495 163.037V163.072C286.302 167.347 274.316 171.214 263.726 174.628C258.051 176.46 252.695 178.184 249.191 179.814C246.53 181.046 243.985 182.392 241.522 183.694C234.71 187.297 228.829 190.408 224.03 189.223C218.323 187.822 213.962 180.201 210.114 173.48C209.526 172.45 208.945 171.435 208.369 170.461C207.122 168.357 205.922 166.463 204.758 164.627C201.881 160.089 199.394 156.169 198.108 151.883C197.496 149.795 196.213 147.534 194.855 145.138C192.247 140.536 189.551 135.776 191.228 131.699C192.969 127.465 199.663 123.723 205.567 120.424C208.499 118.786 211.27 117.235 213.397 115.687C219.752 111.058 226.319 108.556 231.923 108.556V108.552Z" fill="white"/>'
        '<path d="M232.764 167.579C233.092 167.579 233.423 167.552 233.759 167.492C235.906 167.11 237.919 165.432 240.05 163.656C241.336 162.583 242.667 161.474 244.079 160.613C245.591 159.69 247.264 159.027 248.737 158.439C250.469 157.748 252.02 157.132 253.031 156.24V156.611L253.761 155.431C254.724 153.872 254.231 151.725 253.658 149.239C253.362 147.956 253.058 146.63 252.908 145.233C252.754 143.875 252.743 142.45 252.735 141.077C252.715 138.219 252.699 135.52 251.42 133.574C249.309 130.432 244.048 129.627 240.275 129.296C236.529 128.972 231.252 128.858 228.663 131.628C227.156 133.243 226.631 135.709 226.074 138.322C225.774 139.731 225.467 141.191 224.989 142.498C224.401 144.108 223.537 145.529 222.704 146.902C221.658 148.623 220.671 150.245 220.355 152.037C219.831 154.969 221.105 158.514 223.951 162.026C225.364 163.771 228.896 167.579 232.764 167.579ZM221.129 152.175C221.421 150.529 222.372 148.966 223.375 147.313C224.227 145.908 225.111 144.455 225.727 142.77C226.224 141.412 226.54 139.924 226.844 138.488C227.377 135.986 227.878 133.621 229.236 132.169C230.649 130.657 233.111 129.923 236.881 129.923C237.891 129.923 239 129.975 240.204 130.081C243.815 130.397 248.843 131.151 250.761 134.008C251.91 135.753 251.926 138.342 251.941 141.081C251.949 142.478 251.957 143.922 252.119 145.32C252.273 146.76 252.581 148.11 252.885 149.416C253.382 151.571 253.812 153.45 253.232 154.737L253.082 154.977C252.36 156.146 250.544 156.868 248.441 157.705C246.937 158.304 245.232 158.979 243.661 159.938C242.201 160.83 240.847 161.959 239.537 163.048C237.488 164.753 235.554 166.368 233.613 166.715C229.78 167.39 226.003 163.313 224.555 161.529C221.859 158.198 220.64 154.879 221.125 152.175H221.129Z" fill="white"/>';
    
    string constant DEFS = '<defs>'
                '<path id="borderPath" d="M36,16 L384,16 A10,10 0 0 1 404,36 L404,524 A10,10 0 0 1 384,544 L36,544 A10,10 0 0 1 16,524 L16,36 A10,10 0 0 1 36,16 z" fill="none"/>'
                '<filter id="filter0_f_2943_19260" x="-357" y="-574" width="1370" height="1370" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">'
                '<feFlood flood-opacity="0" result="BackgroundImageFix"/>'
                '<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>'
                '<feGaussianBlur stdDeviation="202" result="effect1_foregroundBlur_2943_19260"/>'
                '</filter>'
                '<filter id="filter1_f_2943_19260" x="-689" y="-166" width="1446" height="1446" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">'
                '<feFlood flood-opacity="0" result="BackgroundImageFix"/>'
                '<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>'
                '<feGaussianBlur stdDeviation="202" result="effect1_foregroundBlur_2943_19260"/>'
                '</filter>'
                '<clipPath id="clip0_2943_19260">'
                '<rect width="420" height="560" rx="20" fill="white"/>'
                '</clipPath>'
                '<clipPath id="clip1_2943_19260">'
                '<rect width="682" height="682" fill="white"/>'
                '</clipPath>'
                '</defs>';
    
    string constant BEGIN_ANIMATION = '<g transform="translate(0,0)">'
                '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">'
                '<textPath href="#borderPath" startOffset="0%">'
                '<animate attributeName="startOffset" '
                'from="-100%" to="0%" begin="0s" dur="30s" '
                'repeatCount="indefinite" />'
                'Pool &#x2022;&#xa0;';

    struct SVGParams {
        string xToken;
        string yToken;
        string xTokenSymbol;
        string yTokenSymbol;
        string feeTier;
        uint256 tokenId;
        string poolAddress;
        string color0;
        string color1;
        string x1;
        string y1;
        string x2;
        string y2;
    }

    /// @notice Generate the SVG associated with a Uniswap v4 NFT
    /// @param params The SVGParams struct containing the parameters for the SVG
    /// @return svg The SVG string associated with the NFT
    function generateSVG(SVGParams memory params) external pure returns (string memory svg) {
        return string(
            abi.encodePacked(
                getMainCard(params),
                generateXToken(params),
                generateYToken(params),
                DEFS,
                generateBorderTextAndBackground(params)
            )
        );
    }

    function getMainCard(SVGParams memory params) private pure returns (string memory svg) {
        return string(
            abi.encodePacked(
                generateSVGDefsCoordinatesAndColor1(params),
                generateSVGDefsCoordinatesAndColor2(params),
                SVG_LINE_STARTER,
                SVGLinesPart1.getSVGLinesPart1(),
                SVGLinesPart2.getSVGLinesPart2(),
                SVGLinesPart3.getSVGLinesPart3(),
                generateSVGTokenPairHeader(params),
                generateFeeTier(params),
                generateSVGTokenId(params)
            )
        );
    }

    function generateSVGTokenPairHeader(SVGParams memory params) private pure returns (string memory svg) {
        string memory pairText = string(abi.encodePacked(params.xTokenSymbol, " / ", params.yTokenSymbol));
        uint width = (bytes(pairText).length) * 18 + 20;
        svg = string(
            abi.encodePacked(
                '<rect x="48" y="56" width="',
                width.toString(),
                '" height="44" rx="12" fill="black" fill-opacity="0.6"/>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="28" letter-spacing="0px"><tspan x="64" y="87.6592">',
                pairText,
                '</tspan></text>'
            )
        );
    }

    function generateFeeTier(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="96" letter-spacing="0px"><tspan x="48" y="193.117">',
                params.feeTier,
                '</tspan></text>'
            )
        );
    }

    function generateSVGTokenId(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<path d="M48 384C48 377.373 53.3726 372 60 372H164C170.627 372 176 377.373 176 384V396C176 402.627 170.627 408 164 408H60C53.3726 408 48 402.627 48 396V384Z" fill="black" fill-opacity="0.6"/>',
                '<text fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0px"><tspan x="80.0195" y="396.899"> #',
                params.tokenId.toString(),
                '</tspan></text>',
                '<text fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0px"><tspan x="60" y="396.899">ID</tspan></text>'
            )
        );
    }

    function generateXToken(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<path d="M48 432C48 425.373 53.3726 420 60 420H338C344.627 420 350 425.373 350 432V444C350 450.627 344.627 456 338 456H60C53.3726 456 48 450.627 48 444V432Z" fill="black" fill-opacity="0.6"/>',
                '<text transform="translate(60 444)" fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0.5px"><tspan x="0" y="0">',
                params.xTokenSymbol,
                '</tspan></text>',
                '<text transform="translate(180 444)" fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0.5px"><tspan x="0" y="0">',
                abi.encodePacked(substring(params.xToken, 0, 6), '...', substring(params.xToken, 36, 42)),
                '</tspan></text>'
            )
        );
    }

    function generateYToken(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<path d="M48 480C48 473.373 53.3726 468 60 468H338C344.627 468 350 473.373 350 480V492C350 498.627 344.627 504 338 504H60C53.3726 504 48 498.627 48 492V480Z" fill="black" fill-opacity="0.6"/>',
                '<text transform="translate(60 492)" fill="#959595" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0.5px"><tspan x="0" y="0">',
                params.yTokenSymbol,
                '</tspan></text>'
                '<text transform="translate(180 492)" fill="white" xml:space="preserve" style="white-space: pre" font-family="Helvetica, Arial, sans-serif" font-size="20" letter-spacing="0.5px"><tspan x="0" y="0">',
                abi.encodePacked(substring(params.yToken, 0, 6), '...', substring(params.yToken, 36, 42)),
                '</tspan></text></g>'
            )
        );
    }

    function generateBorderTextAndBackground(SVGParams memory params) public pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g transform="translate(0,0)">',
                '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">',
                '<textPath href="#borderPath" startOffset="0%">',
                '<animate attributeName="startOffset" ',
                'from="-100%" to="0%" begin="0s" dur="30s" ',
                'repeatCount="indefinite" />',
                'Pool &#x2022;&#xa0;',
                params.poolAddress,
                '</textPath>',
                '</text>',
                '<text font-family="Helvetica, Arial, sans-serif" font-size="14" fill="#F8F8F8" letter-spacing="0.5px">',
                '<textPath href="#borderPath" startOffset="0%">',
                '<animate attributeName="startOffset" ',
                'from="0%" to="100%" ',
                'begin="0s" dur="30s" ',
                'repeatCount="indefinite" />',
                'Pool &#x2022;&#xa0;',
                params.poolAddress,
                '</textPath>',
                '</text>',
                '</g>',
                "</svg>"
            )
        );
    }

    /// @notice Generate the SVG defs that create the color scheme for the SVG
    /// @param params The SVGParams struct containing the parameters to generate the SVG defs
    /// @return svg The SVG defs string
    function generateSVGDefsCoordinatesAndColor1(SVGParams memory params) private pure returns (string memory svg) { 
        svg = string(
            abi.encodePacked(
                '<svg width="420" height="560" viewBox="0 0 420 560" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<g clip-path="url(#clip0_2943_19260)">',
                '<rect width="420" height="560" rx="20" fill="black"/>',
                '<g filter="url(#filter0_f_2943_19260)">',
                '<circle cx="',
                params.x1,
                '" cy="',
                params.y1,
                '" r="281" fill="#',
                params.color0,
                '"/></g>'
            )
        );
    }

    function generateSVGDefsCoordinatesAndColor2(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g opacity="0.8" filter="url(#filter1_f_2943_19260)">',
                '<circle cx="',
                params.x2,
                '" cy="',
                params.y2,
                '" r="319" fill="#',
                params.color1,
                '"/></g>'
            )
        );
    }

    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}