// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAssetCAS20 {
    error AccessControlBadConfirmation();
    error AccessControlUnauthorizedAccount(address, bytes32);
    error AccountNotSeizable(address);
    error AnnouncementIdAlreadyUsed(string);
    error AnnouncementInProgress();
    error ContractPaused(uint8);
    error DelegateCallNotAllowed();
    error EffectiveAtInPast(uint256);
    error EffectiveAtTooFar(uint256);
    error EmptyBatch();
    error EmptyFeatureSet();
    error ExpiredSignature(uint256);
    error InsufficientAllowance(address, uint256, uint256);
    error InsufficientBalance(address, uint256, uint256);
    error InternalCallFailed(bytes);
    error InternalCallMalformed(bytes);
    error InvalidApprover(address);
    error InvalidFormatId();
    error InvalidMetadataKey();
    error InvalidMultiplier();
    error InvalidReceiver(address);
    error InvalidSender(address);
    error InvalidSigner(address, address);
    error InvalidSpender(address);
    error InvalidSupplyCap(uint256, uint256);
    error LastAdminCannotRenounce();
    error LengthMismatch(uint256, uint256);
    error NonPayable();
    error NotSoleAdmin();
    error PolicyForbids(bytes32, uint64);
    error PolicyNotFound(uint64);
    error StaticCallNotAllowed();
    error SupplyCapExceeded(uint256, uint256);
    error UIMultiplierUpdateDoesNotExist();
    error UIMultiplierUpdateExists(uint256);
    error UnsupportedPolicyType(bytes32);

    event Announcement(address indexed caller, string id, string description, string uri);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ContractURIUpdated();
    event EIP712DomainChanged();
    event EndAnnouncement(string id);
    event ExtraMetadataUpdated(string key, string value);
    event LastAdminRenounced(address indexed account);
    event Memo(address indexed caller, bytes32 indexed memo);
    event MemoFormatDeclared(address indexed caller, bytes32 indexed memo, bytes32 indexed formatId);
    event MultiplierUpdated(uint256 multiplier);
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
    event UIMultiplierUpdateCancelled(uint256 multiplier, uint256 effectiveAt);
    event UIMultiplierUpdated(uint256 previousMultiplier, uint256 newMultiplier, uint256 effectiveAt);
    event Unpaused(address indexed caller, uint8[] features);

    function BURN_ROLE() external view returns (bytes32);
    function DEFAULT_ADMIN_ROLE() external view returns (bytes32);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function MAX_UI_MULTIPLIER() external view returns (uint256);
    function METADATA_ROLE() external view returns (bytes32);
    function MINT_RECEIVER_POLICY() external view returns (bytes32);
    function MINT_ROLE() external view returns (bytes32);
    function OPERATOR_ROLE() external view returns (bytes32);
    function PAUSE_ROLE() external view returns (bytes32);
    function SEIZE_EXEMPT_POLICY() external view returns (bytes32);
    function SEIZE_RECEIVER_POLICY() external view returns (bytes32);
    function SEIZE_ROLE() external view returns (bytes32);
    function TRANSFER_EXECUTOR_POLICY() external view returns (bytes32);
    function TRANSFER_RECEIVER_POLICY() external view returns (bytes32);
    function TRANSFER_SENDER_POLICY() external view returns (bytes32);
    function UNPAUSE_ROLE() external view returns (bytes32);
    function WAD_PRECISION() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function announce(bytes[] memory calls, string memory id, string memory description, string memory uri) external;
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function balanceOfUI(address account) external view returns (uint256);
    function batchMint(address[] memory recipients, uint256[] memory amounts) external;
    function burn(uint256 amount) external;
    function burnWithMemo(uint256 amount, bytes32 memo) external;
    function cancelUIMultiplierUpdate() external;
    function contractURI() external view returns (string memory);
    function decimals() external view returns (uint8);
    function effectiveAt() external view returns (uint256);
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
    function extraMetadata(string memory key) external view returns (string memory);
    function fromUIAmount(uint256 uiAmount) external view returns (uint256);
    function getRoleAdmin(bytes32 role) external view returns (bytes32);
    function grantRole(bytes32 role, address account) external;
    function hasRole(bytes32 role, address account) external view returns (bool);
    function isAnnouncementIdUsed(string memory id) external view returns (bool);
    function isPaused(uint8 feature) external view returns (bool);
    function mint(address to, uint256 amount) external;
    function mintWithMemo(address to, uint256 amount, bytes32 memo) external;
    function multiplier() external view returns (uint256);
    function name() external view returns (string memory);
    function newUIMultiplier() external view returns (uint256);
    function nonces(address owner) external view returns (uint256);
    function pause(uint8[] memory features) external;
    function pausedFeatures() external view returns (uint8[] memory);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;
    function policyId(bytes32 scope) external view returns (uint64);
    function renounceLastAdmin() external;
    function renounceRole(bytes32 role, address callerConfirmation) external;
    function revokeRole(bytes32 role, address account) external;
    function scaledBalanceOf(address account) external view returns (uint256);
    function seizeWithMemo(address from, address to, uint256 amount, bytes32 memo) external returns (bool);
    function setRoleAdmin(bytes32 role, bytes32 adminRole) external;
    function supplyCap() external view returns (uint256);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function toRawBalance(uint256 scaledAmount) external view returns (uint256);
    function toScaledBalance(uint256 rawAmount) external view returns (uint256);
    function toUIAmount(uint256 rawAmount) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function totalSupplyUI() external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transferFromWithMemo(address from, address to, uint256 amount, bytes32 memo) external returns (bool);
    function transferFromWithMemoFormat(address from, address to, uint256 amount, bytes32 memo, bytes32 formatId)
        external
        returns (bool);
    function transferWithMemo(address to, uint256 amount, bytes32 memo) external returns (bool);
    function transferWithMemoFormat(address to, uint256 amount, bytes32 memo, bytes32 formatId) external returns (bool);
    function uiMultiplier() external view returns (uint256);
    function unpause(uint8[] memory features) external;
    function updateContractURI(string memory uri) external;
    function updateExtraMetadata(string memory key, string memory value) external;
    function updateMultiplier(uint256 multiplier) external;
    function updateName(string memory name) external;
    function updatePolicy(bytes32 scope, uint64 policyId) external;
    function updateSupplyCap(uint256 cap) external;
    function updateSymbol(string memory symbol) external;
    function updateUIMultiplier(uint256 multiplier, uint256 effectiveAt) external;
}
