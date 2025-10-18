# Error Handling Contract (CErrors.sol)

This Solidity contract (`CErrors.sol`) is designed to illustrate different ways to handle errors and revert transactions on the blockchain. It's crucial for Web3 developers to understand how and when to use error mechanisms to ensure the robustness and security of their contracts.

## Key Features

*   **Custom Error `UnAuthorized()`**: Demonstrates the definition and usage of custom errors, a more gas-efficient feature.
*   **`throwError()` Function**: Shows the traditional use of `require()` with a string message to revert a transaction.
*   **`throwCustomError()` Function**: Illustrates how to use the `revert` statement with a custom error.

## Solidity Concepts to Learn

*   **`pragma solidity ^0.8.13;`**: Defines the Solidity compiler version.
*   **`contract CErrors { ... }`**: The basic structure of a smart contract.
*   **`error MyCustomError();`**: Declaration of a custom error. Custom errors are more gas-efficient than `require` or `revert` string messages.
*   **`require(condition, "error message");`**: A built-in function used to validate conditions. If the `condition` is false, execution stops, all state changes are reverted, and the `error message` is returned.
*   **`revert MyCustomError();`**: A statement that stops execution and reverts all state changes. It can be used with or without a custom error. When used with a custom error, it provides structured error information.
*   **`external`**: Visibility modifier meaning the function can only be called from outside the contract.
*   **`public`**: Visibility modifier meaning the function can be called from anywhere (externally or internally).
*   **`pure`**: State mutability modifier meaning the function does not read from or modify the blockchain's state.

## How It Works

1.  **`throwError()`**: When this function is called, the `false` condition in `require(false, "UnAuthorized...!")` will always be false. This will cause the transaction to revert, and the message "UnAuthorized...!" will be returned as part of the failed transaction information.
2.  **`throwCustomError()`**: When this function is called, the `revert UnAuthorized();` statement will immediately stop execution and revert the transaction. Instead of a string message, the custom error `UnAuthorized` will be emitted, which can be caught and handled by client applications more efficiently.

## Usage (Educational Example)

This contract is an educational tool to understand the differences between `require` with string messages and `revert` with custom errors.

To interact with this contract (after deploying it to a testnet or development environment):

*   Call `throwError()` and observe how the transaction fails with the string message.
*   Call `throwCustomError()` and observe how the transaction fails with the custom error.

Understanding error handling is fundamental for building secure and robust smart contracts. Custom errors are the recommended way to handle errors in modern Solidity versions due to their efficiency and clarity.
