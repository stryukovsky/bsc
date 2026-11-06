## CAS20 local development

1. In VS Code, select **geth: local CAS20 dev node** and press F5.
   This uses Delve DAP to launch this repository's `cmd/geth` with
   `--dev --dev.cas20`. RPC is `http://127.0.0.1:8545`, chain ID is `1337`.
2. Run from `test-cas20`:

   ```sh
   FOUNDRY_PROFILE=localdev forge script script/CreateCAS20.s.sol:CreateCAS20 \
     --broadcast --skip-simulation --slow
   ```

The genesis funds Anvil's first account,
`0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`, with **10,000 native ETH**.
The script signs using that account's public test key, deploys a small creator
contract, creates a CAS20 Asset named **Local Asset (LOCAL)**, and mints
**1,000 LOCAL** to the account. It prints the asset address. The account also
receives the token's admin and mint roles. Each run deploys a new creator,
so the script can be rerun without a salt collision.

Verify the result (replace the address with the script's output):

```sh
cast balance 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --ether --rpc-url bsc_localdev
cast call <ASSET_ADDRESS> 'balanceOf(address)(uint256)' \
  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --rpc-url bsc_localdev
```

`--dev.cas20` explicitly enables CAS20 dispatch on the Ethereum developer
consensus engine; it does not activate the full Jenner fork or run a Parlia
validator network. It seeds the activation registry with the Anvil account as
admin and enables the Asset feature. Stablecoin and policy creation remain
inactive until the admin activates them. Ordinary `--dev` is unchanged.

The launch stores its chain separately in `/tmp/bsc-vscode-cas20-dev`.
Funding and activation are genesis-only and persist between launches; they
are not replenished on restart. To start fresh, stop the node and change the
launch's `--datadir` to a new directory. A database created with ordinary
`--dev` cannot be reused with `--dev.cas20`.

Forge's EVM does not implement CAS20 native precompiles. The script mocks the
nested factory call only during local script execution; `--skip-simulation`
lets the actual transactions run against this node. `--slow` waits for each
receipt. Inspect the receipts or query the asset to confirm execution.
The embedded key is public and for local development only.

---

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

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

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
