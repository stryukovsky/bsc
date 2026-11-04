// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IFactoryCAS20} from "./interfaces/IFactoryCAS20.sol";
import {IAssetCAS20} from "./interfaces/IAssetCAS20.sol";

contract Counter {
    address public constant cas20FactoryAddress = 0xCA5f000000000000000000000000000000000000;

    bytes32 public constant DEFAULT_ADMIN_ROLE = bytes32(0);
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
    bytes32 public constant SEIZE_ROLE = keccak256("SEIZE_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");
    bytes32 public constant UNPAUSE_ROLE = keccak256("UNPAUSE_ROLE");
    bytes32 public constant METADATA_ROLE = keccak256("METADATA_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE"); // Asset only

    struct AssetParams {
        uint8 version;
        string name;
        string symbol;
        address initialAdmin;
        uint8 decimals;
    }

    struct StablecoinParams {
        uint8 version;
        string name;
        string symbol;
        address initialAdmin;
        string currency;
    }

    function createAsset(bytes32 salt) external returns (IAssetCAS20) {
        bytes memory params = abi.encode(AssetParams(1, "My Asset", "MYA", msg.sender, 18));

        bytes[] memory initCalls = new bytes[](1);
        initCalls[0] = abi.encodeCall(IAssetCAS20.grantRole, (MINT_ROLE, msg.sender));

        address result = IFactoryCAS20(cas20FactoryAddress).createCAS20(0, salt, params, initCalls);
        return IAssetCAS20(result);
    }
}
