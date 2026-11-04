// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IFactoryCAS20 {
    error DelegateCallNotAllowed();
    error FeatureNotActivated(bytes32);
    error InitCallFailed(uint256);
    error InternalCallMalformed(bytes);
    error InvalidCurrency(string);
    error InvalidDecimals(uint8);
    error InvalidVariant();
    error MissingRequiredField(string);
    error NonPayable();
    error StaticCallNotAllowed();
    error TokenAlreadyExists(address);
    error UnsupportedVersion(uint8, uint8);

    event CAS20Created(
        address indexed token, uint8 indexed variant, string name, string symbol, uint8 decimals, bytes params
    );

    function createCAS20(uint8 variant, bytes32 salt, bytes memory params, bytes[] memory initCalls)
        external
        returns (address);
    function getCAS20Address(uint8 variant, address sender, bytes32 salt) external view returns (address);
    function isCAS20(address token) external view returns (bool);
    function isCAS20Initialized(address token) external view returns (bool);
    function variantOf(address token) external view returns (uint8);
}
