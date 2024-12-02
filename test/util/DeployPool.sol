// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ALTBCFactory} from "src/factory/altbc/ALTBCFactory.sol";
import {URQTBCFactory} from "src/factory/urqtbc/URQTBCFactory.sol";
import {ALTBCInput} from "src/common/TBC.sol";
import {PoolBase} from "src/amm/base/PoolBase.sol";
import {TestModifiers} from "test/util/TestModifiers.sol";
import {ALTBCDef, ALTBCInput, URQTBCInput, TBCType} from "src/common/TBC.sol";

/**
 * @title DeployPool
 * @dev This contract holds the helper function _deployPool and all of it overloaded versions. The overloaded versions are used to have some
 * default values on the function signature so it can simplify the API for some tests.
 */
contract DeployPool is TestModifiers {
    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        ALTBCInput memory _altbcInput,
        bool _liquidityRemovalAllowed,
        bool withStableCoin
    ) internal startAsAdmin endWithStopPrank returns (PoolBase poolRet) {
        poolRet = PoolBase(
            altbcFactory.createPool(
                _xTokenAddress,
                withStableCoin ? address(stableCoin) : address(yToken),
                _fee,
                _altbcInput,
                _liquidityRemovalAllowed
            )
        );
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        URQTBCInput memory _urqtbcInput,
        bool _liquidityRemovalAllowed,
        bool withStableCoin
    ) internal startAsAdmin endWithStopPrank returns (PoolBase poolRet) {
        poolRet = PoolBase(
            urqtbcFactory.createPool(
                _xTokenAddress,
                withStableCoin ? address(stableCoin) : address(yToken),
                _fee,
                _urqtbcInput,
                _liquidityRemovalAllowed
            )
        );
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        bool _liquidityRemovalAllowed,
        bool withStableCoin,
        TBCType _tbcType
    ) internal returns (PoolBase poolRet) {
        poolRet = _tbcType == TBCType.ALTBC
            ? _deployPool(_xTokenAddress, _fee, altbcInput, _liquidityRemovalAllowed, withStableCoin)
            : _deployPool(_xTokenAddress, _fee, urqtbcInput, _liquidityRemovalAllowed, withStableCoin);
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        bool _liquidityRemovalAllowed,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        poolRet = _deployPool(_xTokenAddress, _fee, altbcInput, _liquidityRemovalAllowed, withStableCoin);
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        URQTBCInput memory _urqtbcInput,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        poolRet = _deployPool(_xTokenAddress, _fee, _urqtbcInput, true, withStableCoin);
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 _fee,
        ALTBCInput memory _altbcInput,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        poolRet = _deployPool(_xTokenAddress, _fee, _altbcInput, true, withStableCoin);
    }

    function _deployPool(
        uint16 _fee,
        URQTBCInput memory _urqtbcInput,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        poolRet = _deployPool(address(xToken), _fee, _urqtbcInput, withStableCoin);
    }

    function _deployPool(
        uint16 _fee,
        ALTBCInput memory _altbcInput,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        poolRet = _deployPool(address(xToken), _fee, _altbcInput, withStableCoin);
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 fee,
        bool withStableCoin,
        TBCType _tbcType
    ) internal returns (PoolBase poolRet) {
        /// fee: .3%, y-intersect: 0.000001, minPrice: 0.1, maxPrice: 10
        poolRet = _tbcType == TBCType.ALTBC
            ? _deployPool(_xTokenAddress, fee, altbcInput, withStableCoin)
            : _deployPool(_xTokenAddress, fee, urqtbcInput, withStableCoin);
    }

    function _deployPool(
        address _xTokenAddress,
        uint16 fee,
        bool withStableCoin
    ) internal returns (PoolBase poolRet) {
        /// fee: .3%, y-intersect: 0.000001, minPrice: 0.1, maxPrice: 10
        poolRet = _deployPool(_xTokenAddress, fee, altbcInput, withStableCoin);
    }

    function _deployPool(uint16 fee, bool withStableCoin, TBCType _tbcType) internal returns (PoolBase poolRet) {
        /// fee: .3%, y-intersect: 0.000001, minPrice: 0.1, maxPrice: 10
        poolRet = _tbcType == TBCType.ALTBC
            ? _deployPool(fee, altbcInput, withStableCoin)
            : _deployPool(fee, urqtbcInput, withStableCoin);
    }

    function _deployPool(uint16 fee, bool withStableCoin) internal returns (PoolBase poolRet) {
        /// fee: .3%, y-intersect: 0.000001, minPrice: 0.1, maxPrice: 10
        poolRet = _deployPool(fee, altbcInput, withStableCoin);
    }
}
