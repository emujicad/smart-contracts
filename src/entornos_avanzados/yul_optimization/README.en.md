# OptimizedContract Smart Contract (Yul Optimization)

This Solidity contract, `OptimizedContract`, is an educational example that compares gas usage efficiency between standard Solidity code and its equivalent implemented using Yul (EVM assembly language - Ethereum Virtual Machine). The goal is to demonstrate how direct use of Yul can, in certain cases, lead to significant gas optimizations.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract focuses on how more efficient code can be written to reduce transaction costs (gas).

## Key Concepts Used

### `pragma solidity ^0.8.20;`

Indicates the Solidity compiler version that should be used. `^0.8.20` means the contract will compile with versions from 0.8.20 up to the next major version (e.g., 0.9.0).

### `assembly { ... }` (Yul)

The `assembly { ... }` block allows writing code directly in Yul, the low-level assembly language of the Ethereum Virtual Machine (EVM). This provides much finer control over how operations are executed, which can be useful for optimizing gas usage, albeit at the cost of increased complexity and a higher risk of errors.

### `pure`

Functions marked as `pure` do not modify the blockchain state nor read any state variables. They only operate with input parameters and local variables. They are the cheapest functions to execute in terms of gas.

## Function Comparison (Solidity vs. Yul)

`OptimizedContract` presents pairs of functions that perform the same operation, one in Solidity and one in Yul, to compare their gas consumption.

### Sum of two numbers (`soliditysum` vs. `yul_sum`)

*   **`soliditysum(uint256 _a, uint256 _b)`**: Performs a simple addition in Solidity (`_a + _b`).
*   **`yul_sum(uint256 _a, uint256 _b)`**: Uses the Yul `add` opcode to perform the addition. `result := add(_a, _b)` assigns the result of the addition to the `result` variable.

### Hashing (`solidityHash` vs. `yulHash`)

*   **`solidityHash(uint256 _a, uint256 _b)`**: Uses `keccak256(abi.encode(_a, _b))` to calculate the Keccak-256 hash of two numbers. `abi.encode` packs the values for hashing.
*   **`yulHash(uint256 _a, uint256 _b)`**: Performs hashing using Yul opcodes:
    *   `mstore(0x00, _a)`: Stores the value of `_a` at memory position `0x00`.
    *   `mstore(0x20, _b)`: Stores the value of `_b` at memory position `0x20` (just after `_a`, since `uint256` occupies 32 bytes or `0x20` in hexadecimal).
    *   `let hash := keccak256(0x00, 0x40)`: Calculates the Keccak-256 hash of the 64 bytes (0x40) of memory starting at `0x00`.

### `for` loop (`solidityuncheckedPusPlusI` vs. `yuluncheckedPusPlusI`)

*   **`solidityuncheckedPusPlusI()`**: A `for` loop in Solidity that uses `unchecked { ++i; }` to avoid overflow/underflow checks, which can save gas.
*   **`yuluncheckedPusPlusI()`**: Implements a `for` loop directly in Yul, with explicit control of `i` and `j` variables using `add` and `lt` (less than).

### Subtraction with overflow check (`soliditySubTest` vs. `yulSubTest`)

*   **`soliditySubTest(uint256 _a, uint256 _b)`**: Performs a simple subtraction in Solidity. In modern Solidity versions (>=0.8.0), arithmetic operations automatically check for overflows/underflows, which adds a gas cost.
*   **`yulSubTest(uint256 _a, uint256 _b)`**: Performs subtraction with `sub(_a, _b)` in Yul. It then includes a manual underflow check (`if gt(c, _a)`) and reverts the transaction if it occurs, demonstrating how security can be manually implemented in Yul.

### State variable update (`solidityUpdateOwner` vs. `yulUpdateOwner`)

*   **`solidityUpdateOwner(address newOwner)`**: Updates an `owner` state variable in Solidity (`owner = newOwner;`).
*   **`yulUpdateOwner(address newOwner)`**: Uses the Yul `sstore` opcode to directly store the `newOwner` value in the `owner`'s storage slot. `owner.slot` is a Solidity feature that allows accessing a variable's storage slot.

## Why use Yul?

Using Yul can be beneficial for:

*   **Gas Optimization:** Reducing transaction costs in critical operations.
*   **Fine-grained Control:** Having precise control over how operations are executed in the EVM.
*   **Advanced Functionalities:** Implementing logic that is difficult or impossible to express directly in Solidity.

However, Yul is more complex, error-prone, and requires a deep understanding of the EVM. Generally, it is recommended to use Solidity for most of the code and resort to Yul only for very specific code blocks where gas optimization is crucial.