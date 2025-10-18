// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library.
// 'forge-std' is a standard library for Foundry, providing essential utilities for writing tests in Solidity.
// It includes the `console.log` functionality, which is very useful for debugging.

contract ConsoleTest is Test {
    // This declares a new smart contract named 'ConsoleTest'.
    // 'is Test' means that 'ConsoleTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities, including console logging.

    function testLog() public pure {
        // This test function demonstrates the use of `console.log` for debugging and logging.
        // 'public' means this function can be called from anywhere.
        // 'pure' means this function does not read from or modify the state of the blockchain.
        // It's a good practice to use `pure` when a function's logic doesn't depend on or change any state variables.

        int256 x = -1;
        // Declares a signed integer variable 'x' and initializes it to -1.

        console.log("Log from test", x);
        // This is a Foundry-specific cheat code for logging messages to the console during test execution.
        // It behaves similarly to `console.log` in JavaScript.
        // It's extremely useful for debugging contract logic and variable values during tests.
        // The message "Log from test" and the value of 'x' (-1) will be printed to the console.
        // Note: Only for testing purposes - `console.log` is not available in deployed production contracts.

        console.logInt(x);
        // This is another `console.log` variant specifically for logging integer values.
        // It will print the integer value of 'x' (-1) to the console.
    }
}
