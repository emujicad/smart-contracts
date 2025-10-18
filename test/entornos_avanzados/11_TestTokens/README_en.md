# Testing with a Fork of a Mainnet Contract

This section explains how to test smart contracts by interacting with contracts that are already deployed on the Ethereum mainnet. This is a powerful technique known as "forking," which allows you to simulate transactions and test functionalities in a realistic environment without spending real gas.

## Key Concepts

### Forking

Forking is the process of creating a local copy of a blockchain (like the Ethereum mainnet) at a specific block number. This allows you to interact with deployed contracts as if you were on the mainnet, but in a local and controlled environment. Foundry makes it easy to do this by simply providing a mainnet RPC endpoint.

### Interacting with a Deployed Contract

To interact with a deployed contract, you need two things:

1.  **The contract's address:** This is the unique identifier of the contract on the blockchain.
2.  **The contract's interface:** This is a Solidity file that defines the functions of the contract that you want to interact with. You don't need the full source code of the contract, just the interface.

### `deal` Cheatcode

The `deal` cheatcode is a powerful feature of Foundry that allows you to set the balance of any account for any ERC20 token. This is extremely useful for testing, as it allows you to simulate having any amount of tokens without having to acquire them on the mainnet.

## Code Explanation

### `test/interfaces/IERC20.sol`

This file defines the interface for the ERC20 token standard. It includes the six mandatory functions that any ERC20 token must implement:

*   `totalSupply()`
*   `balanceOf(address account)`
*   `transfer(address recipient, uint256 amount)`
*   `allowance(address owner, address spender)`
*   `approve(address spender, uint256 amount)`
*   `transferFrom(address sender, address recipient, uint256 amount)`

It also defines two events, `Transfer` and `Approval`, which are emitted when tokens are transferred or approved.

### `test/11_TestTokens/forkDai.sol`

This is the test contract that demonstrates how to interact with the DAI token contract on the Ethereum mainnet. Let's break down the code:

1.  **Importing necessary files:**

    *   `forge-std/Test.sol`: Foundry's testing utilities.
    *   `forge-std/console.sol`: For logging information to the console.
    *   `../interfaces/IERC20.sol`: The interface for the ERC20 token.

2.  **Contract definition:**

    *   `contract ForkDaiTest is Test`: Defines the test contract, which inherits from Foundry's `Test` contract.

3.  **State variable:**

    *   `IERC20 public dai;`: Declares a public variable `dai` of type `IERC20`. This variable will be used to interact with the DAI token contract.

4.  **`setUp()` function:**

    *   This function is executed before each test case.
    *   `dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);`: Initializes the `dai` variable with the address of the official DAI contract on the Ethereum mainnet.

5.  **Test functions:**

    *   `testDeposit()`: This function tests the process of simulating a deposit of DAI tokens.
        *   It first gets the initial balance of an account.
        *   Then, it uses the `deal` cheatcode to simulate the account receiving 1 million DAI tokens.
        *   Finally, it asserts that the final balance is greater than the initial balance and that the total supply of DAI remains unchanged.

## How to Run the Tests

To run the tests, you need to have Foundry installed. Then, you can run the following command in your terminal:

```bash
forge test --fork-url <your_mainnet_rpc_url> --match-path test/11_TestTokens/forkDai.sol -vvv
```
Replace `<your_mainnet_rpc_url>` with your own Ethereum mainnet RPC URL (e.g., from Alchemy or Infura). Por ejemplo:
```bash
forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P --match-path test/11_TestTokens/forkDai.sol -vvv
```

This will run the tests in a forked environment, allowing the test contract to interact with the real DAI contract on the mainnet.
