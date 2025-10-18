// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library.
// 'forge-std' is a standard library for Foundry, providing essential utilities for writing tests in Solidity.

import "../../../src/entornos_avanzados/6_TestErrors/Errors.sol";
// This line imports the 'CErrors.sol' contract from the 'src' directory.
// This is the contract that we are going to test, which demonstrates different error handling mechanisms.

contract ErrorTest is Test {
    // This declares a new smart contract named 'ErrorTest'.
    // 'is Test' means that 'ErrorTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    CErrors public cerr;
    // This declares a state variable 'cerr' of type 'CErrors'.
    // This variable will hold an instance of the 'CErrors' contract, allowing us to interact with it in our tests.

    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        cerr = new CErrors();
        // This line deploys a new instance of the 'CErrors' contract and assigns its address to 'cerr'.
        // Each test will get its own fresh instance of the contract.
    }

    function test_withoutRevert_ThrowError() public view {
        // This test function demonstrates what happens if you call a function that is expected to revert,
        // but you do not use `vm.expectRevert()`.
        // This test is designed to fail to show the importance of `vm.expectRevert`.

        cerr.throwError();
        // This calls the `throwError()` function on our deployed `cerr` contract.
        // Since `throwError()` contains `require(false, ...)`, this call will revert,
        // causing the test to fail if `vm.expectRevert` is not used.
    }

    function testRevert_ThrowError() public {
        // This test function correctly checks if `throwError()` reverts.

        vm.expectRevert();
        // `vm.expectRevert()` is a cheat code that tells Foundry to expect the next function call to revert.
        // It doesn't specify the exact error message, just that a revert should occur.

        cerr.throwError();
        // This calls the `throwError()` function. We expect it to revert, so this test should pass.
    }

    function testRevert_RequireMessageThrowError() public {
        // This test function checks if `throwError()` reverts with a specific string message.

        vm.expectRevert(bytes("UnAuthorized...!"));
        // `vm.expectRevert(bytes("..."))` is used to expect a revert with a specific string message.
        // The string message must be converted to `bytes`.

        cerr.throwError();
        // This calls the `throwError()` function. We expect it to revert with the exact message "UnAuthorized...!",
        // so this test should pass.
    }

    function testRevert_ThrowCustomError() public {
        // This test function checks if `throwCustomError()` reverts with a specific custom error.

        vm.expectRevert(CErrors.UnAuthorized.selector);
        // `vm.expectRevert(CustomError.selector)` is used to expect a revert with a specific custom error.
        // `.selector` gets the 4-byte function selector of the custom error, which is how custom errors are identified on-chain.

        cerr.throwCustomError();
        // This calls the `throwCustomError()` function. We expect it to revert with the `UnAuthorized` custom error,
        // so this test should pass.
    }

    function testErrorLabel() public pure {
        // This test function demonstrates the use of custom error messages in `assertEq`.
        // 'pure' is used as this function does not interact with the blockchain state.

        assertEq(uint256(1), uint256(1), "This is a custom label1 message for assertEq");
        // This assertion will pass, and the custom message will not be shown.
        // It shows how to provide a descriptive message for successful assertions.

        assertEq(uint256(1), uint256(2), "This is a custom label2 message for assertEq");
        // This assertion will fail because 1 is not equal to 2.
        // When it fails, the custom message "This is a custom label2 message for assertEq" will be displayed,
        // helping to quickly identify the cause of the test failure.

        // The commented lines below are examples of how `vm.expectRevert` would be used,
        // but they are commented out to allow the `assertEq` failures to be demonstrated.
        //vm.expectRevert(CErrors.UnAuthorized.selector); // Expect a revert with the custom error UnAuthorized
        //cerr.throwCustomError(); // Call the function that should revert.
    }
}
