// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "src/common/IErrors.sol";

/**
 * @title Calculator Base Abstract Contract
 * @dev This contract serves as the base for all the calculators.
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve
 */

abstract contract CalculatorBase {
    /**
     * @dev This is the function to retrieve the current spot price of the x token.
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @return sPrice the price in YToken Decimals
     */
    function _spotPrice(uint x) internal view virtual returns (uint256 sPrice);

    /**
     * @dev This function updates the state of the math values of the pool.
     * @param x_old the previous tracker for x
     * @param x_current the current tracker for x value
     */
    function _updateParameters(uint x_old, uint x_current) public virtual;

    /**
     * @dev This function calculates the amount of token X required for the user to purchase a specific amount of Token Y (buy y with x : out perspective).
     * @param _amountOfY desired amount of token Y
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @return amountOfX required amount of token X
     */
    function _calculateAmountOfXRequiredBuyingY(uint256 _amountOfY, uint x) internal view virtual returns (uint256 amountOfX);

    /**
     * @dev This function calculates the amount of token Y required for the user to purchase a specific amount of Token X (buy x with y : out perspective).
     * @param _amountOfX desired amount of token X
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @return amountOfY required amount of token Y
     */
    function _calculateAmountOfYRequiredBuyingX(uint256 _amountOfX, uint x) internal view virtual returns (uint256 amountOfY);

    /**
     * @dev This function calculates the amount of token Y the user will receive when selling token X (sell x for y : in perspective).
     * @param _amountOfX amount of token X to be sold
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @return amountOfY amount of token Y to be received
     */
    function _calculateAmountOfYReceivedSellingX(uint256 _amountOfX, uint x) internal view virtual returns (uint256 amountOfY);

    /**
     * This function calculates the amount of token X the user will receive when selling token Y (sell y for x : in perspective).
     * @param _amountOfY amount of token Y to be sold
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @return amountOfX amount of token X to be received
     */
    function _calculateAmountOfXReceivedSellingY(uint256 _amountOfY, uint x) internal view virtual returns (uint256 amountOfX);

    /**
     * @dev This function cleans the state of the calculator in the case of the pool closing.
     */
    function _clearState() internal virtual;

    /**
     * @dev This function returns the amount of maximum revenue available to be withdrawn by the owner.
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @param R current lifitime revenue claimed
     * @return the maximum revenue available to be withdrawn by the owner
     */
    function _calculateRMax(uint x, uint R) internal view virtual returns (uint256);

    /**
     * @dev This function validates the liquidity addition to ensure it does not exceed the max supply of xToken.
     * @param x tracker value for the net amount of xTokens sold to the public. Bare in mind that this value is offset by initial synthetic trade
     * @param afterBalance the balance of xToken after the addition
     */
    function _validateLiquidityAdd(uint x, uint afterBalance) internal view virtual;
}
