// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {packedFloat} from "../amm/mathLibs/MathLibs.sol";
/**
 * @dev File that contains all the events for the project
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve @palmerg4
 * @notice this file should be then inherited in the contract interfaces to use the events.
 */



/**
 * @dev events common for the pool and the factory contract
 * @notice any change in this interface most likely means a breaking change with monitoring services
 */
interface CommonEvents {
    enum FeeCollectionType {
        LP,
        PROTOCOL
    }
    event ProtocolFeeCollectorProposed(address indexed _collector);
    event ProtocolFeeCollectorConfirmed(address indexed _collector);
    event FeeSet(FeeCollectionType indexed _feeType, uint16 indexed _fee);
}

/**
 * @dev events for the pool contract
 * @notice any change in this interface most likely means a breaking change with monitoring services
 */
interface IPoolEvents is CommonEvents {
    event FeesCollected(FeeCollectionType indexed _feeType, address indexed _collector, uint256 indexed _amount);
    event Swap(address indexed _tokenIn, uint256 indexed _amountIn, uint256 indexed _amountOut, uint256 _minOut, address _recipient);
    event RevenueWithdrawn(address indexed _collector, uint256 indexed tokenId, uint256 indexed _amount, address _recipient);
    event LiquidityWithdrawn(address lp, uint indexed tokenId, uint256 indexed amountOutXToken, uint256 indexed amountOutYToken, uint256 revenue, address _recipient);
    event LPTokenUpdated(uint256 indexed tokenId, packedFloat wj, packedFloat hn);
    event FeesGenerated(uint256 indexed lpFee, uint256 indexed protocolFee);
}

/**
 * @dev events for the pool-factory contract
 * @notice any change in this interface most likely means a breaking change with monitoring services
 */
interface IFactoryEvents is CommonEvents {
    event PoolCreated(address indexed _pool);
    event SetYTokenAllowList(address indexed _allowedList);
    event SetDeployerAllowList(address indexed _allowedList);
}

interface IAllowListEvents {
    event AllowListDeployed();
    event AddressAllowed(address indexed _address, bool indexed _allowed);
}
