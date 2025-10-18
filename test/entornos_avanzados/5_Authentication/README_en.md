# Wallet Contract Tests (Wallet.t.sol)

This Solidity contract (`Wallet.t.sol`) contains the unit tests for the `Wallet.sol` contract. It uses the Foundry testing framework to verify the ownership change functionality and access control of the wallet contract. It's a key example for understanding how to test security and permissions in smart contracts.

## Key Features

*   **Test Setup (`setUp`)**: Deploys a new instance of the `Wallet` contract before each test.
*   **Owner Change Test**: Verifies that the `changeOwner()` function correctly updates the owner's address.
*   **Non-Owner Failure Test**: Checks that the `changeOwner()` function reverts when called by an address that is not the current owner.
*   **`msg.sender` Simulation**: Uses `vm.prank()` to simulate calls from different addresses.
*   **Debugging with `console.log`**: Shows how to use `console.log` to inspect `msg.sender` and the contract owner during tests.

## Solidity and Foundry Concepts to Learn

*   **`pragma solidity ^0.8.24;`**: Defines the Solidity compiler version.
*   **`import "forge-std/Test.sol";`**: Imports Foundry's standard test library.
*   **`import "../../src/5_Authentication/Wallet.sol";`**: Imports the `Wallet` contract to be tested.
*   **`contract WalletTest is Test { ... }`**: Declaration of the test contract, inheriting from `Test`.
*   **`setUp()`**: Special function executed before each test to set up the environment.
*   **`vm.prank(address account);`**: Foundry cheat code to simulate that the next function call comes from the specified `account`. It's crucial for testing access control.
*   **`vm.expectRevert("error message");`**: Cheat code to expect the next function call to revert with a specific error message.
*   **`assertEq(expected, actual, "error message");`**: Assertion function to check if two values are equal.
*   **`msg.sender`**: Global variable representing the address that initiated the current transaction.
*   **`console.log(...)`**: Foundry debugging function to print information to the console.

## How the Tests Work

1.  **`setUp()`**: Deploys a new instance of the `Wallet` contract. The `msg.sender` that deploys the test contract (`WalletTest`) becomes the initial owner of the `Wallet` contract.
2.  **`test_changeOwner()`**:
    *   Defines a `newOwner` address.
    *   Calls `wallet.changeOwner(newOwner)` from the `WalletTest` (which is the initial owner).
    *   Verifies with `assertEq` that the `Wallet` contract's owner has been correctly updated to `newOwner`.
3.  **`test_failNotOwner()`**:
    *   Uses `vm.prank(address(0x00000124))` to simulate that the next call comes from an address other than the owner.
    *   Uses `vm.expectRevert("Error: Only owner can change owner")` to expect the `changeOwner()` call to fail with the specific error message.
    *   Calls `wallet.changeOwner()` from the simulated "non-owner" address, confirming that the access restriction works.

## Usage (Running Tests)

To run these tests, you will need to have Foundry installed. Navigate to your project's root directory and run:

```bash
forge test --match-path test/5_Authentication/Wallet.t.sol -vvvvv
```

Foundry will compile the contracts and execute all test functions. The results will indicate whether the tests passed or failed, helping you verify the access control logic of your `Wallet` contract.

This test contract is an essential resource for learning how to test security and permissions in Solidity, critical skills for building robust and reliable smart contracts.
bust and reliable smart contracts.
