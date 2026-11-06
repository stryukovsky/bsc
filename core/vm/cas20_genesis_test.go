package vm

import (
	"bytes"
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/params"
	"github.com/holiman/uint256"
)

func TestDeveloperCAS20(t *testing.T) {
	admin := common.HexToAddress("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266")
	for _, enabled := range []bool{false, true} {
		cfg := *params.AllDevChainProtocolChanges
		cfg.DevCAS20 = enabled
		st, err := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
		if err != nil {
			t.Fatal(err)
		}
		for addr, account := range DeveloperCAS20Alloc(admin) {
			st.SetCode(addr, account.Code, tracing.CodeChangeUnspecified)
			for slot, value := range account.Storage {
				st.SetState(addr, slot, value)
			}
		}
		evm := NewEVM(BlockContext{
			BlockNumber: big.NewInt(1), Time: 1, Random: &common.Hash{},
			CanTransfer: func(StateDB, common.Address, *uint256.Int) bool { return true },
			Transfer:    func(StateDB, common.Address, common.Address, *uint256.Int, *params.Rules) {},
		}, st, &cfg, Config{})
		if evm.chainRules.IsJenner || evm.chainRules.IsInBSC {
			t.Fatal("developer opt-in must not change Jenner or consensus rules")
		}
		if evm.cas20Enabled() != enabled {
			t.Fatalf("CAS20 enabled = %v, want %v", evm.cas20Enabled(), enabled)
		}
		if !enabled {
			continue
		}
		ret, _, err := evm.Call(admin, CAS20ActivationRegistryAddress, cas20Call(selActivationAdm), NewGasBudget(100_000), uint256.NewInt(0))
		if err != nil || !bytes.Equal(ret, addrKey(admin).Bytes()) {
			t.Fatalf("admin = %x, err %v", ret, err)
		}
		input := encodeCreateCAS20(cas20VariantAsset, common.Hash{}, admin, nil)
		ret, _, err = evm.Call(admin, CAS20FactoryAddress, input, NewGasBudget(2_000_000), uint256.NewInt(0))
		if err != nil || len(ret) != 32 {
			t.Fatalf("create asset = %x, err %v", ret, err)
		}
		if !bytes.Equal(st.GetCode(common.BytesToAddress(ret)), CAS20MarkerCode) {
			t.Fatal("asset was not created")
		}
	}
}
