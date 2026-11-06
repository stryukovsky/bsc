// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

interface ICAS20Factory {
    function getCAS20Address(uint8 variant, address sender, bytes32 salt) external view returns (address);
    function createCAS20(uint8 variant, bytes32 salt, bytes calldata params, bytes[] calldata initCalls)
        external
        returns (address);
}

// A real contract call lets Forge record a transaction while mocking only the
// nested native-precompile call in its local EVM.
contract CAS20Creator {
    function create(bytes32 salt, bytes calldata params, bytes[] calldata initCalls) external returns (address) {
        return ICAS20Factory(0xCA5f000000000000000000000000000000000000).createCAS20(0, salt, params, initCalls);
    }
}

contract CreateCAS20 is Script {
    address constant FACTORY = 0xCA5f000000000000000000000000000000000000;
    // Anvil's public first test key. Local development only.
    uint256 constant LOCAL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    struct AssetParams {
        uint8 version;
        string name;
        string symbol;
        address initialAdmin;
        uint8 decimals;
    }

    function run() external {
        require(block.chainid == 1337, "Use the local --dev.cas20 node (chain 1337)");
        address owner = vm.addr(LOCAL_KEY);
        address creator = vm.computeCreateAddress(owner, vm.getNonce(owner));
        // Optional deterministic salt within this creator contract.
        bytes32 salt = vm.envOr("SALT", keccak256("local-cas20-asset"));
        bytes memory prediction = vm.rpc(
            "eth_call",
            string.concat(
                '[{"to":"',
                vm.toString(FACTORY),
                '","data":"',
                vm.toString(abi.encodeCall(ICAS20Factory.getCAS20Address, (0, creator, salt))),
                '"},"latest"]'
            )
        );
        require(prediction.length == 32, "CAS20 unavailable: launch geth with --dev --dev.cas20");
        address token = abi.decode(prediction, (address));
        bytes[] memory initCalls = new bytes[](2);
        initCalls[0] = abi.encodeWithSignature("grantRole(bytes32,address)", keccak256("MINT_ROLE"), owner);
        initCalls[1] = abi.encodeWithSignature("mint(address,uint256)", owner, 1000 ether);
        bytes memory params = abi.encode(AssetParams(1, "Local Asset", "LOCAL", owner, 18));

        // Forge does not implement BSC native precompiles. Mock only its local
        // script execution; --skip-simulation sends the real call to the node.
        vm.mockCall(FACTORY, ICAS20Factory.createCAS20.selector, abi.encode(token));
        vm.startBroadcast(LOCAL_KEY);
        CAS20Creator deployed = new CAS20Creator();
        require(address(deployed) == creator, "Creator nonce changed; rerun the script");
        deployed.create(salt, params, initCalls);
        vm.stopBroadcast();
        console2.log("CAS20 asset:", token);
        console2.log("Owner (1,000 LOCAL):", owner);
    }
}
