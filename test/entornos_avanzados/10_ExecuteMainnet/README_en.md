# Mainnet Forking Tests (Fork.t.sol)

This Solidity contract (`Fork.t.sol`) demonstrates a fundamental approach to testing smart contracts by forking the Ethereum mainnet. Mainnet forking allows you to simulate transactions and interact with deployed contracts as if you were on the live network, but in a local, controlled environment. This test specifically shows how to interact with the official WETH contract on mainnet to test a deposit function.

## Key Features

*   **Mainnet Forking**: The test is designed to run on a fork of the Ethereum mainnet, specified via a command-line flag.
*   **Interaction with Deployed Contracts**: The test shows how to interact with a live contract on mainnet (WETH) by using its address and interface.
*   **Balance and State Verification**: It verifies that a state change (a WETH deposit) occurs correctly by checking the contract's WETH balance before and after the transaction.

## Solidity and Foundry Concepts to Learn

*   **`import {Test, console} from "forge-std/Test.sol";`**: Imports Foundry's standard test library and console logging utilities.
*   **`interface IWETH { ... }`**: Defines a minimal interface for the WETH contract, containing only the functions needed for the test (`balanceOf` and `deposit`). This allows the test contract to call these functions on the actual WETH contract.
*   **`setUp()`**: A special function in Foundry tests that runs before each test function. Here, it's used to initialize the `weth` variable with an interface pointing to the official WETH contract address on mainnet.
*   **`address(this)`**: The address of the current test contract.
*   **`weth.deposit{value: 500}()`**: This calls the `deposit` function on the WETH contract and sends 500 wei along with the call. The `{value: 500}` syntax is how you send Ether when calling a `payable` function.
*   **`console.log(...)`**: A utility from `forge-std` used to print information to the console during the test execution, which is useful for debugging.

## How the Test Works

1.  **`setUp()`**: Before the test runs, this function initializes the `weth` variable, making it a usable instance of the WETH contract at its mainnet address `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`.
2.  **`testDeposit()`**:
    *   It first records the initial WETH balance of the test contract itself.
    *   It then executes a `deposit` transaction, sending 500 wei to the WETH contract to be wrapped into WETH.
    *   Finally, it retrieves the final WETH balance and logs both the initial and final balances to the console, allowing you to observe the result of the deposit.

## Usage (Running the Test)

To run this test, you need to have Foundry installed and an RPC URL for the Ethereum mainnet (e.g., from Alchemy or Infura). The test is run using the `forge test` command with the `--fork-url` flag.

```bash
forge test --fork-url <YOUR_RPC_URL> --match-path test/10_ExecuteMainnet/Fork.t.sol -vvv
```

Replace `<YOUR_RPC_URL>` with your actual RPC URL. For example:
```bash
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P --match-path test/10_ExecuteMainnet/Fork.t.sol -vvv
```

This test contract is an excellent, practical example of how to interact with existing protocols on the Ethereum mainnet in a testing environment, a crucial skill for any Web3 developer.