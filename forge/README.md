## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### BSC localdev

With the BSC node running on port 8545, run these commands from the Forge project directory.

```shell
$ FOUNDRY_PROFILE=localdev forge test
$ cast chain-id --rpc-url bsc_localdev
```

The Counter script deploys `Counter`, creates a CAS20 Asset, and mints to Bob at `0x0000000000000000000000000000000000000b0b`. The node must have Jenner and the CAS20 Asset feature active. The amount is in base units, so `1000000000000000000` mints one token with 18 decimals.

#### Sign with the local node

List the node's accounts and set `ALICE` to a funded, unlocked account. The address below is the built-in BSC development account.

```shell
cast rpc --rpc-url http://localhost:8545 eth_accounts
ALICE=0x71562b71999873db5b286df957af199ec94617f7

forge script script/Counter.s.sol:CounterScript \
    --rpc-url http://localhost:8545 \
    --sig 'run(uint256)' 1000000000000000000 --skip test \
    --sender "$ALICE" --unlocked --broadcast --skip-simulation --slow
```

#### Sign with a Foundry keystore

Import Alice's private key into Foundry interactively. For the built-in BSC development account, the public test key is defined as `DeveloperKey` in [cmd/utils/flags.go](../cmd/utils/flags.go).

```shell
cast wallet import bsc-dev --interactive
ALICE=$(cast wallet address --account bsc-dev)

forge script script/Counter.s.sol:CounterScript \
    --rpc-url http://localhost:8545 \
    --sig 'run(uint256)' 1000000000000000000 --skip test \
    --sender "$ALICE" --account bsc-dev --broadcast --skip-simulation --slow
```

`--skip-simulation` bypasses Forge's transaction simulation, since the CAS20 precompile runs on the BSC node. `--slow` waits for each transaction before sending the next. If the script reports `CAS20 factory unavailable on RPC node`, check that Jenner is active on the node at port 8545.

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
