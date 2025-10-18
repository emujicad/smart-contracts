// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

import {Test, console, stdError} from "forge-std/Test.sol";
// This line imports specific components from the 'forge-std/Test.sol' library.
// - `Test`: The base contract for writing tests in Foundry.
// - `console`: Provides `console.log` for debugging.
// - `stdError`: Provides standard Solidity error types for `vm.expectRevert`.

import {helloworld} from "../../../src/entornos_avanzados/1_Helloworld/helloworld.sol";
// This line imports the 'helloworld' contract from the 'src/helloworld' directory.
// This is the contract that we are going to test.

contract helloworldTest is Test {
    // This declares a new smart contract named 'helloworldTest'.
    // 'is Test' means that 'helloworldTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    helloworld public hello;
    // This declares a state variable 'hello' of type 'helloworld'.
    // This variable will hold an instance of the 'helloworld' contract, allowing us to interact with it in our tests.

    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        hello = new helloworld();
        // This line deploys a new instance of the 'helloworld' contract and assigns its address to 'hello'.
        // Each test will get its own fresh instance of the contract.
    }

    function test_GetMessage() public view {
        // This test function checks if the `getMessage()` function returns the expected initial message.
        // 'public view' means this function can be called from anywhere and does not modify the blockchain state.

        string memory message = hello.getMessage();
        // Calls the `getMessage()` function on our deployed `hello` contract and stores the returned string.

        assertEq(message, "Hello, World from foundry!");
        // `assertEq()` is an assertion function from `forge-std/Test.sol`.
        // It checks if two values are equal. Here, we assert that the retrieved message is the expected initial message.
    }

    function test_UpdateMessage() public {
        // This test function checks if the `updateMessage()` function correctly changes the message.

        string memory newMessage = "Hello, Foundry from test!";
        // Defines a new message that we will use to update the contract's message.

        hello.updateMessage(newMessage);
        // Calls the `updateMessage()` function on the `hello` contract, passing the new message.
        // This is a state-changing operation.

        string memory updatedMessage = hello.getMessage();
        // Calls `getMessage()` again to retrieve the message after the update.

        assertEq(updatedMessage, newMessage, "Message should be updated correctly");
        // Asserts that the message retrieved after the update is equal to the `newMessage` we set.
        // The third argument is an optional error message that will be displayed if the assertion fails.
    }
}
