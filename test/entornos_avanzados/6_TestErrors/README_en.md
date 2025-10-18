# Error Handling Tests (Errors.t.sol)

This Solidity contract (`Errors.t.sol`) contains the unit tests for the `CErrors.sol` contract, which demonstrates different error handling mechanisms in Solidity. It uses the Foundry testing framework to verify that functions correctly revert with the expected messages or errors.

## Key Features

*   **General Revert Test**: Verifies that a function reverts without specifying the message.
*   **Revert with String Message Test**: Checks that a function reverts with a specific string error message.
*   **Revert with Custom Error Test**: Validates that a function reverts with a custom error defined in the contract.
*   **Custom Error Messages in `assertEq`**: Demonstrates how to add descriptive messages to assertions for better debugging.

## Solidity and Foundry Concepts to Learn

*   **`pragma solidity ^0.8.24;`**: Defines the Solidity compiler version.
*   **`import "forge-std/Test.sol";`**: Imports Foundry's standard test library.
*   **`import "../../src/6_TestErrors/Errors.sol";`**: Imports the `CErrors` contract to be tested.
*   **`contract ErrorTest is Test { ... }`**: Declaration of the test contract, inheriting from `Test`.
*   **`setUp()`**: Special function executed before each test to set up the environment, in this case, deploying a new instance of `CErrors`.
*   **`vm.expectRevert();`**: Foundry cheat code that expects the next function call to revert, regardless of the message or error type.
*   **`vm.expectRevert(bytes("message"));`**: Cheat code to expect a revert with an exact string message. The message must be converted to `bytes`.
*   **`vm.expectRevert(CustomError.selector);`**: Cheat code to expect a revert with a specific custom error. `.selector` gets the unique 4-byte identifier of the error.
*   **`assertEq(expected, actual, "message");`**: Assertion function that checks the equality of two values and displays a custom message if the assertion fails.

## How the Tests Work

1.  **`setUp()`**: Deploys a new instance of the `CErrors` contract.
2.  **`test_withoutRevert_ThrowError()`**: This test is designed to fail if run without `vm.expectRevert()`, demonstrating that unexpected reverting transactions cause test failures.
3.  **`testRevert_ThrowError()`**: Calls `throwError()` and verifies that it reverts, using `vm.expectRevert()` without a specific message.
4.  **`testRevert_RequireMessageThrowError()`**: Calls `throwError()` and verifies that it reverts with the exact string message "UnAuthorized...!".
5.  **`testRevert_ThrowCustomError()`**: Calls `throwCustomError()` and verifies that it reverts with the custom error `UnAuthorized`.
6.  **`testErrorLabel()`**: Demonstrates how custom messages in `assertEq` can help debug failing tests, showing an example of an assertion that passes and one that fails with a clear message.

## Usage (Running Tests)

To run these tests, you will need to have Foundry installed. Navigate to your project's root directory and run:

```bash
forge test --match-path test/6_TestErrors/Errors.t.sol -vvvvv
```

Foundry will compile the contracts and execute all test functions. The results will indicate whether the tests passed or failed, helping you verify the error handling logic of your `CErrors` contract.

This test contract is a valuable resource for learning how to test error handling in Solidity, a critical part of building secure and reliable smart contracts.
cure and reliable smart contracts.
