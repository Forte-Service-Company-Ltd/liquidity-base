// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {FactoryBase} from "src/factory/base/FactoryBase.sol";
import {AllowList} from "src/allowList/AllowList.sol";
import {GenericERC20} from "src/example/ERC20/GenericERC20.sol";
import {GenericERC20FixedSupply} from "src/example/ERC20/GenericERC20FixedSupply.sol";
import {TwentyTwoDecimalERC20} from "src/example/ERC20/TwentyTwoDecimalERC20.sol";
import {SixDecimalERC20} from "src/example/ERC20/SixDecimalERC20.sol";
import {FeeOnTransferERC20} from "src/example/ERC20/FeeOnTransferERC20.sol";
import {TwentyTwoDecimalERC20} from "src/example/ERC20/TwentyTwoDecimalERC20.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TestCommon} from "test/util/TestCommon.sol";
import {TestModifiers} from "test/util/TestModifiers.sol";

/**
 * @title Test Common Foundry
 * @dev This contract is an abstract template to be reused by all the Foundry tests. NOTE: function prefixes and their usages are as follows:
 * setup = set to proper user, deploy contracts, set global variables, reset user
 * create = set to proper user, deploy contracts, reset user, return the contract
 * _create = deploy contract, return the contract
 */
abstract contract TestCommonSetup is TestCommon, TestModifiers {
    enum ALTBCInputOption { BASE, FORK, PRECISION }
    function _deployFactory() internal virtual {}
    function _getFactoryAddress() internal virtual returns (address) {}
    function _deployPool(address,address,uint16,bool,ALTBCInputOption) internal virtual returns (PoolBase) {}

    function _setUpTokens(uint256 _xTokenSupply) internal startAsAdmin endWithStopPrank {
        xToken = new GenericERC20FixedSupply("x token", "GAME", _xTokenSupply + 1);
        yToken = new GenericERC20("collateral token", "COLL");
        stableCoin = new SixDecimalERC20("stable coin", "USDX");
        highDecimalCoin = new TwentyTwoDecimalERC20("high deciaml coin", "HDEX");
        fotCoin = new FeeOnTransferERC20("FOT Token", "FOT", transferFee);
    }

    function _loadAdminAndAlice() internal startAsAdmin endWithStopPrank {
        GenericERC20(address(yToken)).mint(admin, 1e12 * ERC20_DECIMALS);
        GenericERC20(address(yToken)).mint(alice, 1e12 * ERC20_DECIMALS);
        stableCoin.mint(alice, 1e12 * STABLECOIN_DEC);
        stableCoin.mint(admin, 1e12 * STABLECOIN_DEC);
        fotCoin.mint(admin, 1e20 * ERC20_DECIMALS);
    }

    function _deployAllowLists() internal startAsAdmin endWithStopPrank {
        yTokenAllowList = new AllowList();
        deployerAllowList = new AllowList();
    }

    function _setupAllowLists() internal startAsAdmin endWithStopPrank {
        yTokenAllowList.addToAllowList(address(yToken));
        yTokenAllowList.addToAllowList(address(stableCoin));
        yTokenAllowList.addToAllowList(address(highDecimalCoin));
        deployerAllowList.addToAllowList(address(admin));
    }

    function _setupFactory(address factory) internal startAsAdmin endWithStopPrank {
        FactoryBase(factory).setDeployerAllowList(address(deployerAllowList));
        FactoryBase(factory).setYTokenAllowList(address(yTokenAllowList));
        FactoryBase(factory).proposeProtocolFeeCollector(address(0xb0b));
        vm.startPrank(address(0xb0b));
        FactoryBase(factory).confirmProtocolFeeCollector();
    }

    function _approvePool(PoolBase poolRet, bool usdt) internal startAsAdmin endWithStopPrank {
        IERC20 _xToken = IERC20(poolRet.xToken());
        IERC20 _yToken = IERC20(poolRet.yToken());
        _xToken.approve(address(poolRet), X_TOKEN_MAX_SUPPLY);
        if (!usdt) {
            _yToken.approve(address(poolRet), _yToken.balanceOf(admin));
        }
        vm.startPrank(alice);
        _xToken.approve(address(poolRet), X_TOKEN_MAX_SUPPLY);
        if (!usdt) {
            _yToken.approve(address(poolRet), _yToken.balanceOf(alice));
        }
    }

    function _addInitialLiquidity(PoolBase poolRet, uint _amount) internal startAsAdmin endWithStopPrank {
        PoolBase(address(poolRet)).addXSupply(_amount);
    }

    function _setupPool(bool withStableCoin) internal endWithStopPrank returns (PoolBase poolRet) {
        _setUpTokens(X_TOKEN_MAX_SUPPLY);
        _loadAdminAndAlice();
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();
        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        poolRet = _deployPool(_xTokenAddress, yTokenAddress, 30, true, ALTBCInputOption.BASE);
        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, false);
        _addInitialLiquidity(poolRet, X_TOKEN_MAX_SUPPLY);
        amountMinBound = 2;
    }

    function _setupPoolWithFee(bool withStableCoin, uint16 fee) internal endWithStopPrank returns (PoolBase poolRet) {
        poolRet = _setupPoolWithFee(withStableCoin, address(xToken), fee);
    }

    function _setupPoolWithFee(
        bool withStableCoin,
        address _xTokenAddress,
        uint16 fee
    ) internal endWithStopPrank returns (PoolBase poolRet) {
        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        poolRet = _deployPool(_xTokenAddress, yTokenAddress,  fee, true, ALTBCInputOption.BASE);
        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, false);
        _addInitialLiquidity(poolRet, X_TOKEN_MAX_SUPPLY);
    }

    function _setupPoolForkTest(
        address owner,
        address _yTokenAddress,
        uint16 fee,
        bool usdt
    ) internal endWithStopPrank returns (PoolBase poolRet) {
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();

        GenericERC20FixedSupply xTokenWithFee = new GenericERC20FixedSupply("Fee token", "FEE", 10e3 * ERC20_DECIMALS);

        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        poolRet = PoolBase(
            _deployPool(
                address(xTokenWithFee),
                yTokenAddress,
                0,
                true,
                ALTBCInputOption.FORK
            )
        );

        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, usdt);
        _addInitialLiquidity(poolRet, _tbcType, 10e3 * ERC20_DECIMALS);

        (owner, fee);
    }

    function _setupStressTestPool(bool withStableCoin) internal endWithStopPrank returns (PoolBase poolRet) {
        // the token supply is the same value used in the stress test simulation and must match
        uint256 maxX = 10e3 * ERC20_DECIMALS;
        _setUpTokens(maxX);
        _loadAdminAndAlice();
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();
   
        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        // the pool config values are the same config values used in the stress test simulation and must match
        /// fee: 0.0%, supply: 10K tokens, y-intersect: 10, minPrice: 1, maxPrice: 100
        poolRet = _deployPool(_xTokenAddress, yTokenAddress, 0, true, ALTBCInputOption.FORK);

        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, false);
        _addInitialLiquidity(poolRet, _tbcType, 10e3 * ERC20_DECIMALS);
    }

    function _setupPrecisionPools(
        uint256 maxSupply,
        uint16 fee
    ) internal endWithStopPrank returns (PoolBase wadPool, PoolBase sixDecimalPool) {
        _setUpTokens(maxSupply);
        _loadAdminAndAlice();
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();
        urqtbcInput._maxXTokenSupply = maxSupply;

        wadPool = _deployPool(_xTokenAddress, _yTokenAddress,fee, true, ALTBCInputOption.PRECISION);

        vm.startPrank(admin);
        wadPool.enableSwaps(true);
        _approvePool(wadPool, false);
        _addInitialLiquidity(wadPool, _tbcType, maxSupply);
        vm.stopPrank();

        _setUpTokens(maxSupply);
        vm.startPrank(admin);
        yTokenAllowList.addToAllowList(address(stableCoin));
        sixDecimalPool = _deployPool(_xTokenAddress, address(stableCoin),fee, true, ALTBCInputOption.PRECISION);

        _loadAdminAndAlice();
        vm.startPrank(admin);

        sixDecimalPool.enableSwaps(true);
        _approvePool(sixDecimalPool, false);
        _addInitialLiquidity(sixDecimalPool, maxSupply);
    }

    function _setupPoolPartialFunding(bool withStableCoin) internal endWithStopPrank returns (PoolBase poolRet) {
        _setUpTokens(X_TOKEN_MAX_SUPPLY);
        _loadAdminAndAlice();
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();
        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        poolRet = _deployPool(_xTokenAddress, yTokenAddress, 30, true, ALTBCInputOption.BASE);
        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, false);
        _addInitialLiquidity(poolRet, X_TOKEN_MAX_SUPPLY / 2);
    }

    function _setupFOTPool(bool withStableCoin) internal endWithStopPrank returns (PoolBase poolRet) {
        _setUpTokens(X_TOKEN_MAX_SUPPLY);
        _loadAdminAndAlice();
        _deployFactory();
        _deployAllowLists();
        _setupFactory(_getFactoryAddress());
        _setupAllowLists();
        address yTokenAddress = withStableCoin ? address(stableCoin) : address(yToken);
        poolRet = _deployPool(address(fotCoin), yTokenAddress, 30, true, ALTBCInputOption.BASE);
        vm.startPrank(admin);
        poolRet.enableSwaps(true);
        _approvePool(poolRet, false);
        _addInitialLiquidity(poolRet, X_TOKEN_MAX_SUPPLY);
    }
}
