package vm

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/log"
)

// SeedCAS20Activation plants the registries' account sentinels (BEP-702 3.16).
// Without code, EIP-161 would clear the accounts and their storage, and GovHub
// would refuse them as a target: it tests extcodesize before forwarding a
// parameter change, and swallows the refusal into an event.
func SeedCAS20Activation(state StateDB) {
	seedCAS20Sentinel(state, CAS20ActivationRegistryAddress)
	seedCAS20Sentinel(state, CAS20PolicyRegistryAddress)
}

func seedCAS20Sentinel(state StateDB, addr common.Address) {
	if !hadNoCode(state, addr) {
		log.Error("CAS20 registry already carries code", "addr", addr)
		return
	}
	state.SetCode(addr, CAS20MarkerCode, tracing.CodeChangeSystemContractUpgrade)
}

// DeveloperCAS20Alloc seeds the isolated developer chain with an activation
// admin and the Asset feature enabled. Production activation uses governance.
func DeveloperCAS20Alloc(admin common.Address) types.GenesisAlloc {
	return types.GenesisAlloc{
		CAS20ActivationRegistryAddress: {
			Balance: common.Big0,
			Code:    CAS20MarkerCode,
			Storage: map[common.Hash]common.Hash{
				actSlot(actSlotAdmin): addrKey(admin),
				mappingSlot(actSlot(actSlotFeatures), featureCAS20Asset): common.HexToHash("0x1"),
			},
		},
		CAS20PolicyRegistryAddress: {Balance: common.Big0, Code: CAS20MarkerCode},
	}
}
