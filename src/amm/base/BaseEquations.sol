// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import {MathLibs} from "src/amm/mathLibs/MathLibs.sol";

/**
 * @title Equations used by multiple TBC types
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 */
library BaseEquations {
    using MathLibs for uint256;

    /**
     * @dev This function calculates the last revenue claim to be stored in the associated LPToken variable rj. The result will be a WAD value.
     * @notice The result for last revenue claim will be in WAD ** 2.
     * @param hn The revenue parameter. Expected to be in WAD ** 2.
     * @param wj The share of the pool's liquidity the associated LPToken represents. Expected to be a WAD value.
     * @param r_hat The current last revenue claim value of the associated LPToken. 
     * @param w_hat The current liquidity amount of the associated LPToken. Expected to be a WAD value.
     */
    function calculateLastRevenueClaim(uint256 hn, uint256 wj, uint256 r_hat, uint256 w_hat) internal pure returns(uint256 result) {
        // hn * wj
        (uint256 firstTermLo, uint256 firstTermHi) = hn.mul256x256(wj); // WAD ** 3
        // r_hat * w_hat
        uint256 secondTerm = r_hat * w_hat; // WAD ** 2
        // Bring secondTerm up to uint512 and WAD ** 3
        (uint256 secondTermLo, uint256 secondTermHi) = secondTerm.mul256x256(MathLibs.WAD); // WAD ** 3
        // (hn * wj) + (r_hat * w_hat)
        (firstTermLo, firstTermHi) = firstTermLo.add512x512(firstTermHi, secondTermLo, secondTermHi); // WAD ** 3
        // (w_hat + wj)
        secondTerm = w_hat + wj; // WAD
        // (hn * wj) + (r_hat * w_hat) / (w_hat + wj)
        result = firstTermLo.div512x256(firstTermHi, secondTerm * MathLibs.WAD); // WAD
    }
}
