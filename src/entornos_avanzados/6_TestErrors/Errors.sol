// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

contract CErrors {
    // This declares a new smart contract named 'CErrors'.
    // This contract demonstrates different ways to handle errors in Solidity.

    error UnAuthorized();
    // This declares a custom error named 'UnAuthorized'.
    // Custom errors are a feature introduced in Solidity 0.8.4.
    // They are more gas-efficient and provide more context than string reverts.
    // You define them like functions, but without parameters in this simple case.

    function throwError() external pure {
        // This function demonstrates how to use 'require' for error handling.
        // 'external' means this function can only be called from outside the contract.
        // 'pure' means this function does not read from or modify the state of the blockchain.
        // It's used here because the function's logic doesn't depend on or change any state variables.

        require(false, "UnAuthorized...!");
        // 'require' is a common Solidity statement for input validation.
        // If the condition (here, 'false') is not met, the transaction is reverted.
        // The string message "UnAuthorized...!" will be returned as part of the error.
        // This is a simple way to stop execution and revert changes if something goes wrong.
    }

    function throwCustomError() public pure {
        // This function demonstrates how to use a custom error with 'revert'.
        // 'public' means this function can be called from anywhere.
        // 'pure' means this function does not read from or modify the state of the blockchain.

        revert UnAuthorized();
        // 'revert' is used to explicitly stop execution and revert all changes made during the transaction.
        // Here, it's used with the custom error 'UnAuthorized()'.
        // Using custom errors with 'revert' is generally preferred over 'require' with string messages
        // for more complex error conditions because they are more gas-efficient and provide structured error data.
    }
}
