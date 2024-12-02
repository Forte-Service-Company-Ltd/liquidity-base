// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PoolBase} from "src/amm/base/PoolBase.sol";
import {URQTBCEquations} from "src/amm/urqtbc/URQTBCEquations.sol";
import {URQTBCDef, URQTBCInput} from "src/common/TBC.sol";

contract URQTBCTesterPool {
    using URQTBCEquations for URQTBCDef;
    using URQTBCEquations for URQTBCInput;
    URQTBCDef urqtbc;
    function setTBC(URQTBCDef memory tbc) external {
        urqtbc = tbc;
    }

    function getTBC() external view returns (URQTBCDef memory) {
        return urqtbc;
    }
    function calculateCofN(uint D, uint x) external returns (uint c) {
        urqtbc.calculateCn(D, x);
        c = urqtbc.c;
    }

    function calculatefx(uint Xn) external view returns (uint fx) {
        fx = urqtbc.calculatefx(Xn);
    }

    function calculateLn(uint Dn, uint Xn) external returns (uint l) {
        urqtbc.calculateLn(Dn, Xn);
        l = urqtbc.l;
    }

    function calculateFx(uint Xn) external view returns (uint f) {
        f = urqtbc.calculateFx(Xn);
    }

    function calculateCConstant(URQTBCInput memory _urqtbc) external pure returns (uint256 CConstant) {
        CConstant = _urqtbc.calculateConstantC();
    }


    function calculateFinverse(uint256 Dn) external view returns (uint256 Finversed) {
        Finversed = urqtbc.calculateFinversedOfD(Dn);
    }
}
