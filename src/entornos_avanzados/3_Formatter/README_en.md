# Simple Counter Contract (Counter.sol)

This Solidity contract (`Counter.sol`) is a fundamental example used to introduce the most basic concepts of smart contracts on the blockchain. It's ideal for beginners learning about state variables and state-modifying functions.

## Key Features

*   **Variable de Estado `number`**: Stores an integer that can be incremented, decremented, or set to a specific value.
*   **`setNumber(uint256 newNumber)`**: Allows setting the value of `number` to any desired value.
*   **`increment()`**: Increases the value of `number` by one.
*   **`decrement()`**: Decreases the value of `number` by one.

## Solidity Concepts to Learn

*   **`pragma solidity ^0.8.13;`**: Defines the Solidity compiler version.
*   **`contract Counter { ... }`**: The basic structure of a smart contract.
*   **`uint256 public number;`**: Declaration of a public state variable.
    *   **`uint256`**: Data type for 256-bit unsigned integers, suitable for large numbers.
    *   **`public`**: Makes the variable readable from outside the contract.
    *   **State Variables**: Data that is permanently stored on the blockchain.
*   **`function name() public { ... }`**: Function declaration.
    *   **`public`**: The function can be called from anywhere (by external users or by other contracts).
    *   **State-Modifying Functions**: Functions like `setNumber`, `increment`, and `decrement` change the value of the contract's state variables. Each time they are called, a transaction is created on the blockchain, and gas costs are incurred.

## How It Works

1.  **Contract Deployment:** When the `Counter` contract is deployed to the blockchain, the `number` variable is initialized with its default value (0 for `uint256`).
2.  **Read the Value:** You can read the current value of `number` directly, as it is a `public` variable.
3.  **Set the Number:** Call `setNumber(X)` to change the value of `number` to `X`.
4.  **Increment/Decrement:** Call `increment()` to add 1 to `number`, or `decrement()` to subtract 1.

## Usage (Basic Example)

This contract is a "Hello World" for state modification in Solidity. It's useful for:

*   Understanding how state variables are stored on the blockchain.
*   Grasping how functions can modify these variables.
*   Becoming familiar with the concept of "gas" (transaction cost) when modifying state.

To interact with this contract (after deploying it to a testnet or development environment):

*   Call `setNumber(5)` to set the counter to 5.
*   Call `increment()` multiple times and observe how `number` increases.
*   Call `decrement()` and observe how `number` decreases.
*   You can always read the current value of `number` to verify changes.

This contract is an excellent first step to understanding interactivity and data persistence on the blockchain.
