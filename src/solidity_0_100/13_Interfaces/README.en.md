# Solidity Interfaces Example

This project provides a simple example of how to use interfaces in Solidity to interact with smart contracts.

## Contracts

### `interface.sol`

This file defines the `ICounter` interface. An interface in Solidity is a collection of function definitions without implementation. It defines a contract's public API, allowing other contracts to interact with it without needing to know its internal logic.

Key features of interfaces:
- They cannot have any functions implemented.
- They can inherit from other interfaces.
- All declared functions must be `external`.
- They cannot have a constructor.
- They cannot have state variables.

### `counter.sol`

This is a simple smart contract that maintains a counter. It has two functions: `inc()` to increment the counter and `dec()` to decrement it. This contract implements the functions defined in the `ICounter` interface.

### `callinterface.sol`

This contract demonstrates how to use the `ICounter` interface to interact with the `Counter` contract. It takes the address of a `Counter` contract, calls its `inc()` function, and then retrieves the updated count using the `count()` function.

## How it works

1.  **`ICounter` interface:** Defines the functions that a counter contract should have (`count()` and `inc()`).
2.  **`Counter` contract:** Implements the functions defined in the `ICounter` interface.
3.  **`CallInterface` contract:**
    *   Imports the `ICounter` interface.
    *   The `examples()` function takes the address of a deployed `Counter` contract.
    *   It creates an `ICounter` instance from the address, which allows it to call the functions defined in the interface.
    *   It calls `inc()` on the `Counter` contract, which modifies its state.
    *   It calls `count()` to read the state of the `Counter` contract.

This example illustrates a fundamental concept in smart contract development: **separation of concerns**. By using interfaces, we can write contracts that can interact with any other contract that implements the same interface, making our code more modular, reusable, and testable.

## How to use

1.  Deploy the `Counter` contract.
2.  Deploy the `CallInterface` contract.
3.  Call the `examples()` function of the `CallInterface` contract, passing the address of the deployed `Counter` contract as an argument.
