# Auction Contract Tests (Auction.t.sol)

This Solidity contract (`Auction.t.sol`) contains the unit tests for the `CAuction.sol` contract. It uses the Foundry testing framework, which is popular in the Solidity ecosystem for its speed and "cheat codes" that facilitate manipulating the blockchain environment during tests.

## Key Features

*   **Test Setup (`setUp`)**: Initializes a new instance of the `CAuction` contract before each test, ensuring a clean testing environment.
*   **Time-Based Tests**: Uses `vm.warp()` to simulate the passage of time and test the auction's behavior at different phases (before starting, during, and after ending).
*   **Revert Handling**: Employs `vm.expectRevert()` to verify that functions revert with the expected error message under certain conditions.
*   **`block.timestamp` and `block.number` Manipulation**: Demonstrates how Foundry's "cheat codes" (`skip`, `rewind`, `vm.roll`) allow controlling time and block number for precise testing.

## Solidity and Foundry Concepts to Learn

*   **`pragma solidity ^0.8.24;`**: Defines the Solidity compiler version.
*   **`import "forge-std/Test.sol";`**: Imports Foundry's standard test library.
*   **`import "../../src/8_TestTime/Auction.sol";`**: Imports the contract to be tested.
*   **`contract AuctionTest is Test { ... }`**: Declaration of the test contract, inheriting from `Test`.
*   **`setUp()`**: Special function executed before each test. Ideal for initializing state.
*   **`vm.warp(timestamp)`**: Cheat code to set the current block's timestamp.
*   **`vm.expectRevert("message");`**: Cheat code to expect the next function call to revert with a specific message.
*   **`assertEq(expected, actual);`**: Assertion function to check if two values are equal.
*   **`skip(seconds)`**: Cheat code to advance the block's timestamp by a number of seconds.
*   **`rewind(seconds)`**: Cheat code to rewind the block's timestamp by a number of seconds.
*   **`vm.roll(blockNumber)`**: Cheat code to set the current block number.
*   **`block.timestamp`**: Global variable representing the current block's timestamp.
*   **`block.number`**: Global variable representing the current block number.

## How the Tests Work

1.  **`setUp()`**: Before each test, a new instance of the `CAuction` contract is created.
2.  **`testOfferBeforeAuctionStarts()`**: The test manipulates time to be before the auction starts and verifies that the `offer()` function reverts with the correct error message.
3.  **`testOffer()`**: The test advances time to be during the auction and verifies that the `offer()` function executes without reverting.
4.  **`testOfferfailAfterAuctionEnds()`**: The test advances time to be after the auction has ended and verifies that the `offer()` function reverts with the correct error message.
5.  **`testTimestamp()`**: Demonstrates how `skip` and `rewind` affect `block.timestamp` and how they can be verified with `assertEq`.
6.  **`testBlockNumber()`**: Demonstrates how `vm.roll` affects `block.number` and how it can be verified.

## Usage (Running Tests)

To run these tests, you will need to have Foundry installed. Navigate to your project's root directory and run:

```bash
forge test --match-path test/8_TestTime/Auction.t.sol -vvvvv
```

Foundry will compile the contracts and execute all test functions (those starting with `test`). The results will indicate whether the tests passed or failed, helping you verify the logic of your `CAuction` contract.

This test contract is an excellent resource for learning how to write robust and efficient smart contract tests using Foundry, an essential skill for any Web3 developer.
