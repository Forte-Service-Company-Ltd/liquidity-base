// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @dev File that contains all the errors for the project
 * @notice this file should be then imported in the contract files to use the errors.
 */

/**** CofNErrors ****/
error ResultBelowPMin();
error XnCannotBeZero();
error BnCannotBeZero();
error NegativeValue();
error DnTooLarge();

/**** PythonUtilErrors ****/
error bytesLargerThanUint256();
error diffGreaterThanUint256();

/**** EquationErrors****/
error DivideByZero();

/**** PoolErrors ****/
error YTokenNotAllowed();
error XandYTokensAreTheSame();
error BeyondLiquidity();
error LPFeeAboveMax(uint16 proposedFee, uint16 maxFee);
error YTokenDecimalsGT18();
error XTokenDecimalsIsNot18();
error MaxTotalSupplyTooLarge();
error MaxTotalSupplyCannotBeZero();
error PriceRangeNotWideEnough();
error PriceRangeTooLarge();
error lowerPriceTooLow();
error ZeroValueNotAllowed();
error TransferFailed();
error CTooSmall(uint256 C);
error CTooLarge();
error LiquidityRemovalForbidden();
error InvalidToken();
error XOutOfBounds(uint256 howMuch);
error NotEnoughCollateral();
error ProtocolFeeAboveMax(uint16 proposedFee, uint16 maxFee);
error NotProtocolFeeCollector();
error NotProposedProtocolFeeCollector();
error NoProtocolFeeCollector();
error KTooLow();
error KTooHigh();
error VTooLow();
error VTooHigh();
error CannotDepositInactiveLiquidity();
error AllLiquidityCannotBeInactive();

/**** URQTBCErrors ****/
error VOutOfBounds();

/**** PoolFactoryErrors ****/
error NotAnAllowedDeployer();

/**** Input Errors ****/
error ZeroAddress();

/**** ERC721 Errors ****/
error URIQueryForNonexistentToken();
