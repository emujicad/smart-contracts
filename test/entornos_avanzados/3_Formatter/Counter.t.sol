// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

import {Test, console, stdError} from "forge-std/Test.sol";
// This line imports specific components from the 'forge-std/Test.sol' library.
// - `Test`: The base contract for writing tests in Foundry.
// - `console`: Provides `console.log` for debugging.
// - `stdError`: Provides standard Solidity error types for `vm.expectRevert`.

import {Counter} from "../../../src/entornos_avanzados/3_Formatter/Counter.sol";
// This line imports the 'Counter' contract from the 'src' directory.
// This is the contract that we are going to test.

contract CounterTest is Test {
    // This declares a new smart contract named 'CounterTest'.
    // 'is Test' means that 'CounterTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    Counter public counter;
    // This declares a state variable 'counter' of type 'Counter'.
    // This variable will hold an instance of the 'Counter' contract, allowing us to interact with it in our tests.

    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        counter = new Counter();
        // This line deploys a new instance of the 'Counter' contract and assigns its address to 'counter'.
        // Each test will get its own fresh instance of the contract.

        counter.setNumber(0);
        // We call the `setNumber` function on our deployed `counter` contract to initialize its value to 0.

        assertEq(counter.number(), 0, "Initial number should be 0");
        // `assertEq()` is an assertion function from `forge-std/Test.sol`.
        // It checks if two values are equal. Here, we assert that the `number` variable in the `counter` contract
        // is indeed 0 after initialization. The third argument is an optional error message.
    }

    function test_Increment() public {
        // This test function checks if the `increment()` function works correctly.

        counter.increment();
        // Calls the `increment()` function on the `counter` contract.

        assertEq(counter.number(), 1, "Number should be incremented to 1");
        // Asserts that the `number` variable is now 1 after incrementing from 0.
    }

    function test_Decrement() public {
        // This test function checks the behavior of `decrement()` when it would cause an underflow.
        // In Solidity 0.8.0+, arithmetic operations automatically revert on underflow/overflow.

        vm.expectRevert(stdError.arithmeticError);
        // `vm.expectRevert()` is a cheat code that tells Foundry to expect the next function call to revert.
        // `stdError.arithmeticError` is a specific error type that Solidity throws for arithmetic underflows/overflows.
        // We expect the `decrement()` call to revert with this specific error because `number` is 0,
        // and decrementing it would cause an underflow.

        counter.decrement();
        // Calls the `decrement()` function. We expect this call to revert.
    }

    function testFuzz_SetNumber(uint256 x) public {
        // This is a "fuzz test" function. Foundry's fuzzer will call this function multiple times
        // with different random values for `x`. This helps find edge cases that might be missed
        // with traditional unit tests.

        counter.setNumber(x);
        // Calls the `setNumber()` function with the fuzzed value `x`.

        assertEq(counter.number(), x, "Number should be set to the fuzzed value");
        // Asserts that the `number` variable in the contract has been correctly set to the fuzzed value `x`.
        // This test ensures that `setNumber` works for a wide range of inputs.
    }
}
