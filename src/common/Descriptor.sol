// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

import {SVG} from "src/common/SVGParts/SVG.sol";
import {HexStrings} from "src/common/SVGParts/HexStrings.sol";

library Descriptor {
    using Strings for uint256;
    using HexStrings for uint256;

    uint256 constant sqrt10X128 = 1076067327063303206878105757264492625226;

    struct ConstructTokenURIParams {
        uint256 tokenId;
        address xTokenAddress;
        address yTokenAddress;
        string xTokenSymbol;
        string yTokenSymbol;
        uint16 fee;
        address poolManager;
    }

    /// @notice Constructs the token URI for a Uniswap v4 NFT
    /// @param params Parameters needed to construct the token URI
    /// @return The token URI as a string
    function constructTokenURI(ConstructTokenURIParams memory params) external pure returns (string memory) {
        string memory name = generateName(params, feeToPercentString(params.fee, params.tokenId));
        string memory descriptionPartOne = generateDescriptionPartOne(
            escapeSpecialCharacters(params.xTokenSymbol),
            escapeSpecialCharacters(params.yTokenSymbol),
            addressToString(params.poolManager)
        );
        string memory descriptionPartTwo = generateDescriptionPartTwo(
            params.tokenId.toString(),
            escapeSpecialCharacters(params.xTokenSymbol),
            params.yTokenAddress == address(0) ? "Native" : addressToString(params.yTokenAddress),
            params.xTokenAddress == address(0) ? "Native" : addressToString(params.xTokenAddress),
            feeToPercentString(params.fee, params.tokenId)
        );

        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name,
                            '", "description":"',
                            descriptionPartOne,
                            descriptionPartTwo,
                            '", "image": "data:image/svg+xml;base64,',
                            image,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /// @notice Escapes special characters in a string if they are present
    function escapeSpecialCharacters(string memory symbol) internal pure returns (string memory) {
        bytes memory symbolBytes = bytes(symbol);
        uint8 specialCharCount = 0;
        // count the amount of double quotes, form feeds, new lines, carriage returns, or tabs in the symbol
        for (uint8 i = 0; i < symbolBytes.length; i++) {
            if (isSpecialCharacter(symbolBytes[i])) {
                specialCharCount++;
            }
        }
        if (specialCharCount > 0) {
            // create a new bytes array with enough space to hold the original bytes plus space for the backslashes to escape the special characters
            bytes memory escapedBytes = new bytes(symbolBytes.length + specialCharCount);
            uint256 index;
            for (uint8 i = 0; i < symbolBytes.length; i++) {
                // add a '\' before any double quotes, form feeds, new lines, carriage returns, or tabs
                if (isSpecialCharacter(symbolBytes[i])) {
                    escapedBytes[index++] = "\\";
                }
                // copy each byte from original string to the new array
                escapedBytes[index++] = symbolBytes[i];
            }
            return string(escapedBytes);
        }
        return symbol;
    }

    /// @notice Generates the first part of the description for a Uniswap v4 NFT
    /// @param xTokenSymbol The symbol of the x token
    /// @param yTokenSymbol The symbol of the y token
    /// @param poolManager The address of the pool manager
    /// @return The first part of the description
    function generateDescriptionPartOne(
        string memory xTokenSymbol,
        string memory yTokenSymbol,
        string memory poolManager
    ) private pure returns (string memory) {
        // displays quote currency first, then base currency
        return string(
            abi.encodePacked(
                "This NFT represents a liquidity position in a ALTBC ",
                xTokenSymbol,
                "-",
                yTokenSymbol,
                " pool. ",
                "The owner of this NFT can modify or redeem the position.\\n",
                "\\nPool Manager Address: ",
                poolManager,
                "\\n",
                yTokenSymbol
            )
        );
    }

    /// @notice Generates the second part of the description for a Uniswap v4 NFTs
    /// @param tokenId The token ID
    /// @param baseCurrencySymbol The symbol of the base currency
    /// @param quoteCurrency The address of the quote currency
    /// @param baseCurrency The address of the base currency
    /// @param feeTier The fee tier of the pool
    /// @return The second part of the description
    function generateDescriptionPartTwo(
        string memory tokenId,
        string memory baseCurrencySymbol,
        string memory quoteCurrency,
        string memory baseCurrency,
        string memory feeTier
    ) private pure returns (string memory) {
        return string(
            abi.encodePacked(
                " Address: ",
                quoteCurrency,
                "\\n",
                baseCurrencySymbol,
                " Address: ",
                baseCurrency,
                "\\nFee Tier: ",
                feeTier,
                "\\nToken ID: ",
                tokenId,
                "\\n\\n",
                unicode"⚠️ DISCLAIMER: Due diligence is imperative when assessing this NFT. Make sure currency addresses match the expected currencies, as currency symbols may be imitated."
            )
        );
    }

    /// @notice Generates the name for a Uniswap v4 NFT
    /// @param params Parameters needed to generate the name
    /// @param feeTier The fee tier of the pool
    /// @return The name of the NFT
    function generateName(ConstructTokenURIParams memory params, string memory feeTier)
        private
        pure
        returns (string memory)
    {
        // image shows in terms of price, ie quoteCurrency/baseCurrency
        return string(
            abi.encodePacked(
                "ALTBC - ",
                feeTier,
                " - ",
                escapeSpecialCharacters(params.xTokenSymbol),
                "/",
                escapeSpecialCharacters(params.yTokenSymbol)
            )
        );
    }

    /// @notice Absolute value of a signed integer
    /// @param x The signed integer
    /// @return The absolute value of x
    function abs(int256 x) private pure returns (uint256) {
        return uint256(x >= 0 ? x : -x);
    }

    function substring(string memory str, uint256 startIndex, uint256 endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    /// @notice Converts fee amount in hundredths of a percent (where 100 = 1%) to decimal string with percent sign
    /// @param fee fee amount as uint16 where 100 = 1%, 1 = 0.01%
    /// @return fee as a decimal string with percent sign
    function feeToPercentString(uint16 fee, uint256 tokenId) internal pure returns (string memory) {
        if(tokenId == 1) {
            return "INACTIVE";
        }

        if (fee == 0) { // this is to handle the edge case of the first inactive LP position where it will not earn trading fees
            return "0%";
        }
        
        // For values less than 100 (< 1%), we need to show with leading zero
        if (fee < 100) {
            // Prepare for decimal < 1%
            if (fee < 10) {
                // Format as "0.0X%" for single-digit values (e.g., 5 -> "0.05%")
                return string(abi.encodePacked("0.0", uint256(fee).toString(), "%"));
            } else {
                // Format as "0.XX%" for double-digit values (e.g., 50 -> "0.50%")
                return string(abi.encodePacked("0.", uint256(fee).toString(), "%"));
            }
        } else {
            // Value is >= 1%
            uint16 whole = fee / 100; // Integer part
            uint16 fraction = fee % 100; // Fractional part
            
            if (fraction == 0) {
                // No decimal places needed (e.g., 500 -> "5%")
                return string(abi.encodePacked(uint256(whole).toString(), ".00%"));
            } else if (fraction < 10) {
                // Need leading zero in fraction (e.g., 501 -> "5.01%")
                return string(abi.encodePacked(uint256(whole).toString(), ".0", uint256(fraction).toString(), "%"));
            } else {
                // No leading zero needed (e.g., 550 -> "5.50%")
                return string(abi.encodePacked(uint256(whole).toString(), ".", uint256(fraction).toString(), "%"));
            }
        }
    }

    function addressToString(address addr) internal pure returns (string memory) {
        return (uint256(uint160(addr))).toHexString(20);
    }

    /// @notice Generates the SVG image for a Uniswap v4 NFT
    /// @param params Parameters needed to generate the SVG image
    /// @return svg The SVG image as a string
    function generateSVGImage(ConstructTokenURIParams memory params) internal pure returns (string memory svg) {
        SVG.SVGParams memory svgParams = SVG.SVGParams({
            xToken: addressToString(params.xTokenAddress),
            yToken: addressToString(params.yTokenAddress),
            xTokenSymbol: params.xTokenSymbol,
            yTokenSymbol: params.yTokenSymbol,
            feeTier: feeToPercentString(params.fee, params.tokenId),
            poolAddress: addressToString(params.poolManager),
            tokenId: params.tokenId,
            color0: currencyToColorHex(uint256(uint160(params.xTokenAddress)), 136),
            color1: currencyToColorHex(uint256(uint160(params.yTokenAddress)), 136),
            x1: scale(getCircleCoord(uint256(uint160(params.xTokenAddress)), 16, params.tokenId), 0, 255, 16, 274),
            y1: scale(getCircleCoord(uint256(uint160(params.yTokenAddress)), 16, params.tokenId), 0, 255, 100, 484),
            x2: scale(getCircleCoord(uint256(uint160(params.xTokenAddress)), 32, params.tokenId), 0, 255, 16, 274),
            y2: scale(getCircleCoord(uint256(uint160(params.yTokenAddress)), 32, params.tokenId), 0, 255, 100, 484)
        });

        return SVG.generateSVG(svgParams);
    }

    function isSpecialCharacter(bytes1 b) private pure returns (bool) {
        return b == '"' || b == "\u000c" || b == "\n" || b == "\r" || b == "\t";
    }

    function scale(uint256 n, uint256 inMn, uint256 inMx, uint256 outMn, uint256 outMx)
        private
        pure
        returns (string memory)
    {
        return ((n - inMn) * (outMx - outMn) / (inMx - inMn) + outMn).toString();
    }

    function currencyToColorHex(uint256 currency, uint256 offset) internal pure returns (string memory str) {
        return string((currency >> offset).toHexStringNoPrefix(3));
    }

    function getCircleCoord(uint256 currency, uint256 offset, uint256 tokenId) internal pure returns (uint256) {
        return (sliceCurrencyHex(currency, offset) * tokenId) % 255;
    }

    function sliceCurrencyHex(uint256 currency, uint256 offset) internal pure returns (uint256) {
        return uint256(uint8(currency >> offset));
    }
}