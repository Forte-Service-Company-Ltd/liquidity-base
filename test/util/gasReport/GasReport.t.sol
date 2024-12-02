/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {GasHelpers} from "test/util/gasReport/GasHelpers.sol";
import "src/common/TBC.sol";
import {ALTBCPool} from "src/amm/altbc/ALTBCPool.sol";
import {URQTBCPool} from "src/amm/urqtbc/URQTBCPool.sol";
import {IPool} from "src/amm/base/IPool.sol";
import {ALTBCFactory} from "src/factory/altbc/ALTBCFactory.sol";
import {URQTBCFactory} from "src/factory/urqtbc/URQTBCFactory.sol";
import {GenericERC20} from "src/example/ERC20/GenericERC20.sol";
import {AllowList} from "src/allowList/AllowList.sol";
import {FactoryBase} from "src/factory/base/FactoryBase.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";


/// Alphabetized inputs for ALTBC and URQTBC pools that are here purely for ease of serialization from json in foundry
struct ALTBCAlphabetizedInputs {
    uint256 _k;
    uint256 _lowerPrice;
    uint256 _maxXTokenSupply;
    uint256 _upperPrice;
}

struct URQTBCAlphabetizedInputs {
    uint256 _lowerPrice;
    uint256 _maxXTokenSupply;
    uint256 _minPrice;
    uint256 _upperPrice;
    uint256 gamma;
    uint256 lambda;
    uint256 v;
}

struct GasReportInputALTBC {
    ALTBCAlphabetizedInputs[] ALTBCInputs;
    uint amountToSwap;
}

struct GasReportInputURQTBC {
    URQTBCAlphabetizedInputs[] URQTBCInputs;
    uint amountToSwap;
}

abstract contract GasReport is GasHelpers, FactoryBase, Test {
    IPool[] _pools;
    TBCType _tbcType;

    using Strings for uint256;

    address _xToken;
    address _yToken;
    AllowList _yTokenAllowList;
    AllowList _deployerAllowList;
    uint16 _lpFee;
    bool _liquidityRemovalAllowed;

    uint constant XTOKEN_SUPPLY = 100_000_000_000 * 1e18;
    uint constant YTOKEN_SUPPLY = 100_000_000_000 * 1e18;
    uint AMOUNT_TO_SWAP;
    
    // this is to warm the slot so that the gas report is more accurate
    function warmSlot(uint i) internal {
        (uint minOut, , ) = _pools[i].simSwap(_yToken, AMOUNT_TO_SWAP);
        vm.startPrank(owner());
        _pools[i].swap(_yToken, AMOUNT_TO_SWAP, minOut);
        vm.stopPrank();
    }

    function _setup() internal {

        _xToken = address(new GenericERC20("xToken", "xToken"));
        _yToken = address(new GenericERC20("yToken", "yToken"));
        _lpFee = 20;
        _liquidityRemovalAllowed = true;
        _yTokenAllowList = new AllowList();
        _deployerAllowList = new AllowList();
        _yTokenAllowList.addToAllowList(address(_yToken));
        _deployerAllowList.addToAllowList(msg.sender);

        vm.startPrank(this.owner()); // deploy stuff
        GenericERC20(_xToken).mint(address(owner()), XTOKEN_SUPPLY);
        GenericERC20(_yToken).mint(address(owner()), YTOKEN_SUPPLY);

        this.setYTokenAllowList(address(_yTokenAllowList));
        this.setDeployerAllowList(address(_deployerAllowList));
        this.proposeProtocolFeeCollector(msg.sender);
        this.confirmProtocolFeeCollector();
        vm.stopPrank();
    }

    function _setupPart2() internal {
        vm.startPrank(owner());
        for (uint i = 0; i < _pools.length; i++) {
            GenericERC20(_yToken).approve(address(_pools[i]), YTOKEN_SUPPLY);
            GenericERC20(_xToken).approve(address(_pools[i]), XTOKEN_SUPPLY);
            _pools[i].addXSupply(XTOKEN_SUPPLY);
            _pools[i].enableSwaps(true);
        }
        vm.stopPrank();
    }

    function getTBCString() internal view returns (string memory name) {
        if (_tbcType == TBCType.ALTBC) {
            name = "ALTBC";
        } else if (_tbcType == TBCType.URQTBC) {
            name = "URQTBC";
        }
    }

    function testGasReport_swap() public {
        string memory tbcString = getTBCString();
        string memory toAdd = "swap";
        for (uint i = 0; i < _pools.length; i++) {
            string memory label = string.concat(tbcString, "_", toAdd, "_", Strings.toString(i));
            warmSlot(i);
            vm.startPrank(owner());
            (uint minOut, , ) = _pools[i].simSwap(_yToken, AMOUNT_TO_SWAP);
            startMeasuringGas(label);
            _pools[i].swap(_yToken, AMOUNT_TO_SWAP, minOut);
            uint gasUsed = stopMeasuringGas();
            vm.stopPrank();
            console.log(label, gasUsed);
        }
    }

    function testGasReport_swapMultiplePerTransaction() public {
        string memory tbcString = getTBCString();
        string memory toAdd = "swapMultiplePerTransaction";
        
        for (uint i = 0; i < _pools.length; i++) {
            warmSlot(i);
            IPool _pool = _pools[i];
            string memory label = string.concat(tbcString, "_", toAdd, "_", Strings.toString(i));
            vm.startPrank(owner());
            GenericERC20(_yToken).approve(address(_pool), YTOKEN_SUPPLY);
            GenericERC20(_xToken).approve(address(_pool), XTOKEN_SUPPLY);
            startMeasuringGas(label);
            for (uint j = 0; j < 10; j++) {
                if (j % 2 == 0) {
                    (uint minOut, , ) = _pool.simSwap(_yToken, AMOUNT_TO_SWAP);
                    _pool.swap(_yToken, AMOUNT_TO_SWAP, minOut);
                } else {
                    (uint minOut, , ) = _pool.simSwap(_xToken, AMOUNT_TO_SWAP);
                    _pool.swap(_xToken, AMOUNT_TO_SWAP, minOut);
                }
            }
            uint gasUsed = stopMeasuringGas();
            vm.stopPrank();
            console.log(label, gasUsed);
        }
    }
}

contract ALTBCGasReport is GasReport, ALTBCFactory {
    ALTBCPool _altbcPool;

    function getALTBCInputs() internal view returns (GasReportInputALTBC memory) {
        string memory json = vm.readFile("test/util/gasReport/altbc.json");
        bytes memory jsonBytes = vm.parseJson(json);
        return abi.decode(jsonBytes, (GasReportInputALTBC));
    }

    function reorderAlphabetizedInputs(ALTBCAlphabetizedInputs memory _inputs) internal pure returns (ALTBCInput memory) {
        return ALTBCInput({
            _k: _inputs._k,
            _lowerPrice: _inputs._lowerPrice,
            _maxXTokenSupply: _inputs._maxXTokenSupply,
            _upperPrice: _inputs._upperPrice
        });
    }

    function setUp() public {
        _tbcType = TBCType.ALTBC;
        GasReportInputALTBC memory _gasReportInput = getALTBCInputs();
        AMOUNT_TO_SWAP = _gasReportInput.amountToSwap;
        for (uint i = 0; i < _gasReportInput.ALTBCInputs.length; i++) {
            _setup();
            vm.startPrank(this.owner());
            address _placeholder; // this is to keep gas costs realistic and avoid the storage costs
            string memory label = string.concat("createPoolALTBC_", Strings.toString(i));
            ALTBCInput memory _inputs = reorderAlphabetizedInputs(_gasReportInput.ALTBCInputs[i]);
            startMeasuringGas(label);
            _placeholder = this.createPool(_xToken, _yToken, _lpFee, _inputs, _liquidityRemovalAllowed);
            uint gasUsed = stopMeasuringGas();
            _pools.push(IPool(_placeholder));
            vm.stopPrank();
            _setupPart2();
            console.log(label, gasUsed);
        }
    }
}

contract URQTBCGasReport is GasReport, URQTBCFactory {
    URQTBCPool _urqtbcPool;

    function getURQTBCInputs() internal view returns (GasReportInputURQTBC memory) {
        string memory json = vm.readFile("test/util/gasReport/urqtbc.json");
        bytes memory jsonBytes = vm.parseJson(json);
        return abi.decode(jsonBytes, (GasReportInputURQTBC));
    }

    function reorderAlphabetizedInputs(URQTBCAlphabetizedInputs memory _inputs) internal pure returns (URQTBCInput memory) {
        return URQTBCInput({
            _lowerPrice: _inputs._lowerPrice,
            _maxXTokenSupply: _inputs._maxXTokenSupply,
            v: _inputs.v
        });
    }

    function setUp() public {
        _tbcType = TBCType.URQTBC;
        GasReportInputURQTBC memory _gasReportInput = getURQTBCInputs();
        AMOUNT_TO_SWAP = _gasReportInput.amountToSwap;
        for (uint i = 0; i < _gasReportInput.URQTBCInputs.length; i++) {
            _setup();
            vm.startPrank(this.owner());
            address _placeholder; // this is to keep gas costs realistic and avoid the storage costs
            string memory label = string.concat("createPoolURQTBC_", Strings.toString(i));
            URQTBCInput memory _inputs = reorderAlphabetizedInputs(_gasReportInput.URQTBCInputs[i]);
            startMeasuringGas(label);
            _placeholder = this.createPool(_xToken, _yToken, _lpFee, _inputs, _liquidityRemovalAllowed);
            uint gasUsed = stopMeasuringGas();
            _pools.push(IPool(_placeholder));
            vm.stopPrank();
            _setupPart2();
            console.log(label, gasUsed);
        }
    }
}
