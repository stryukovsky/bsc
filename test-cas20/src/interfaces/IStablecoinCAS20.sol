// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IStablecoinCAS20 {
    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address, bytes32);
    error AccountNotSeizable(address);
    error ContractPaused(uint8);
    error DelegateCallNotAllowed();
    error EmptyFeatureSet();
    error ExpiredSignature(uint256);
    error InsufficientAllowance(address, uint256, uint256);
    error InsufficientBalance(address, uint256, uint256);
    error InvalidApprover(address);
    error InvalidFormatId();
    error InvalidReceiver(address);
    error InvalidSender(address);
    error InvalidSigner(address, address);
    error InvalidSpender(address);
    error InvalidSupplyCap(uint256, uint256);
    error LastAdminCannotRenounce();
    error NonPayable();
    error NotSoleAdmin();
    error PolicyForbids(bytes32, uint64);
    error PolicyNotFound(uint64);
    error StaticCallNotAllowed();
    error SupplyCapExceeded(uint256, uint256);
    error UnsupportedPolicyType(bytes32);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ContractURIUpdated();
    event EIP712DomainChanged();
    event LastAdminRenounced(address indexed account);
    event Memo(address indexed caller, bytes32 indexed memo);
    event MemoFormatDeclared(address indexed caller, bytes32 indexed memo, bytes32 indexed formatId);
    event NameUpdated(address indexed caller, string name);
    event Paused(address indexed caller, uint8[] features);
    event PolicyUpdated(bytes32 indexed scope, uint64 previousPolicyId, uint64 newPolicyId);
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event Seized(address indexed caller, address indexed from, address indexed to, uint256 amount);
    event SupplyCapUpdated(address indexed caller, uint256 previousCap, uint256 newCap);
    event SymbolUpdated(address indexed caller, string symbol);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Unpaused(address indexed caller, uint8[] features);

    function BURN_ROLE() external view returns (bytes32);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function METADATA_ROLE() external view returns (bytes32);
    function MINT_RECEIVER_POLICY() external view returns (bytes32);
    function MINT_ROLE() external view returns (bytes32);
    function PAUSE_ROLE() external view returns (bytes32);
    function SEIZE_EXEMPT_POLICY() external view returns (bytes32);
    function SEIZE_RECEIVER_POLICY() external view returns (bytes32);
    function SEIZE_ROLE() external view returns (bytes32);
    function TRANSFER_EXECUTOR_POLICY() external view returns (bytes32);
    function TRANSFER_RECEIVER_POLICY() external view returns (bytes32);
    function TRANSFER_SENDER_POLICY() external view returns (bytes32);
    function UNPAUSE_ROLE() external view returns (bytes32);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function burn(uint256 amount) external;
    function burnWithMemo(uint256 amount, bytes32 memo) external;
    function contractURI() external view returns (string memory);
    function currency() external view returns (string memory);
    function decimals() external view returns (uint8);
    function eip712Domain()
        external
        view
        returns (
            bytes1 fields,
            string memory name,
            string memory version,
            uint256 chainId,
            address verifyingContract,
            bytes32 salt,
            uint256[] memory extensions
        );
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function isPaused(uint8 feature) external view returns (bool);
    function mint(address to, uint256 amount) external;
    function mintWithMemo(address to, uint256 amount, bytes32 memo) external;
    function name() external view returns (string memory);
    function nonces(address owner) external view returns (uint256);
    function pause(uint8[] memory features) external;
    function pausedFeatures() external view returns (uint8[] memory);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;
    function policyId(bytes32 scope) external view returns (uint64);
    function renounceLastAdmin() external;
    function renounceRole(bytes32 role, address callerConfirmation) external;
    function revokeRole(bytes32 role, address account) external;
    function seizeWithMemo(address from, address to, uint256 amount, bytes32 memo) external returns (bool);
    function setRoleAdmin(bytes32 role, bytes32 adminRole) external;
    function supplyCap() external view returns (uint256);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transferFromWithMemo(address from, address to, uint256 amount, bytes32 memo) external returns (bool);
    function transferFromWithMemoFormat(address from, address to, uint256 amount, bytes32 memo, bytes32 formatId)
        external
        returns (bool);
    function transferWithMemo(address to, uint256 amount, bytes32 memo) external returns (bool);
    function transferWithMemoFormat(address to, uint256 amount, bytes32 memo, bytes32 formatId) external returns (bool);
    function unpause(uint8[] memory features) external;
    function updateContractURI(string memory uri) external;
    function updateName(string memory name) external;
    function updatePolicy(bytes32 scope, uint64 policyId) external;
    function updateSupplyCap(uint256 cap) external;
    function updateSymbol(string memory symbol) external;
}
